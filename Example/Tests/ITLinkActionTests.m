//
//  ITLinkActionTests.m
//  ITLinkRouter
//
//  Created by Alex Rudyak on 2/3/16.
//  Copyright © 2016 Alex Rudyak. All rights reserved.
//


@interface _TestModule : NSObject

- (void)testRoute;
- (void)testRoute:(NSString *)route param1:(NSString *)param1 param2:(NSString *)param2;

@end


@implementation _TestModule

- (void)testRoute {}
- (void)testRoute:(NSString *)route param1:(NSString *)param1 param2:(NSString *)param2 {}

@end

SpecBegin(ITLinkActionTests);

__block ITLinkAction *linkEntity;

afterEach(^{
    linkEntity = nil;
});

describe(@"Entity Initialization", ^{
    it(@"should inititialize with empty arguments" , ^{
        linkEntity = [[ITLinkAction alloc] initWithModuleName:nil link:0 arguments:nil];
        expect(linkEntity.moduleName).to.beNil();
        expect(linkEntity.linkSelector).to.beNull();
        expect(linkEntity.arguments).to.beNil();
    });

    it(@"should initialize with non-empty arguments", ^{
        linkEntity = [[ITLinkAction alloc] initWithModuleName:ITModuleNameFromClass([_TestModule class]) link:@selector(testRoute) arguments:nil];
        expect(linkEntity.moduleName).equal(NSStringFromClass([_TestModule class]));
        expect(linkEntity.linkSelector).equal(@selector(testRoute));
        expect(linkEntity.arguments).to.beNil();
    });

    it(@"should have proper instance after copying", ^{
        linkEntity = [[ITLinkAction alloc] initWithModuleName:ITModuleNameFromClass([_TestModule class]) link:@selector(testRoute) arguments:nil];
        linkEntity.router = OCMProtocolMock(@protocol(ITUnwindableTransition));
        ITLinkAction *const copiedEntity = [linkEntity copy];
        expect(copiedEntity).equal(linkEntity);
        expect(copiedEntity.moduleName).equal(linkEntity.moduleName);
        expect(copiedEntity.linkSelector).equal(linkEntity.linkSelector);
        expect(copiedEntity.arguments).haveCountOf(linkEntity.arguments.count);
        expect(copiedEntity.router).equal(linkEntity.router);
    });
});

describe(@"equality should work", ^{
    it(@"to YES between instances of the same class", ^{
        linkEntity = [ITLinkNode linkActionWithModuleName:ITModuleNameFromClass([_TestModule class]) link:@selector(testRoute) arguments:@[@"bob"]];
        ITLinkNode *otherLink = [ITLinkNode linkActionWithModuleName:ITModuleNameFromClass([_TestModule class]) link:@selector(testRoute) arguments:@[@"tom"]];
        expect(linkEntity).to.equal(otherLink);
        expect(otherLink).to.equal(linkEntity);
    });

    it(@"to YES between instances of different classes but inside common hierarchical tree", ^{
        linkEntity = [ITLinkNode linkActionWithModuleName:ITModuleNameFromClass([_TestModule class]) link:@selector(testRoute) arguments:@[@"bob"]];
        ITLinkNode *linkValue = [ITLinkNode linkValueWithModuleName:ITModuleNameFromClass([_TestModule class])];
        expect(linkEntity).to.equal(linkValue);
        expect(linkValue).to.equal(linkEntity);

        linkEntity = [ITLinkNode linkActionWithModuleName:ITModuleNameFromClass([_TestModule class]) link:@selector(testRoute:param1:param2:) arguments:@[@"bob"]];
        linkValue = [ITLinkNode linkValueWithModuleName:ITModuleNameFromClass([_TestModule class])];
        expect(linkEntity).to.equal(linkValue);
        expect(linkValue).to.equal(linkEntity);

        linkEntity = [ITLinkNode linkActionWithModuleName:ITModuleNameFromClass([_TestModule class]) link:@selector(testRoute) arguments:nil];
        linkValue = [ITLinkNode linkValueWithModuleName:ITModuleNameFromClass([_TestModule class])];
        expect(linkEntity).to.equal(linkValue);
        expect(linkValue).to.equal(linkEntity);
    });

    it(@"to NO between instances of the same class", ^{
        linkEntity = [ITLinkNode linkActionWithModuleName:ITModuleNameFromClass([_TestModule class]) link:@selector(testRoute) arguments:@[@"bob"]];
        ITLinkNode *otherLink = [ITLinkNode linkActionWithModuleName:ITModuleNameFromClass([_TestModule class]) link:@selector(testRoute:param1:param2:) arguments:@[@"tom"]];
        expect(linkEntity).toNot.equal(otherLink);
        expect(otherLink).toNot.equal(linkEntity);

        linkEntity = [ITLinkNode linkActionWithModuleName:ITModuleNameFromClass([NSObject class]) link:@selector(hash) arguments:@[@"bob"]];
        otherLink = [ITLinkNode linkActionWithModuleName:ITModuleNameFromClass([_TestModule class]) link:@selector(testRoute:param1:param2:) arguments:@[@"tom"]];
        expect(linkEntity).toNot.equal(otherLink);
        expect(otherLink).toNot.equal(linkEntity);

        linkEntity = [ITLinkNode linkActionWithModuleName:ITModuleNameFromClass([_TestModule class]) link:@selector(testRoute) arguments:@[@"bob", @"colin"]];
        otherLink = [ITLinkNode linkActionWithModuleName:ITModuleNameFromClass([_TestModule class]) link:@selector(testRoute) arguments:@[@"tom"]];
        expect(linkEntity).toNot.equal(otherLink);
        expect(otherLink).toNot.equal(linkEntity);
    });

    it(@"to NO between instances of different classes but inside common hierarchical tree", ^{
        linkEntity = [ITLinkNode linkActionWithModuleName:ITModuleNameFromClass([_TestModule class]) link:@selector(testRoute) arguments:@[@"bob"]];
        ITLinkNode *linkValue = [ITLinkNode linkValueWithModuleName:ITModuleNameFromClass([NSObject class])];
        expect(linkEntity).toNot.equal(linkValue);
        expect(linkValue).toNot.equal(linkEntity);
    });
});

SpecEnd
