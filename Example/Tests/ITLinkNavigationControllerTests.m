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
__block _TestModuleRouter *rootRouter;

beforeEach(^{
    id<_ModuleNameBuilderable> const builder = [_TestArrayModuleNameBuilder builderWithNames:@[@"RootModule", @"LoginModule", @"MainModule"]];
    rootRouter = [[_TestModuleRouter alloc] initWithBuildable:builder completion:^(_TestModuleRouter *moduleRouter) {
        entity1 = [ITLinkNode linkActionWithModuleName:moduleRouter.moduleName link:@selector(navigateToA:) arguments:@[ @"Password" ] router:moduleRouter];

        moduleRouter.moduleA = [[_TestModuleRouter alloc] initWithBuildable:builder completion:^(_TestModuleRouter *moduleRouter) {
            entity2 = [ITLinkNode linkValueWithModuleName:moduleRouter.moduleName router:moduleRouter];
            id<_ModuleNameBuilderable> const otherBuilder = [_TestArrayModuleNameBuilder builderWithNames:@[@"FeedALoginModule", @"FeedBLoginModule", @"FeedCLoginModule"]];
            moduleRouter.moduleA = [[_TestModuleRouter alloc] initWithBuildable:otherBuilder completion:nil];
            moduleRouter.moduleB = [[_TestModuleRouter alloc] initWithBuildable:otherBuilder completion:^(_TestModuleRouter *moduleRouter) {
                id<_ModuleNameBuilderable> const otherBuilder = [_TestArrayModuleNameBuilder builderWithNames:@[@"NewsDetailALoginModule", @"NewsDetailBLoginModule", @"NewsDetailCLoginModule"]];
                moduleRouter.moduleA = [[_TestModuleRouter alloc] initWithBuildable:otherBuilder completion:nil];
                moduleRouter.moduleB = [[_TestModuleRouter alloc] initWithBuildable:otherBuilder completion:nil];
                moduleRouter.moduleC = [[_TestModuleRouter alloc] initWithBuildable:otherBuilder completion:nil];
            }];
            moduleRouter.moduleC = [[_TestModuleRouter alloc] initWithBuildable:otherBuilder completion:nil];
        }];
        moduleRouter.moduleC = [[_TestModuleRouter alloc] initWithBuildable:builder completion:^(_TestModuleRouter *moduleRouter) {
            entity2 = [ITLinkNode linkValueWithModuleName:moduleRouter.moduleName router:moduleRouter];
            id<_ModuleNameBuilderable> const otherBuilder = [_TestArrayModuleNameBuilder builderWithNames:@[@"FeedAMainModule", @"FeedBMainModule", @"FeedCMainModule"]];
            moduleRouter.moduleA = [[_TestModuleRouter alloc] initWithBuildable:otherBuilder completion:nil];
            moduleRouter.moduleB = [[_TestModuleRouter alloc] initWithBuildable:otherBuilder completion:nil];
            moduleRouter.moduleC = [[_TestModuleRouter alloc] initWithBuildable:otherBuilder completion:^(_TestModuleRouter *moduleRouter) {
                id<_ModuleNameBuilderable> const otherBuilder = [_TestArrayModuleNameBuilder builderWithNames:@[@"NewsDetailAMainModule", @"NewsDetailBMainModule", @"NewsDetailCMainModule"]];
                moduleRouter.moduleA = [[_TestModuleRouter alloc] initWithBuildable:otherBuilder completion:nil];
                moduleRouter.moduleB = [[_TestModuleRouter alloc] initWithBuildable:otherBuilder completion:nil];
                moduleRouter.moduleC = [[_TestModuleRouter alloc] initWithBuildable:otherBuilder completion:nil];
            }];
        }];
    }];

    defaultChain = [[ITLinkChain alloc] initWithEntities:@[entity1, entity2]];
    moduleNavigator = OCMPartialMock([[ITLinkNavigationController alloc] initWithChain:defaultChain]);
    [rootRouter setModuleNavigator:moduleNavigator];
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
        expect([moduleNavigator.activeEntity isEqual:[moduleNavigator.activeEntity flatten]]).to.beTruthy();
        expect(moduleNavigator.rootEntity).notTo.beNil();
        expect(moduleNavigator.rootEntity).equal(entity1);
        expect(moduleNavigator.navigationChain).notTo.beNil();
    });
});

describe(@"checking push manipulation", ^{
    it(@"with valid link should add new entity", ^{
        __block ITLinkNode * nextEntity;

        _TestModuleRouter *const nextRouter = [rootRouter childRouterWithModuleName:@"FeedBLoginModule"];
        assert(nextRouter);
        nextEntity = [ITLinkNode linkValueWithModuleName:nextRouter.moduleName router:nextRouter];
        ITLinkNode *const actionEntity = [ITLinkNode linkActionWithNode:moduleNavigator.activeEntity link:@selector(navigateToB:) arguments:@[@"Bob"]];

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

        ITLinkNode *const actionEntity = [ITLinkNode linkActionWithNode:moduleNavigator.activeEntity link:@selector(navigateToA:) arguments:@[@"Bob"]];
        expect(^{
            [moduleNavigator pushLink:actionEntity withResultValue:nil];
        }).to.raise(NSInternalInconsistencyException);


        id<_ModuleNameBuilderable> const builder = [_TestArrayModuleNameBuilder builderWithNames:@[@"WrongModule"]];
        __block ITLinkNode *wrongEntity;
        _TestModuleRouter *const wrongRouter = [[_TestModuleRouter alloc] initWithBuildable:builder completion:^(_TestModuleRouter *moduleRouter) {
            wrongEntity = [ITLinkNode linkActionWithModuleName:moduleRouter.moduleName link:@selector(navigateToA) arguments:nil router:moduleRouter];
        }];
        wrongRouter.moduleNavigator = moduleNavigator;
        ITLinkNode *const nextEntity = [ITLinkNode linkValueWithModuleName:@"UnreachableModule"];
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
    context(@"when no navigation should be performed because of", ^{
        it(@"destination chain has the same route and should do nothing", ^{
            ITLinkNode *const entity4 = [ITLinkNode linkValueWithModuleName:entity2.moduleName];
            ITLinkChain *const sameChain = [[ITLinkChain alloc] initWithEntities:@[entity1, entity4]];
            [OCMReject(moduleNavigator) popLink];
            [OCMReject(moduleNavigator) pushLink:[OCMArg any] withResultValue:[OCMArg any]];
            [moduleNavigator navigateToNewChain:sameChain];
        });

        it(@"destination chain is empty and should do nothing", ^{
            ITLinkChain *const emptyDestination = [[ITLinkChain alloc] initWithEntities:nil];
            ITLinkNavigationController *navigationController = moduleNavigator;
            [OCMReject(navigationController) popLink];
            [OCMReject(navigationController) pushLink:[OCMArg any] withResultValue:[OCMArg any]];
            [navigationController navigateToNewChain:emptyDestination];

            navigationController = OCMPartialMock([[ITLinkNavigationController alloc] initWithChain:emptyDestination]);
            [OCMReject(navigationController) popLink];
            [OCMReject(navigationController) pushLink:[OCMArg any] withResultValue:[OCMArg any]];
            [navigationController navigateToNewChain:defaultChain];
        });

        it(@"destination chain has no common part (root) and should do nothing", ^{
            ITLinkNode *const singleNode = [ITLinkNode linkValueWithModuleName:@"OtherRootModule"];
            ITLinkChain *const otherChain = [[ITLinkChain alloc] initWithEntities:@[singleNode]];
            [OCMReject(moduleNavigator) popLink];
            [OCMReject(moduleNavigator) pushLink:[OCMArg any] withResultValue:[OCMArg any]];
            [moduleNavigator navigateToNewChain:otherChain];
        });
    });


    context(@"with some common root route navigation should", ^{
        describe(@"navigate back and forward with", ^{
            __block ITLinkNavigationController *navigationControllerInternal;

            beforeEach(^{
                _TestModuleRouter *const firstRouter = [rootRouter childRouterWithModuleName:@"RootModule"];
                ITLinkNode *const rootNode = [ITLinkNode linkActionWithModuleName:firstRouter.moduleName link:@selector(navigateToA) arguments:nil router:firstRouter];
                _TestModuleRouter *const loginRouter = [rootRouter childRouterWithModuleName:@"LoginModule"];
                ITLinkNode *const loginNode = [ITLinkNode linkActionWithModuleName:loginRouter.moduleName link:@selector(navigateToA:) arguments:@[@"TestUser1"] router:loginRouter];
                _TestModuleRouter *const feedARouter = [rootRouter childRouterWithModuleName:@"FeedALoginModule"];
                ITLinkNode *const feedNode = [ITLinkNode linkValueWithModuleName:feedARouter.moduleName router:feedARouter];
                ITLinkChain *const navigationChain = [[ITLinkChain alloc] initWithEntities:@[rootNode, loginNode, feedNode]];
                navigationControllerInternal = OCMPartialMock([[ITLinkNavigationController alloc] initWithChain:navigationChain]);
                firstRouter.moduleNavigator = navigationControllerInternal;
            });

            it(@"one link back and one forward", ^{
                ITLinkNode *const rootNode = [ITLinkNode linkActionWithModuleName:@"RootModule" link:@selector(navigateToA) arguments:nil];
                ITLinkNode *const loginNode = [ITLinkNode linkActionWithModuleName:@"LoginModule" link:@selector(navigateToC:) arguments:@[@"Bob"]];
                ITLinkNode *const feedNode = [ITLinkNode linkValueWithModuleName:@"FeedCLoginModule"];
                ITLinkChain *const destinationChain = [[ITLinkChain alloc] initWithEntities:@[rootNode, loginNode, feedNode]];

                [navigationControllerInternal navigateToNewChain:destinationChain];
                OCMVerify([navigationControllerInternal popLink]);
                OCMVerify([navigationControllerInternal pushLink:[OCMArg any] withResultValue:[OCMArg any]]);
                expect(navigationControllerInternal.navigationChain.length).to.equal(destinationChain.length);
                expect(navigationControllerInternal.navigationChain.lastEntity).to.equal(feedNode);
            });

            it(@"more then one back and one forward", ^{
                ITLinkNode *const rootNode = [ITLinkNode linkActionWithModuleName:@"RootModule" link:@selector(navigateToC:) arguments:@[@"Main"]];
                ITLinkNode *const mainNode = [ITLinkNode linkValueWithModuleName:@"MainModule"];
                ITLinkChain *const destinationChain = [[ITLinkChain alloc] initWithEntities:@[rootNode, mainNode]];

                [navigationControllerInternal navigateToNewChain:destinationChain];
                OCMVerify([navigationControllerInternal popLink]);
                OCMVerify([navigationControllerInternal popLink]);
                OCMVerify([navigationControllerInternal pushLink:[OCMArg any] withResultValue:[OCMArg any]]);
                expect(navigationControllerInternal.navigationChain.length).to.equal(destinationChain.length);
                expect(navigationControllerInternal.navigationChain.lastEntity).to.equal(mainNode);
            });

            it(@"one link back and more then one forward", ^{
                ITLinkNode *const rootNode = [ITLinkNode linkActionWithModuleName:@"RootModule" link:@selector(navigateToA) arguments:nil];
                ITLinkNode *const loginNode = [ITLinkNode linkActionWithModuleName:@"LoginModule" link:@selector(navigateToB:) arguments:@[@"Bob"]];
                ITLinkNode *const feedNode = [ITLinkNode linkActionWithModuleName:@"FeedBLoginModule" link:@selector(navigateToB) arguments:nil];
                ITLinkNode *const newsNode = [ITLinkNode linkValueWithModuleName:@"NewsDetailBLoginModule"];
                ITLinkChain *const destinationChain = [[ITLinkChain alloc] initWithEntities:@[rootNode, loginNode, feedNode, newsNode]];

                [navigationControllerInternal navigateToNewChain:destinationChain];
                OCMVerify([navigationControllerInternal popLink]);
                OCMVerify([navigationControllerInternal pushLink:[OCMArg any] withResultValue:[OCMArg any]]);
                OCMVerify([navigationControllerInternal pushLink:[OCMArg any] withResultValue:[OCMArg any]]);
                expect(navigationControllerInternal.navigationChain.length).to.equal(destinationChain.length);
                expect(navigationControllerInternal.navigationChain.lastEntity).to.equal(newsNode);
            });

            it(@"more then one back and forward", ^{
                ITLinkNode *const rootNode = [ITLinkNode linkActionWithModuleName:@"RootModule" link:@selector(navigateToC) arguments:nil];
                ITLinkNode *const loginNode = [ITLinkNode linkActionWithModuleName:@"MainModule" link:@selector(navigateToC:) arguments:@[@"Alice"]];
                ITLinkNode *const feedNode = [ITLinkNode linkActionWithModuleName:@"FeedCMainModule" link:@selector(navigateToA) arguments:nil];
                ITLinkNode *const newsNode = [ITLinkNode linkValueWithModuleName:@"NewsDetailAMainModule"];
                ITLinkChain *const destinationChain = [[ITLinkChain alloc] initWithEntities:@[rootNode, loginNode, feedNode, newsNode]];

                [navigationControllerInternal navigateToNewChain:destinationChain];
                OCMVerify([navigationControllerInternal popLink]);
                OCMVerify([navigationControllerInternal popLink]);
                OCMVerify([navigationControllerInternal pushLink:[OCMArg any] withResultValue:[OCMArg any]]);
                OCMVerify([navigationControllerInternal pushLink:[OCMArg any] withResultValue:[OCMArg any]]);
                expect(navigationControllerInternal.navigationChain.length).to.equal(destinationChain.length);
                expect(navigationControllerInternal.navigationChain.lastEntity).to.equal(newsNode);
            });
        });

        describe(@"navigate back with", ^{
            __block ITLinkNavigationController *navigationControllerInternal;

            beforeEach(^{
                _TestModuleRouter *const firstRouter = [rootRouter childRouterWithModuleName:@"RootModule"];
                ITLinkNode *const rootNode = [ITLinkNode linkActionWithModuleName:firstRouter.moduleName link:@selector(navigateToA) arguments:nil router:firstRouter];
                _TestModuleRouter *const loginRouter = [rootRouter childRouterWithModuleName:@"LoginModule"];
                ITLinkNode *const loginNode = [ITLinkNode linkActionWithModuleName:loginRouter.moduleName link:@selector(navigateToA:) arguments:@[@"TestUser1"] router:loginRouter];
                _TestModuleRouter *const feedARouter = [rootRouter childRouterWithModuleName:@"FeedALoginModule"];
                ITLinkNode *const feedNode = [ITLinkNode linkValueWithModuleName:feedARouter.moduleName router:feedARouter];
                ITLinkChain *const navigationChain = [[ITLinkChain alloc] initWithEntities:@[rootNode, loginNode, feedNode]];
                navigationControllerInternal = OCMPartialMock([[ITLinkNavigationController alloc] initWithChain:navigationChain]);
                firstRouter.moduleNavigator = navigationControllerInternal;
            });

            it(@"one link", ^{
                ITLinkNode *const rootNode = [ITLinkNode linkActionWithModuleName:@"RootModule" link:@selector(navigateToA) arguments:nil];
                ITLinkNode *const loginNode = [ITLinkNode linkValueWithModuleName:@"LoginModule"];
                ITLinkChain *const destinationChain = [[ITLinkChain alloc] initWithEntities:@[rootNode, loginNode]];

                [OCMReject(navigationControllerInternal) pushLink:[OCMArg any] withResultValue:[OCMArg any]];
                [navigationControllerInternal navigateToNewChain:destinationChain];
                OCMVerify([navigationControllerInternal popLink]);
                expect(navigationControllerInternal.navigationChain.length).to.equal(destinationChain.length);
                expect(navigationControllerInternal.navigationChain.rootEntity).to.equal(rootNode);
            });

            it(@"more then one link", ^{
                ITLinkNode *const rootNode = [ITLinkNode linkValueWithModuleName:@"RootModule"];
                ITLinkChain *const destinationChain = [[ITLinkChain alloc] initWithEntities:@[rootNode]];

                [OCMReject(navigationControllerInternal) pushLink:[OCMArg any] withResultValue:[OCMArg any]];
                [navigationControllerInternal navigateToNewChain:destinationChain];
                OCMVerify([navigationControllerInternal popLink]);
                OCMVerify([navigationControllerInternal popLink]);
                expect(navigationControllerInternal.navigationChain.length).to.equal(destinationChain.length);
                expect(navigationControllerInternal.navigationChain.lastEntity).to.equal(rootNode);
            });
        });

        describe(@"navigate forward with", ^{
            __block ITLinkNavigationController *navigationControllerInternal;

            beforeEach(^{
                _TestModuleRouter *const firstRouter = [rootRouter childRouterWithModuleName:@"RootModule"];
                ITLinkNode *const rootNode = [ITLinkNode linkValueWithModuleName:firstRouter.moduleName router:firstRouter];
                ITLinkNavigationController *linkController = [[ITLinkNavigationController alloc] initWithRootEntity:rootNode];
                navigationControllerInternal = OCMPartialMock(linkController);
                firstRouter.moduleNavigator = navigationControllerInternal;
            });

            it(@"one link", ^{
                ITLinkNode *const rootNode = [ITLinkNode linkActionWithNode:navigationControllerInternal.navigationChain.lastEntity link:@selector(navigateToA:) arguments:@[@"Bob"]];
                ITLinkNode *const nextNode = [ITLinkNode linkValueWithModuleName:@"LoginModule"];
                ITLinkChain *const destinationChain = [[ITLinkChain alloc] initWithEntities:@[rootNode, nextNode]];

                [OCMReject(navigationControllerInternal) popLink];
                [navigationControllerInternal navigateToNewChain:destinationChain];
                OCMVerify([navigationControllerInternal pushLink:[OCMArg any] withResultValue:[OCMArg any]]);
                expect(navigationControllerInternal.navigationChain.length).to.equal(destinationChain.length);
                expect(navigationControllerInternal.navigationChain.lastEntity).to.equal(nextNode);
            });

            it(@"more then one link", ^{
                ITLinkNode *const rootNode = [ITLinkNode linkActionWithNode:navigationControllerInternal.navigationChain.lastEntity link:@selector(navigateToA:) arguments:@[@"Bob"]];
                ITLinkNode *const nextNode = [ITLinkNode linkActionWithModuleName:@"LoginModule" link:@selector(navigateToC) arguments:nil];
                ITLinkNode *const lastNode = [ITLinkNode linkValueWithModuleName:@"FeedCLoginModule"];
                ITLinkChain *const destinationChain = [[ITLinkChain alloc] initWithEntities:@[rootNode, nextNode, lastNode]];

                [OCMReject(navigationControllerInternal) popLink];
                [navigationControllerInternal navigateToNewChain:destinationChain];
                OCMVerify([navigationControllerInternal pushLink:[OCMArg any] withResultValue:[OCMArg any]]);
                expect(navigationControllerInternal.navigationChain.length).to.equal(destinationChain.length);
                expect(navigationControllerInternal.navigationChain.lastEntity).to.equal(lastNode);
            });
        });

        describe(@"perform proper navigation when destination chain's last link", ^{
            __block ITLinkNavigationController *navigationControllerInternal;

            beforeEach(^{
                _TestModuleRouter *const firstRouter = [rootRouter childRouterWithModuleName:@"RootModule"];
                ITLinkNode *const rootNode = [ITLinkNode linkValueWithModuleName:firstRouter.moduleName router:firstRouter];
                ITLinkNavigationController *linkController = [[ITLinkNavigationController alloc] initWithRootEntity:rootNode];
                navigationControllerInternal = OCMPartialMock(linkController);
                firstRouter.moduleNavigator = navigationControllerInternal;
            });

            it(@"is an action and result should produce one more link", ^{
                ITLinkNode *const rootNode = [ITLinkNode linkActionWithNode:navigationControllerInternal.navigationChain.lastEntity link:@selector(navigateToA:) arguments:@[@"Bob"]];
                ITLinkNode *const nextNode = [ITLinkNode linkValueWithModuleName:@"LoginModule"];
                ITLinkChain *const destinationChain = [[ITLinkChain alloc] initWithEntities:@[rootNode]];

                [navigationControllerInternal navigateToNewChain:destinationChain];
                expect(navigationControllerInternal.navigationChain.length).to.equal(destinationChain.length + 1);
                expect(navigationControllerInternal.navigationChain.lastEntity).to.equal(nextNode);
            });
        });
    });

});

SpecEnd
