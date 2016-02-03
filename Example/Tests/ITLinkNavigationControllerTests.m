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
__block ITLinkAction *entity1, *entity2;

beforeEach(^{
    entity1 = [[ITLinkAction alloc] initWithModuleName:ITModuleNameFromClass([_ITRootModuleRouter class]) link:@selector(navigateToLogin:) arguments:@[ @"Password" ]];
    _ITRootModuleRouter *const entity1Router = OCMClassMock([_ITRootModuleRouter class]);
    OCMStub([entity1Router navigateToLogin:[OCMArg any]]);
    OCMStub([entity1Router unwind]);
    entity1.router = entity1Router;

    entity2 = [[ITLinkAction alloc] initWithModuleName:ITModuleNameFromClass([_ITLoginModuleRouter class]) link:@selector(navigateToSignInWithUser:password:) arguments:@[ @"Alex", @"123" ]];
    _ITLoginModuleRouter *const entity2Router = OCMClassMock([_ITLoginModuleRouter class]);
    OCMStub([entity2Router navigateToSignInWithUser:[OCMArg any] password:[OCMArg any]]);
    OCMStub([entity2Router navigateToSignUp]);
    OCMStub([entity2Router unwind]);
    entity2.router = entity2Router;

    defaultChain = [[ITLinkChain alloc] initWithEntities:@[entity1, entity2]];
    moduleNavigator = [[ITLinkNavigationController alloc] initWithChain:defaultChain];
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
        expect(moduleNavigator.rootEntity).notTo.beNil();
        expect(moduleNavigator.rootEntity).equal(entity1);
        expect(moduleNavigator.navigationChain).notTo.beNil();
    });
});

describe(@"checking push manipulation", ^{
    it(@"with valid link should add new entity", ^{
        ITLinkAction *const nextEntity = [[ITLinkAction alloc] initWithModuleName:ITModuleNameFromClass([_ITFeedModuleRouter class]) link:@selector(openProfile) arguments:nil];
        const NSInteger prevChainLength = moduleNavigator.navigationChain.length;
        [moduleNavigator pushLink:nextEntity withResultValue:nil];
        expect(moduleNavigator.activeEntity).equal(nextEntity);
        expect(moduleNavigator.navigationChain.lastEntity).equal(nextEntity);
        expect(moduleNavigator.navigationChain.length).equal(prevChainLength + 1);
    });

    it(@"with empty link should throw exception", ^{
        expect(^{
            [moduleNavigator pushLink:nil withResultValue:nil];
        }).to.raise(ITNavigationInvalidArgument);
    });
});

describe(@"checking pop manipulation", ^{
    it(@"with non-empty navigation chain should proceed", ^{
        ITLinkAction *const prevActiveEntity = moduleNavigator.activeEntity;
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
        ITLinkAction *const entity4 = [[ITLinkAction alloc] initWithModuleName:entity2.moduleName link:entity2.linkSelector arguments:@[@"Robin", @"abc"]];
        _ITLoginModuleRouter *entity4Router = OCMClassMock([_ITLoginModuleRouter class]);
        OCMStub([entity4Router navigateToSignInWithUser:[OCMArg any] password:[OCMArg any]]);
        entity4.router = entity4Router;

        ITLinkChain *const sameChain = [[ITLinkChain alloc] initWithEntities:@[entity1, entity4]];
        ITLinkAction *const prevLastLink = defaultChain.lastEntity;
        [moduleNavigator navigateToNewChain:sameChain];
        OCMVerify([prevLastLink.router unwind]);
        OCMVerify([(_ITLoginModuleRouter *)entity4.router navigateToSignInWithUser:[OCMArg any] password:[OCMArg any]]);
    });

    it(@"with some common root route should navigate back and forth", ^{
        
    });

    it(@"with empty destination chain controller should do nothing", ^{

    });

    it(@"with having no common part (root) should do nothing", ^{

    });
});


SpecEnd
