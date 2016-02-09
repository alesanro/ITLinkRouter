//
//  ITLinkNavigationControllerTests.m
//  ITLinkRouter
//
//  Created by Alex Rudyak on 2/2/16.
//  Copyright © 2016 Alex Rudyak. All rights reserved.
//

#import "ITSupportClassStructure.h"

SpecBegin(ITLinkNavigationControllerTests);

__block ITLinkNavigationController *moduleNavigator;
__block ITLinkChain *defaultChain;
__block ITLinkNode *entity1, *entity2;

beforeEach(^{
    entity1 = [[ITLinkAction alloc] initWithModuleName:ITModuleNameFromClass([_ITRootModuleRouter class]) link:@selector(navigateToLogin:) arguments:@[ @"Password" ]];
    _ITRootModuleRouter *const entity1Router = [[_ITRootModuleRouter alloc] init];
    entity1.router = entity1Router;

    entity2 = [[ITLinkAction alloc] initWithModuleName:ITModuleNameFromClass([_ITLoginModuleRouter class]) link:@selector(navigateToSignInWithUser:password:) arguments:@[ @"Alex", @"123" ]];
    _ITLoginModuleRouter *const entity2Router = [[_ITLoginModuleRouter alloc] init];
    entity2.router = entity2Router;

    defaultChain = [[ITLinkChain alloc] initWithEntities:@[entity1, entity2]];
    moduleNavigator = [[ITLinkNavigationController alloc] initWithChain:defaultChain];
    [((_ITBasicRouter *)entity1.router) setModuleNavigator:moduleNavigator];
    [((_ITBasicRouter *)entity2.router) setModuleNavigator:moduleNavigator];
});

afterAll(^{
    moduleNavigator = nil;
    entity1 = nil;
    entity2 = nil;
    defaultChain = nil;
});

describe(@"initializatin stage", ^{

         });

describe(@"checking properties after initialization", ^{
    it(@"should not to be nil", ^{
        expect(moduleNavigator.activeEntity).notTo.beNil();
        expect([ITLinkNode isValue:moduleNavigator.activeEntity]).to.beTruthy();
        expect(moduleNavigator.rootEntity).notTo.beNil();
        expect(moduleNavigator.rootEntity).equal(entity1);
        expect(moduleNavigator.navigationChain).notTo.beNil();
    });
});

describe(@"checking push manipulation", ^{
    it(@"with valid link should add new entity", ^{
        ITLinkNode *const nextEntity = [ITLinkNode linkValueWithModuleName:ITModuleNameFromClass([_ITFeedModuleRouter class])];
        _ITFeedModuleRouter *router = [_ITFeedModuleRouter new];
        router.moduleNavigator = moduleNavigator;
        [nextEntity setRouter:router];

        ITLinkNode *const actionEntity = [ITLinkNode linkActionWithNode:moduleNavigator.activeEntity link:@selector(navigateToSignInWithUser:password:) arguments:@[@"Alex", @"123"]];

        const NSInteger prevChainLength = moduleNavigator.navigationChain.length;
        [moduleNavigator pushLink:actionEntity withResultValue:nextEntity];
        expect(moduleNavigator.activeEntity).equal(nextEntity);
        expect(moduleNavigator.navigationChain.lastEntity).equal(nextEntity);
        expect(moduleNavigator.navigationChain.length).equal(prevChainLength + 1);
    });

    it(@"with empty link should throw exception", ^{
        expect(^{
            [moduleNavigator pushLink:nil withResultValue:nil];
        }).to.raise(NSInternalInconsistencyException);

        ITLinkNode *const actionEntity = [ITLinkNode linkActionWithNode:moduleNavigator.activeEntity link:@selector(navigateToSignInWithUser:password:) arguments:@[@"Alex", @"123"]];
        expect(^{
            [moduleNavigator pushLink:actionEntity withResultValue:nil];
        }).to.raise(NSInternalInconsistencyException);


        _ITProfileModuleRouter *const profileRouter = [_ITProfileModuleRouter new];
        profileRouter.moduleNavigator = moduleNavigator;
        ITLinkNode *const wrongEntity = [ITLinkNode linkActionWithModuleName:ITModuleNameFromClass(profileRouter.class) link:@selector(editNumber:) arguments:@[@"1234567890"] router:profileRouter];
        ITLinkNode *const nextEntity = [ITLinkNode linkValueWithModuleName:ITModuleNameFromClass([_ITFeedModuleRouter class])];
        expect(^{
            [moduleNavigator pushLink:wrongEntity withResultValue:nextEntity];
        }).to.raise(ITNavigationInvalidLinkSimilarity);
    });
});

describe(@"checking pop manipulation", ^{
    it(@"with non-empty navigation chain should proceed", ^{
        ITLinkNode *const prevActiveEntity = moduleNavigator.activeEntity;
        const NSInteger prevChainLength = moduleNavigator.navigationChain.length;
        [moduleNavigator popLink];
        expect(moduleNavigator.activeEntity).toNot.equal(prevActiveEntity);
        expect(moduleNavigator.navigationChain.length).equal(prevChainLength - 1);
        expect(moduleNavigator.navigationChain.lastEntity).toNot.equal(prevActiveEntity);
    });
});

describe(@"performing navigation by link chain", ^{
    __block ITLinkAction *entity3;
    __block ITLinkChain *destinationChain;
    beforeEach(^{
        entity3 = [[ITLinkAction alloc] initWithModuleName:ITModuleNameFromClass([_ITLoginModuleRouter class]) link:@selector(navigateToSignUp) arguments:nil];
        destinationChain = [[ITLinkChain alloc] initWithEntities:@[entity1, entity3]];
    });

    it(@"with the same route should reload only last item", ^{
        ITLinkNode *const entity4 = [ITLinkNode linkActionWithAction:(id)entity2 arguments:@[@"Robin", @"abc"]];
        ITLinkChain *const sameChain = [[ITLinkChain alloc] initWithEntities:@[entity1, [entity4 flatten]]];
        ITLinkNavigationController *navigationController = OCMPartialMock(moduleNavigator);
        [OCMReject(navigationController) popLink];
        [OCMReject(navigationController) pushLink:[OCMArg any] withResultValue:[OCMArg any]];
        [moduleNavigator navigateToNewChain:sameChain];
    });

    it(@"with empty destination chain controller should do nothing", ^{
        ITLinkChain *const emptyDestination = [[ITLinkChain alloc] initWithEntities:nil];
        ITLinkNavigationController *navigationController = OCMPartialMock(moduleNavigator);
        [OCMReject(navigationController) popLink];
        [OCMReject(navigationController) pushLink:[OCMArg any] withResultValue:[OCMArg any]];
        [navigationController navigateToNewChain:emptyDestination];

        navigationController = OCMPartialMock([[ITLinkNavigationController alloc] initWithChain:emptyDestination]);
        [OCMReject(navigationController) popLink];
        [OCMReject(navigationController) pushLink:[OCMArg any] withResultValue:[OCMArg any]];
        [navigationController navigateToNewChain:defaultChain];
    });

    it(@"with having no common part (root) should do nothing", ^{
        ITLinkNode *const singleNode = [ITLinkNode linkValueWithModuleName:@"OtherModule"];
        ITLinkChain *const otherChain = [[ITLinkChain alloc] initWithEntities:@[singleNode]];
        ITLinkNavigationController *navigationController = OCMPartialMock(moduleNavigator);
        [OCMReject(navigationController) popLink];
        [OCMReject(navigationController) pushLink:[OCMArg any] withResultValue:[OCMArg any]];
        [navigationController navigateToNewChain:otherChain];
    });

    context(@"with some common root route should", ^{
        describe(@"navigate back and forward", ^{
            it(@"when one link back and one forward", ^{

            });

            it(@"when more then one back and one forward", ^{

            });

            it(@"when one link back and more then one forward", ^{

            });

            it(@"when more then one back and forward", ^{

            });
        });

        describe(@"navigate back", ^{
            it(@"when one link", ^{

            });

            it(@"when more then one link back", ^{

            });
        });

        describe(@"navigate forward", ^{
            it(@"when one link forward", ^{

            });

            it(@"when more then one link forward", ^{

            });
        });
    });

});

SpecEnd
