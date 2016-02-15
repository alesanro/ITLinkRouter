//
//  ITNavigationProblemResolverTests.m
//  ITLinkRouter
//
//  Created by Alex Rudyak on 2/15/16.
//  Copyright © 2016 Alex Rudyak. All rights reserved.
//

SpecBegin(ITNavigationProblemResolverTests);

__block ITLinkNavigationController *navigationController;

beforeEach(^{
    ITLinkChain *const navigationChain = [[ITLinkChain alloc] initWithEntities:nil];
    navigationController = OCMPartialMock([[ITLinkNavigationController alloc] initWithChain:navigationChain]);
});

describe(@"initialization stage", ^{
    it(@"should be ok with proper parameters", ^{
        ITLinkChain *const destinatinChain = [[ITLinkChain alloc] initWithEntities:nil];
        ITNavigationProblemResolver *const resolver = [[ITNavigationProblemResolver alloc] initWithNavigationController:navigationController destinationChain:destinatinChain];
        expect(resolver.navigationController).notTo.beNil();
        expect(resolver.navigationController).to.equal(navigationController);
        expect(resolver.currentChain).toNot.beNil();
        expect(resolver.currentChain).to.equal(navigationController.navigationChain);
        expect(resolver.destinationChain).toNot.beNil();
        expect(resolver.resolvingChain).to.beNil();
        expect(resolver.isResolved).to.beFalsy();
        expect(resolver.isDone).to.beFalsy();
    });
});

describe(@"usage of main methods", ^{
    __block ITNavigationProblemResolver *resolver;
    beforeEach(^{
        ITLinkChain *const destinatinChain = [[ITLinkChain alloc] initWithEntities:nil];
        resolver = [[ITNavigationProblemResolver alloc] initWithNavigationController:navigationController destinationChain:destinatinChain];
    });

    context(@"should have proper state for", ^{
        it(@"continuing navigation", ^{
            [resolver continueNavigation];
            expect(resolver.resolvingChain).to.equal(resolver.destinationChain);
            expect(resolver.isResolved).to.beFalsy();
            expect(resolver.isDone).to.beFalsy();
        });

        it(@"for navigating to other destination", ^{
            ITLinkNode *const node = [ITLinkNode linkValueWithModuleName:@"Module"];
            ITLinkChain *const updatedChain = [[ITLinkChain alloc] initWithEntities:@[node]];
            [resolver navigateToOtherChain:updatedChain];
            expect(resolver.resolvingChain).to.equal(updatedChain);
            expect(resolver.isResolved).to.beFalsy();
            expect(resolver.isDone).to.beFalsy();
        });

        it(@"multiple invocations", ^{
            ITLinkNode *const node = [ITLinkNode linkValueWithModuleName:@"Module"];
            ITLinkChain *const updatedChain = [[ITLinkChain alloc] initWithEntities:@[node]];
            [resolver navigateToOtherChain:updatedChain];
            expect(resolver.resolvingChain).to.equal(updatedChain);
            [resolver continueNavigation];
            expect(resolver.resolvingChain).to.equal(resolver.destinationChain);
            [resolver navigateToOtherChain:updatedChain];
            expect(resolver.resolvingChain).to.equal(updatedChain);
            expect(resolver.isResolved).to.beFalsy();
            expect(resolver.isDone).to.beFalsy();
        });
    });

    context(@"cannot change navigation type when object is already resolved", ^{
        it(@"for navigate to new chain", ^{
            ITLinkNode *const node = [ITLinkNode linkValueWithModuleName:@"Module"];
            ITLinkChain *const updatedChain = [[ITLinkChain alloc] initWithEntities:@[node]];
            OCMStub([navigationController solveProblemWithResolver:[OCMArg any]]).andDo(^(NSInvocation *invocation) {
                // no-op
            });
            [resolver navigateToOtherChain:updatedChain];
            expect(resolver.resolvingChain).to.equal(updatedChain);
            [resolver resolve];
            expect(resolver.isResolved).to.beTruthy();
            expect(resolver.isDone).to.beFalsy();
            OCMVerify([navigationController solveProblemWithResolver:[OCMArg any]]);
            expect(^{
                [resolver resolve];
            }).to.raise(NSInternalInconsistencyException);
        });
        it(@"for continuing navigation", ^{
            OCMStub([navigationController solveProblemWithResolver:[OCMArg any]]).andDo(^(NSInvocation *invocation) {
                // no-op
            });
            OCMExpect([navigationController solveProblemWithResolver:[OCMArg any]]);
            [resolver continueNavigation];
            expect(resolver.resolvingChain).to.equal(resolver.destinationChain);
            [resolver resolve];
            expect(resolver.isResolved).to.beTruthy();
            expect(resolver.isDone).to.beFalsy();
            OCMVerify([navigationController solveProblemWithResolver:[OCMArg any]]);
            expect(^{
                [resolver resolve];
            }).to.raise(NSInternalInconsistencyException);
        });

    });

    it(@"cannot resolve without any action of navigation", ^{
        expect(^{
            [resolver resolve];
        }).to.raise(NSInternalInconsistencyException);
        expect(resolver.isResolved).to.beFalsy();
        expect(resolver.isDone).to.beFalsy();
    });

    it(@"can mark 'Done' only once per object", ^{
        [resolver markDone];
        expect(resolver.isDone).to.beTruthy();
        expect(^{
            [resolver markDone];
        }).to.raise(NSInternalInconsistencyException);
    });
});

describe(@"copying", ^{
    __block ITNavigationProblemResolver *resolver;
    beforeEach(^{
        ITLinkChain *const destinatinChain = [[ITLinkChain alloc] initWithEntities:nil];
        resolver = [[ITNavigationProblemResolver alloc] initWithNavigationController:navigationController destinationChain:destinatinChain];
    });

    it(@"should be performed without state changes", ^{
        [resolver continueNavigation];
        [resolver resolve];
        ITNavigationProblemResolver *const copiedResolver = [resolver copy];
        expect(copiedResolver.resolvingChain).to.equal(resolver.resolvingChain);
        expect(copiedResolver.destinationChain).to.equal(resolver.destinationChain);
        expect(copiedResolver.isDone).toNot.equal(resolver.isDone);
        expect(copiedResolver.isResolved).toNot.equal(resolver.isResolved);
    });
});

SpecEnd
