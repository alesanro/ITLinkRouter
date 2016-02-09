//
//  ITLinkActionTests.m
//  ITLinkRouter
//
//  Created by Alex Rudyak on 2/3/16.
//  Copyright © 2016 Alex Rudyak. All rights reserved.
//

#import "ITSupportClassStructure.h"

@interface _TestModule : NSObject <ITAnimatableTransition, ITUnwindableTransition>

@property (nonatomic, getter=isAnimatable) BOOL animatable;
- (void)testRoute;
- (void)testRoute:(NSString *)route;
- (void)testRoute:(NSString *)route param1:(NSString *)param1;
- (void)testRoute:(NSString *)route param1:(NSString *)param1 param2:(NSString *)param2;

@end

@implementation _TestModule

- (void)unwind
{
}

- (void)testRoute
{
}

- (void)testRoute:(NSString *)route
{
}

- (void)testRoute:(NSString *)route param1:(NSString *)param1
{
}

- (void)testRoute:(NSString *)route param1:(NSString *)param1 param2:(NSString *)param2
{
}

@end

SpecBegin(ITLinkActionTests);

__block ITLinkNode *linkEntity;

afterEach(^{
    linkEntity = nil;
});

describe(@"Entity Initialization", ^{
    it(@"should inititialize with empty arguments" , ^{
        linkEntity = [[ITLinkAction alloc] initWithModuleName:nil link:0 arguments:nil];
        ITLinkAction *linkAction = (ITLinkAction *)linkEntity;
        expect(linkAction.moduleName).to.beNil();
        expect(linkAction.linkSelector).to.beNull();
        expect(linkAction.arguments).to.beNil();
    });

    it(@"should initialize with non-empty arguments", ^{
        linkEntity = [[ITLinkAction alloc] initWithModuleName:ITModuleNameFromClass([_TestModule class]) link:@selector(testRoute) arguments:nil];
        ITLinkAction *linkAction = (ITLinkAction *)linkEntity;
        expect(linkAction.moduleName).equal(NSStringFromClass([_TestModule class]));
        expect(linkAction.linkSelector).equal(@selector(testRoute));
        expect(linkAction.arguments).to.beNil();
    });

    it(@"should have proper instance after copying", ^{
        linkEntity = [[ITLinkAction alloc] initWithModuleName:ITModuleNameFromClass([_TestModule class]) link:@selector(testRoute) arguments:nil];
        linkEntity.router = OCMProtocolMock(@protocol(ITUnwindableTransition));
        ITLinkAction *linkAction = (ITLinkAction *)linkEntity;
        ITLinkAction *const copiedEntity = [linkEntity copy];
        expect(copiedEntity).equal(linkEntity);
        expect(copiedEntity.moduleName).equal(linkAction.moduleName);
        expect(copiedEntity.linkSelector).equal(linkAction.linkSelector);
        expect(copiedEntity.arguments).haveCountOf(linkAction.arguments.count);
        expect(copiedEntity.router).equal(linkAction.router);
    });

    it(@"should return value for flatten", ^{
        linkEntity = [[ITLinkAction alloc] initWithModuleName:ITModuleNameFromClass([_TestModule class]) link:@selector(testRoute) arguments:nil];
        ITLinkNode *flattenNode = [linkEntity flatten];
        expect([flattenNode class]).to.equal([ITLinkValue class]);
        ITLinkNode *linkValue = [[ITLinkValue alloc] initWithModuleName:linkEntity.moduleName];
        expect(flattenNode).to.equal(linkValue);
    });
});

describe(@"equality should work", ^{
    it(@"to YES between instances of the same class", ^{
        linkEntity = [ITLinkNode linkActionWithModuleName:ITModuleNameFromClass([_TestModule class]) link:@selector(testRoute:) arguments:@[@"bob"]];
        ITLinkNode *otherLink = [ITLinkNode linkActionWithModuleName:ITModuleNameFromClass([_TestModule class]) link:@selector(testRoute:) arguments:@[@"tom"]];
        expect(linkEntity).to.equal(otherLink);
        expect(otherLink).to.equal(linkEntity);
    });

    it(@"to NO between instances of different classes of common hierarchical tree", ^{
        linkEntity = [ITLinkNode linkActionWithModuleName:ITModuleNameFromClass([_TestModule class]) link:@selector(testRoute:) arguments:@[@"bob"]];
        ITLinkNode *linkValue = [ITLinkNode linkValueWithModuleName:ITModuleNameFromClass([_TestModule class])];
        expect(linkEntity).toNot.equal(linkValue);
        expect(linkValue).toNot.equal(linkEntity);

        linkEntity = [ITLinkNode linkActionWithModuleName:ITModuleNameFromClass([_TestModule class]) link:@selector(testRoute:param1:) arguments:@[@"bob", @"tom"]];
        linkValue = [ITLinkNode linkValueWithModuleName:ITModuleNameFromClass([_TestModule class])];
        expect(linkEntity).toNot.equal(linkValue);
        expect(linkValue).toNot.equal(linkEntity);

        linkEntity = [ITLinkNode linkActionWithModuleName:ITModuleNameFromClass([_TestModule class]) link:@selector(testRoute) arguments:nil];
        linkValue = [ITLinkNode linkValueWithModuleName:ITModuleNameFromClass([_TestModule class])];
        expect(linkEntity).toNot.equal(linkValue);
        expect(linkValue).toNot.equal(linkEntity);
    });

    it(@"to NO between instances of the same class", ^{
        linkEntity = [ITLinkNode linkActionWithModuleName:ITModuleNameFromClass([_TestModule class]) link:@selector(testRoute:) arguments:@[@"bob"]];
        ITLinkNode *otherLink = [ITLinkNode linkActionWithModuleName:ITModuleNameFromClass([_TestModule class]) link:@selector(testRoute:param1:) arguments:@[@"tom", @"bob"]];
        expect(linkEntity).toNot.equal(otherLink);
        expect(otherLink).toNot.equal(linkEntity);

        linkEntity = [ITLinkNode linkActionWithModuleName:ITModuleNameFromClass([NSObject class]) link:@selector(testRoute:) arguments:@[@"bob"]];
        otherLink = [ITLinkNode linkActionWithModuleName:ITModuleNameFromClass([_TestModule class]) link:@selector(testRoute:param1:) arguments:@[@"tom", @"bob"]];
        expect(linkEntity).toNot.equal(otherLink);
        expect(otherLink).toNot.equal(linkEntity);
    });

    it(@"to NO between instances of different classes of common hierarchical tree", ^{
        linkEntity = [ITLinkNode linkActionWithModuleName:ITModuleNameFromClass([_TestModule class]) link:@selector(testRoute) arguments:nil];
        ITLinkNode *linkValue = [ITLinkNode linkValueWithModuleName:ITModuleNameFromClass([NSObject class])];
        expect(linkEntity).toNot.equal(linkValue);
        expect(linkValue).toNot.equal(linkEntity);
    });
});

describe(@"similarity should work", ^{
    it(@"to YES between instances of the same class", ^{
        linkEntity = [ITLinkNode linkActionWithModuleName:ITModuleNameFromClass([_TestModule class]) link:@selector(testRoute:) arguments:@[@"bob"]];
        ITLinkNode *otherLink = [ITLinkNode linkActionWithModuleName:ITModuleNameFromClass([_TestModule class]) link:@selector(testRoute:) arguments:@[@"tom"]];
        expect([linkEntity isSimilar:otherLink]).to.beTruthy();
        expect([otherLink isSimilar:linkEntity]).to.beTruthy();

        linkEntity = [ITLinkNode linkActionWithModuleName:ITModuleNameFromClass([_TestModule class]) link:@selector(testRoute:) arguments:@[@"bob"]];
        otherLink = [ITLinkNode linkActionWithModuleName:ITModuleNameFromClass([_TestModule class]) link:@selector(testRoute) arguments:nil];
        expect([linkEntity isSimilar:otherLink]).to.beTruthy();
        expect([otherLink isSimilar:linkEntity]).to.beTruthy();

        linkEntity = [ITLinkNode linkValueWithModuleName:ITModuleNameFromClass([_TestModule class])];
        ITLinkNode *secondLink = [ITLinkNode linkValueWithModuleName:ITModuleNameFromClass([_TestModule class])];
        expect([otherLink isSimilar:secondLink]).to.beTruthy();
        expect([secondLink isSimilar:secondLink]).to.beTruthy();
    });

    it(@"to YES between instances of different classes of common hierarchical tree", ^{
        linkEntity = [ITLinkNode linkActionWithModuleName:ITModuleNameFromClass([_TestModule class]) link:@selector(testRoute:) arguments:@[@"bob"]];
        ITLinkNode *linkValue = [ITLinkNode linkValueWithModuleName:ITModuleNameFromClass([_TestModule class])];
        expect([linkEntity isSimilar:linkValue]).to.beTruthy();
        expect([linkValue isSimilar:linkEntity]).to.beTruthy();

        linkEntity = [ITLinkNode linkActionWithModuleName:ITModuleNameFromClass([_TestModule class]) link:@selector(testRoute:param1:) arguments:@[@"bob", @"tom"]];
        expect([linkEntity isSimilar:linkValue]).to.beTruthy();
        expect([linkValue isSimilar:linkEntity]).to.beTruthy();

        linkEntity = [ITLinkNode linkActionWithModuleName:ITModuleNameFromClass([_TestModule class]) link:@selector(testRoute) arguments:nil];
        expect([linkEntity isSimilar:linkValue]).to.beTruthy();
        expect([linkValue isSimilar:linkEntity]).to.beTruthy();
    });

    it(@"to NO between instances of the same class", ^{
        linkEntity = [ITLinkNode linkActionWithModuleName:ITModuleNameFromClass([_TestModule class]) link:@selector(testRoute) arguments:nil];
        ITLinkNode *otherLink = [ITLinkNode linkActionWithModuleName:ITModuleNameFromClass([_ITRootModuleRouter class]) link:@selector(testRoute) arguments:nil];
        expect([linkEntity isSimilar:otherLink]).to.beFalsy();
        expect([otherLink isSimilar:linkEntity]).to.beFalsy();

        linkEntity = [ITLinkNode linkActionWithModuleName:ITModuleNameFromClass([_TestModule class]) link:@selector(testRoute:) arguments:@[@"bob"]];
        expect([linkEntity isSimilar:otherLink]).to.beFalsy();
        expect([otherLink isSimilar:linkEntity]).to.beFalsy();

        otherLink = [ITLinkNode linkValueWithModuleName:ITModuleNameFromClass([_TestModule class])];
        ITLinkNode *secondLink = [ITLinkNode linkValueWithModuleName:ITModuleNameFromClass([_ITRootModuleRouter class])];
        expect([otherLink isSimilar:secondLink]).to.beFalsy();
        expect([secondLink isSimilar:otherLink]).to.beFalsy();
    });

    it(@"to NO between instances of different classes of common hierarchical tree", ^{
        linkEntity = [ITLinkNode linkActionWithModuleName:ITModuleNameFromClass([_TestModule class]) link:@selector(testRoute:) arguments:@[@"bob"]];
        ITLinkNode *linkValue = [ITLinkNode linkValueWithModuleName:ITModuleNameFromClass([_ITRootModuleRouter class])];
        expect([linkEntity isSimilar:linkValue]).to.beFalsy();
        expect([linkValue isSimilar:linkEntity]).to.beFalsy();

        linkEntity = [ITLinkNode linkActionWithModuleName:ITModuleNameFromClass([_TestModule class]) link:@selector(testRoute:param1:) arguments:@[@"bob", @"tom"]];
        expect([linkEntity isSimilar:linkValue]).to.beFalsy();
        expect([linkValue isSimilar:linkEntity]).to.beFalsy();

        linkEntity = [ITLinkNode linkActionWithModuleName:ITModuleNameFromClass([_TestModule class]) link:@selector(testRoute) arguments:nil];
        expect([linkEntity isSimilar:linkValue]).to.beFalsy();
        expect([linkValue isSimilar:linkEntity]).to.beFalsy();
    });
});

describe(@"module invocations", ^{
    it(@"should return nil for node without router", ^{
        ITLinkNode *node = [ITLinkNode linkActionWithModuleName:ITModuleNameFromClass([_TestModule class]) link:@selector(testRoute:) arguments:@[@"bob"]];
        expect([node forwardModuleInvocation]).to.beNil();
        expect([node backwardModuleInvocation]).to.beNil();
    });

    it(@"should return non-nil for node with router", ^{
        _TestModule *const router = [_TestModule new];
        ITLinkNode *node = [ITLinkNode linkActionWithModuleName:ITModuleNameFromClass([_TestModule class]) link:@selector(testRoute:) arguments:@[@"bob"] router:router];
        NSInvocation *const forwardInvocation = [node forwardModuleInvocation];
        expect(forwardInvocation).notTo.beNil();
        expect(forwardInvocation.target).to.equal(router);
        expect(forwardInvocation.selector).toNot.beNil();

        NSInvocation *backInvocation = [node backwardModuleInvocation];
        expect(backInvocation).notTo.beNil();
        expect(backInvocation.target).to.equal(router);
        expect(backInvocation.selector).toNot.beNil();

        [forwardInvocation invoke];
        OCMVerify([router testRoute:[OCMArg any]]);

        [backInvocation invoke];
        OCMVerify([router unwind]);
    });
});

SpecEnd
