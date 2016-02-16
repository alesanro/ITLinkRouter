//
//  ITNavigationActorTests.m
//  ITLinkRouter
//
//  Created by Alex Rudyak on 2/16/16.
//  Copyright © 2016 Alex Rudyak. All rights reserved.
//

#import "ITSupportClassStructure.h"

SpecBegin(ITNavigationActorTests);
__block _TestModuleRouter *router;
__block OCMockObject<ITNavigationActorDelegate> *delegateMock;

__block ITNavigationActor *actorWithRouter;
__block ITNavigationActor *actorWithoutRouter;

beforeAll(^{
    router = OCMClassMock([_TestModuleRouter class]);
    OCMStub([router navigateToA]);
    OCMStub([router navigateToB]);
    OCMStub([router navigateToC]);
    OCMStub([router navigateToA:[OCMArg any]]);
    OCMStub([router navigateToB:[OCMArg any]]);
    OCMStub([router navigateToC:[OCMArg any]]);
});

beforeEach(^{
    delegateMock = OCMProtocolMock(@protocol(ITNavigationActorDelegate));
    // actor with routing
    {
        ITLinkNode *const rootNode = OCMPartialMock([ITLinkNode linkActionWithModuleName:@"RootModule" link:@selector(navigateToA) arguments:nil router:router]);
        ITLinkNode *const lastNode = OCMPartialMock([ITLinkNode linkValueWithModuleName:@"LoginModule" router:router]);
        ITLinkChain *const sourceChain = [[ITLinkChain alloc] initWithEntities:@[rootNode, lastNode]];

        ITLinkNode *const drootNode = OCMPartialMock([ITLinkNode linkActionWithNode:rootNode link:@selector(navigateToB:) arguments:@[@"Bob"]]);
        ITLinkNode *const dlastNode = OCMPartialMock([ITLinkNode linkValueWithModuleName:@"LoginWithCModule"]);
        ITLinkChain *const destinationChain = [[ITLinkChain alloc] initWithEntities:@[drootNode, dlastNode]];

        actorWithRouter = [[ITNavigationActor alloc] initWithSourceChain:sourceChain destinationChain:destinationChain];
        actorWithRouter.delegate = delegateMock;
    }

    // actor without routing
    {
        ITLinkNode *const rootNode = OCMPartialMock([ITLinkNode linkActionWithModuleName:@"RootModule" link:@selector(navigateToA) arguments:nil]);
        ITLinkNode *const lastNode = OCMPartialMock([ITLinkNode linkValueWithModuleName:@"LoginModule"]);
        ITLinkChain *const sourceChain = [[ITLinkChain alloc] initWithEntities:@[rootNode, lastNode]];

        ITLinkNode *const drootNode = OCMPartialMock([ITLinkNode linkActionWithNode:rootNode link:@selector(navigateToB:) arguments:@[@"Bob"]]);
        ITLinkNode *const dlastNode = OCMPartialMock([ITLinkNode linkValueWithModuleName:@"LoginWithCModule"]);
        ITLinkChain *const destinationChain = [[ITLinkChain alloc] initWithEntities:@[drootNode, dlastNode]];

        actorWithoutRouter = [[ITNavigationActor alloc] initWithSourceChain:sourceChain destinationChain:destinationChain];
        actorWithoutRouter.delegate = delegateMock;
    }
});

describe(@"navigation cycle", ^{
    it(@"should work with valid data", ^{
        ITNavigationActor *const actor = actorWithRouter;

        expect(actor.backChain).notTo.beNil();
        expect(actor.forwardChain).notTo.beNil();
        expect(actor.isValid).to.beTruthy();
        expect(actor.delegate).notTo.beNil();

        expect(actor.isStarted).to.beFalsy();
        expect(actor.isFinished).to.beFalsy();
        OCMExpect([delegateMock didStartNavigation:actor]);
        [actor start];
        OCMVerify([delegateMock didStartNavigation:actor]);
        expect(actor.isStarted).to.beTruthy();
        expect(actor.isFinished).to.beFalsy();

        [actor next:ITLinkNavigationTypeBack withCurrentNode:[ITLinkNode linkValueWithModuleName:@"RootModule"]];
        expect(actor.isStarted).to.beTruthy();
        expect(actor.isFinished).to.beFalsy();
        OCMExpect([delegateMock didFinishNavigation:actor]);
        [actor next:ITLinkNavigationTypeForward withCurrentNode:[ITLinkNode linkValueWithModuleName:@"LoginWithCModule"]];
        OCMVerify([delegateMock didFinishNavigation:actor]);
        expect(actor.isStarted).to.beTruthy();
        expect(actor.isFinished).to.beTruthy();
    });

    it(@"should immediately return with delegate invocations if no first step had been taken", ^{
        ITNavigationActor *const actor = actorWithoutRouter;
        [delegateMock setExpectationOrderMatters:YES];
        OCMExpect([delegateMock didStartNavigation:actor]);
        OCMExpect([delegateMock didFinishNavigation:actor]);
        [actor start];
        OCMVerifyAll(delegateMock);
        expect(actor.isStarted).to.beTruthy();
        expect(actor.isFinished).to.beTruthy();
    });
});

describe(@"misusing navigation methods", ^{
    it(@"when trying to invoke a few `start` methods sequentinally then should trigger only once", ^{
        ITNavigationActor *const actor = actorWithoutRouter;
        [delegateMock setExpectationOrderMatters:YES];
        OCMExpect([delegateMock didStartNavigation:actor]);
        OCMExpect([delegateMock didFinishNavigation:actor]);
        [actor start];
        OCMVerifyAll(delegateMock);
        [OCMReject(delegateMock) didStartNavigation:actor];
        [OCMReject(delegateMock) didFinishNavigation:actor];
        [actor start];
        [actor start];
    });

    it(@"when trying to invoke any method after it actually finished should do nothing", ^{
        ITNavigationActor *const actor = actorWithRouter;
        [delegateMock setExpectationOrderMatters:YES];
        OCMExpect([delegateMock didStartNavigation:actor]);
        [actor start];
        OCMVerifyAll(delegateMock);
        [actor next:ITLinkNavigationTypeBack withCurrentNode:[ITLinkNode linkValueWithModuleName:@"RootModule"]];
        OCMExpect([delegateMock didFinishNavigation:actor]);
        [actor next:ITLinkNavigationTypeForward withCurrentNode:[ITLinkNode linkValueWithModuleName:@"LoginWithCModule"]];
        OCMVerifyAll(delegateMock);
        expect(actor.isStarted).to.beTruthy();
        expect(actor.isFinished).to.beTruthy();

        [OCMReject(delegateMock) didStartNavigation:actor];
        [OCMReject(delegateMock) didFinishNavigation:actor];
        [actor start];
        [actor next:ITLinkNavigationTypeBack withCurrentNode:[ITLinkNode linkValueWithModuleName:@"RootModule"]];
        [actor next:ITLinkNavigationTypeForward withCurrentNode:[ITLinkNode linkValueWithModuleName:@"LoginWithCModule"]];
        expect(actor.isStarted).to.beTruthy();
        expect(actor.isFinished).to.beTruthy();
    });

    it(@"when trying to start navigation by not using `start` method should result nothing", ^{
        ITNavigationActor *const actor = actorWithRouter;
        [OCMReject(delegateMock) didStartNavigation:actor];
        [OCMReject(delegateMock) didFinishNavigation:actor];
        [actor next:ITLinkNavigationTypeBack withCurrentNode:[ITLinkNode linkValueWithModuleName:@"LoginModule"]];
        expect(actor.isStarted).to.beFalsy();
        expect(actor.isFinished).to.beFalsy();
    });

    it(@"when passing invalid navigation type during navigation should produce exception", ^{
        ITNavigationActor *const actor = actorWithRouter;
        [delegateMock setExpectationOrderMatters:YES];
        [actor start];
        [actor next:ITLinkNavigationTypeBack withCurrentNode:[ITLinkNode linkValueWithModuleName:@"RootModule"]];
        expect(^{
            [actor next:(ITLinkNavigationType)4 withCurrentNode:[ITLinkNode linkValueWithModuleName:@"LoginWithCModule"]];
        }).to.raise(ITNavigationInvalidNavigationType);
    });
});

describe(@"initialization", ^{
    it(@"with chains that have no intersection should yield invalid state", ^{
        ITNavigationActor *const actor = [[ITNavigationActor alloc] initWithSourceChain:nil destinationChain:nil];
        actor.delegate = delegateMock;
        expect(actor.isValid).to.beFalsy();
        [OCMReject(delegateMock) didStartNavigation:actor];
        [OCMReject(delegateMock) didFinishNavigation:actor];
        [actor start];
        expect(actor.isStarted).to.beFalsy();
        expect(actor.isFinished).to.beFalsy();
    });
});

SpecEnd
