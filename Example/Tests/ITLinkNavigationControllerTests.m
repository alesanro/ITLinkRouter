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

                OCMExpect([navigationControllerInternal popLink]).andForwardToRealObject();
                OCMExpect([navigationControllerInternal pushLink:[OCMArg any] withResultValue:[OCMArg any]]).andForwardToRealObject();
                [navigationControllerInternal navigateToNewChain:destinationChain];
                OCMVerifyAllWithDelay((OCMockObject *)navigationControllerInternal, 0.5);
                expect(navigationControllerInternal.navigationChain.length).after(0.5).to.equal(destinationChain.length);
                expect(navigationControllerInternal.navigationChain.lastEntity).after(0.5).to.equal(feedNode);
            });

            it(@"more then one back and one forward", ^{
                ITLinkNode *const rootNode = [ITLinkNode linkActionWithModuleName:@"RootModule" link:@selector(navigateToC:) arguments:@[@"Main"]];
                ITLinkNode *const mainNode = [ITLinkNode linkValueWithModuleName:@"MainModule"];
                ITLinkChain *const destinationChain = [[ITLinkChain alloc] initWithEntities:@[rootNode, mainNode]];

                OCMExpect([navigationControllerInternal popLink]).andForwardToRealObject();
                OCMExpect([navigationControllerInternal popLink]).andForwardToRealObject();
                OCMExpect([navigationControllerInternal pushLink:[OCMArg any] withResultValue:[OCMArg any]]).andForwardToRealObject();
                [navigationControllerInternal navigateToNewChain:destinationChain];
                OCMVerifyAllWithDelay((OCMockObject *)navigationControllerInternal, 0.5);
                expect(navigationControllerInternal.navigationChain.length).after(0.5).to.equal(destinationChain.length);
                expect(navigationControllerInternal.navigationChain.lastEntity).after(0.5).to.equal(mainNode);
            });

            it(@"one link back and more then one forward", ^{
                ITLinkNode *const rootNode = [ITLinkNode linkActionWithModuleName:@"RootModule" link:@selector(navigateToA) arguments:nil];
                ITLinkNode *const loginNode = [ITLinkNode linkActionWithModuleName:@"LoginModule" link:@selector(navigateToB:) arguments:@[@"Bob"]];
                ITLinkNode *const feedNode = [ITLinkNode linkActionWithModuleName:@"FeedBLoginModule" link:@selector(navigateToB) arguments:nil];
                ITLinkNode *const newsNode = [ITLinkNode linkValueWithModuleName:@"NewsDetailBLoginModule"];
                ITLinkChain *const destinationChain = [[ITLinkChain alloc] initWithEntities:@[rootNode, loginNode, feedNode, newsNode]];

                OCMExpect([navigationControllerInternal popLink]).andForwardToRealObject();
                OCMExpect([navigationControllerInternal pushLink:[OCMArg any] withResultValue:[OCMArg any]]).andForwardToRealObject();
                OCMExpect([navigationControllerInternal pushLink:[OCMArg any] withResultValue:[OCMArg any]]).andForwardToRealObject();
                [navigationControllerInternal navigateToNewChain:destinationChain];
                OCMVerifyAllWithDelay((OCMockObject *)navigationControllerInternal, 0.5);
                expect(navigationControllerInternal.navigationChain.length).after(0.5).to.equal(destinationChain.length);
                expect(navigationControllerInternal.navigationChain.lastEntity).after(0.5).to.equal(newsNode);
            });

            it(@"more then one back and forward", ^{
                ITLinkNode *const rootNode = [ITLinkNode linkActionWithModuleName:@"RootModule" link:@selector(navigateToC) arguments:nil];
                ITLinkNode *const loginNode = [ITLinkNode linkActionWithModuleName:@"MainModule" link:@selector(navigateToC:) arguments:@[@"Alice"]];
                ITLinkNode *const feedNode = [ITLinkNode linkActionWithModuleName:@"FeedCMainModule" link:@selector(navigateToA) arguments:nil];
                ITLinkNode *const newsNode = [ITLinkNode linkValueWithModuleName:@"NewsDetailAMainModule"];
                ITLinkChain *const destinationChain = [[ITLinkChain alloc] initWithEntities:@[rootNode, loginNode, feedNode, newsNode]];

                OCMExpect([navigationControllerInternal popLink]).andForwardToRealObject();
                OCMExpect([navigationControllerInternal popLink]).andForwardToRealObject();
                OCMExpect([navigationControllerInternal pushLink:[OCMArg any] withResultValue:[OCMArg any]]).andForwardToRealObject();
                OCMExpect([navigationControllerInternal pushLink:[OCMArg any] withResultValue:[OCMArg any]]).andForwardToRealObject();
                [navigationControllerInternal navigateToNewChain:destinationChain];
                OCMVerifyAllWithDelay((OCMockObject *)navigationControllerInternal, 0.5);
                expect(navigationControllerInternal.navigationChain.length).after(0.5).to.equal(destinationChain.length);
                expect(navigationControllerInternal.navigationChain.lastEntity).after(0.5).to.equal(newsNode);
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
                OCMExpect([navigationControllerInternal popLink]).andForwardToRealObject();
                [navigationControllerInternal navigateToNewChain:destinationChain];
                OCMVerifyAllWithDelay((OCMockObject *)navigationControllerInternal, .5);
                expect(navigationControllerInternal.navigationChain.length).to.equal(destinationChain.length);
                expect(navigationControllerInternal.navigationChain.rootEntity).to.equal(rootNode);
            });

            it(@"more then one link", ^{
                ITLinkNode *const rootNode = [ITLinkNode linkValueWithModuleName:@"RootModule"];
                ITLinkChain *const destinationChain = [[ITLinkChain alloc] initWithEntities:@[rootNode]];

                [OCMReject(navigationControllerInternal) pushLink:[OCMArg any] withResultValue:[OCMArg any]];
                OCMExpect([navigationControllerInternal popLink]).andForwardToRealObject();
                OCMExpect([navigationControllerInternal popLink]).andForwardToRealObject();
                [navigationControllerInternal navigateToNewChain:destinationChain];
                OCMVerifyAllWithDelay((OCMockObject *)navigationControllerInternal, .5);
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
                OCMExpect([navigationControllerInternal pushLink:[OCMArg any] withResultValue:[OCMArg any]]).andForwardToRealObject();
                [navigationControllerInternal navigateToNewChain:destinationChain];
                OCMVerifyAllWithDelay((OCMockObject *)navigationControllerInternal, 0.5);
                expect(navigationControllerInternal.navigationChain.length).after(0.5).to.equal(destinationChain.length);
                expect(navigationControllerInternal.navigationChain.lastEntity).after(0.5).to.equal(nextNode);
            });

            it(@"more then one link", ^{
                ITLinkNode *const rootNode = [ITLinkNode linkActionWithNode:navigationControllerInternal.navigationChain.lastEntity link:@selector(navigateToA:) arguments:@[@"Bob"]];
                ITLinkNode *const nextNode = [ITLinkNode linkActionWithModuleName:@"LoginModule" link:@selector(navigateToC) arguments:nil];
                ITLinkNode *const lastNode = [ITLinkNode linkValueWithModuleName:@"FeedCLoginModule"];
                ITLinkChain *const destinationChain = [[ITLinkChain alloc] initWithEntities:@[rootNode, nextNode, lastNode]];

                [OCMReject(navigationControllerInternal) popLink];
                OCMExpect([navigationControllerInternal pushLink:[OCMArg any] withResultValue:[OCMArg any]]).andForwardToRealObject();
                [navigationControllerInternal navigateToNewChain:destinationChain];
                OCMVerifyAllWithDelay((OCMockObject *)navigationControllerInternal, 0.5);
                expect(navigationControllerInternal.navigationChain.length).after(0.5).to.equal(destinationChain.length);
                expect(navigationControllerInternal.navigationChain.lastEntity).after(0.5).to.equal(lastNode);
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
                expect(navigationControllerInternal.navigationChain.length).after(0.5).to.equal(destinationChain.length + 1);
                expect(navigationControllerInternal.navigationChain.lastEntity).after(0.5).to.equal(nextNode);
            });
        });
    });
});

describe(@"reporting a problem", ^{
    __block ITLinkChain *destinationChain;
    __block ITLinkNavigationController *navigationControllerInternal;
    __block _TestModuleRouter *loginRouter;

    beforeEach(^{
        _TestModuleRouter *const firstRouter = OCMPartialMock([rootRouter childRouterWithModuleName:@"RootModule"]);
        ITLinkNode *const rootNode = [ITLinkNode linkActionWithModuleName:firstRouter.moduleName link:@selector(navigateToA) arguments:nil router:firstRouter];
        loginRouter = OCMPartialMock([rootRouter childRouterWithModuleName:@"LoginModule"]);
        ITLinkNode *const loginNode = [ITLinkNode linkActionWithModuleName:loginRouter.moduleName link:@selector(navigateToA:) arguments:@[@"TestUser1"] router:loginRouter];
        _TestModuleRouter *const feedARouter = OCMPartialMock([rootRouter childRouterWithModuleName:@"FeedALoginModule"]);
        ITLinkNode *const feedNode = [ITLinkNode linkValueWithModuleName:feedARouter.moduleName router:feedARouter];
        destinationChain = [[ITLinkChain alloc] initWithEntities:@[rootNode, loginNode, feedNode]];
        navigationControllerInternal = OCMPartialMock([[ITLinkNavigationController alloc] initWithChain:destinationChain]);
        firstRouter.moduleNavigator = navigationControllerInternal;
    });

    context(@"when performing navigation to a chain", ^{
        it(@"should invoke handle block with resolver", ^{
            ITLinkNode *const rootNode = [ITLinkNode linkActionWithModuleName:@"RootModule" link:@selector(navigateToA:) arguments:@[@"Bob"]];
            ITLinkNode *const nextNode = [ITLinkNode linkActionWithModuleName:@"LoginModule" link:@selector(navigateToC) arguments:nil];
            ITLinkNode *const lastNode = [ITLinkNode linkValueWithModuleName:@"FeedCLoginModule"];
            ITLinkChain *const destinationChain = [[ITLinkChain alloc] initWithEntities:@[rootNode, nextNode, lastNode]];

            ITProblemDictionary *const problem = @{@"ITTestCase": @"Test reason"};
            OCMStub([loginRouter navigateToC]).andDo(^(NSInvocation *invocation) {
                [navigationControllerInternal reportProblem:problem];
            });

            __block BOOL handleBlockCalled = NO;
            __block NSUInteger blockCounter = 0;
            [navigationControllerInternal navigateToNewChain:destinationChain andHandleAnyProblem:^(ITProblemDictionary *problemDict, ITNavigationProblemResolver *resolver) {
                expect(problem).to.equal(problemDict);
                expect(resolver).toNot.beNil();

                handleBlockCalled = YES;
                blockCounter++;

                ITLinkNode *const nextNode = [ITLinkNode linkActionWithModuleName:@"LoginModule" link:@selector(navigateToC:) arguments:@[@"tom"]];
                ITLinkNode *const lastNode = [ITLinkNode linkValueWithModuleName:@"FeedCLoginModule"];
                ITLinkChain *const destinationChain = [[ITLinkChain alloc] initWithEntities:@[rootNode, nextNode, lastNode]];
                [resolver navigateToOtherChain:destinationChain];
                [resolver resolve];
            }];
            expect(handleBlockCalled).after(0.5).to.beTruthy();
            expect(handleBlockCalled).after(0.5).to.equal(1);
        });
    });

    context(@"when it is not inside the navigation process ", ^{
        it(@"should do nothing", ^{
#ifdef DEBUG
            ITProblemDictionary *const problem = @{@"ITTestCase": @"Test reason"};
            expect(^{
                [navigationControllerInternal reportProblem:problem];
            }).to.raise(NSInternalInconsistencyException);
#endif
        });
    });
});

describe(@"solving a problem", ^{
    __block ITLinkChain *destinationChain;
    __block ITLinkNavigationController *navigationControllerInternal;
    __block _TestModuleRouter *loginRouter;

    beforeEach(^{
        _TestModuleRouter *const firstRouter = OCMPartialMock([rootRouter childRouterWithModuleName:@"RootModule"]);
        ITLinkNode *const rootNode = [ITLinkNode linkActionWithModuleName:firstRouter.moduleName link:@selector(navigateToA) arguments:nil router:firstRouter];
        loginRouter = OCMPartialMock([rootRouter childRouterWithModuleName:@"LoginModule"]);
        ITLinkNode *const loginNode = [ITLinkNode linkActionWithModuleName:loginRouter.moduleName link:@selector(navigateToA:) arguments:@[@"TestUser1"] router:loginRouter];
        _TestModuleRouter *const feedARouter = OCMPartialMock([rootRouter childRouterWithModuleName:@"FeedALoginModule"]);
        ITLinkNode *const feedNode = [ITLinkNode linkValueWithModuleName:feedARouter.moduleName router:feedARouter];
        destinationChain = [[ITLinkChain alloc] initWithEntities:@[rootNode, loginNode, feedNode]];
        navigationControllerInternal = OCMPartialMock([[ITLinkNavigationController alloc] initWithChain:destinationChain]);
        firstRouter.moduleNavigator = navigationControllerInternal;
    });

    it(@"with invalid resolver should fail", ^{
        expect(^{
            [navigationControllerInternal solveProblemWithResolver:nil];
        }).to.raise(NSInternalInconsistencyException);
        expect(^{
            ITLinkNode *const rootNode = [ITLinkNode linkActionWithModuleName:@"RootModule" link:@selector(navigateToA:) arguments:@[@"Bob"]];
            ITLinkNode *const nextNode = [ITLinkNode linkActionWithModuleName:@"LoginModule" link:@selector(navigateToC) arguments:nil];
            ITLinkChain *const destinationChain = [[ITLinkChain alloc] initWithEntities:@[rootNode, nextNode]];

            ITNavigationProblemResolver *resolver = [[ITNavigationProblemResolver alloc] initWithNavigationController:navigationControllerInternal destinationChain:destinationChain];
            [resolver markDone];
            [navigationControllerInternal solveProblemWithResolver:resolver];
        }).to.raise(NSInternalInconsistencyException);
    });

    it(@"with valid resolver should invoke navigation again", ^{
        ITLinkNode *const rootNode = [ITLinkNode linkActionWithModuleName:@"RootModule" link:@selector(navigateToA:) arguments:@[@"Bob"]];
        ITLinkNode *const nextNode = [ITLinkNode linkActionWithModuleName:@"LoginModule" link:@selector(navigateToC) arguments:nil];
        ITLinkChain *const destinationChain = [[ITLinkChain alloc] initWithEntities:@[rootNode, nextNode]];

        ITNavigationProblemResolver *resolver = [[ITNavigationProblemResolver alloc] initWithNavigationController:navigationControllerInternal destinationChain:destinationChain];
        OCMExpect([navigationControllerInternal navigateToNewChain:[OCMArg any] andHandleAnyProblem:[OCMArg invokeBlock]]);
        [navigationControllerInternal solveProblemWithResolver:resolver];
        OCMVerifyAll((OCMockObject *)navigationControllerInternal);


    });
});

describe(@"performing more than one navigation at once", ^{
    __block ITLinkChain *destinationChain;
    __block ITLinkNavigationController *navigationControllerInternal;
    __block _TestModuleRouter *loginRouter;

    beforeEach(^{
        _TestModuleRouter *const firstRouter = OCMPartialMock([rootRouter childRouterWithModuleName:@"RootModule"]);
        ITLinkNode *const rootNode = [ITLinkNode linkActionWithModuleName:firstRouter.moduleName link:@selector(navigateToA) arguments:nil router:firstRouter];
        loginRouter = OCMPartialMock([rootRouter childRouterWithModuleName:@"LoginModule"]);
        ITLinkNode *const loginNode = [ITLinkNode linkActionWithModuleName:loginRouter.moduleName link:@selector(navigateToA:) arguments:@[@"TestUser1"] router:loginRouter];
        _TestModuleRouter *const feedARouter = OCMPartialMock([rootRouter childRouterWithModuleName:@"FeedALoginModule"]);
        ITLinkNode *const feedNode = [ITLinkNode linkValueWithModuleName:feedARouter.moduleName router:feedARouter];
        destinationChain = [[ITLinkChain alloc] initWithEntities:@[rootNode, loginNode, feedNode]];
        navigationControllerInternal = OCMPartialMock([[ITLinkNavigationController alloc] initWithChain:destinationChain]);
        firstRouter.moduleNavigator = navigationControllerInternal;
    });

    it(@"two concurent navigations should invoke handleBlock except first invocation", ^{
        ITLinkNode *const frootNode = [ITLinkNode linkActionWithModuleName:@"RootModule" link:@selector(navigateToA:) arguments:@[@"Bob"]];
        ITLinkNode *const fnextNode = [ITLinkNode linkActionWithModuleName:@"LoginModule" link:@selector(navigateToC) arguments:nil];
        ITLinkNode *const flastNode = [ITLinkNode linkValueWithModuleName:@"FeedCLoginModule"];
        ITLinkChain *const firstDestinationChain = [[ITLinkChain alloc] initWithEntities:@[frootNode, fnextNode, flastNode]];

        ITLinkNode *const srootNode = [ITLinkNode linkActionWithModuleName:@"RootModule" link:@selector(navigateToA:) arguments:@[@"Bob"]];
        ITLinkNode *const snextNode = [ITLinkNode linkActionWithModuleName:@"LoginModule" link:@selector(navigateToC:) arguments:@[@"tom"]];
        ITLinkChain *const secondDestinationChain = [[ITLinkChain alloc] initWithEntities:@[srootNode, snextNode]];

        [navigationControllerInternal navigateToNewChain:firstDestinationChain andHandleAnyProblem:^(ITProblemDictionary *problemDict, ITNavigationProblemResolver *resolver) {
            failure(@"Should not invoke handle problem block for the first navigation");

        }];

        __block BOOL secondProblemBlockInvoked;
        [navigationControllerInternal navigateToNewChain:secondDestinationChain andHandleAnyProblem:^(ITProblemDictionary *problemDict, ITNavigationProblemResolver *resolver) {
            secondProblemBlockInvoked = YES;

            expect(problemDict).notTo.beNil();
            expect(problemDict.allKeys).to.contain(ITNavigationProblemTypeKey);
            expect(resolver).to.beNil();
        }];

        expect(secondProblemBlockInvoked).after(1).to.beTruthy();
    });
});

SpecEnd
