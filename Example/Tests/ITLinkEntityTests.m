//
//  ITLinkEntityTests.m
//  ITLinkRouter
//
//  Created by Alex Rudyak on 2/1/16.
//  Copyright © 2016 Alex Rudyak. All rights reserved.
//

@import ITLinkRouter;


@interface _TestModule : NSObject

- (void)testRoute;
- (void)testRoute:(NSString *)route param1:(NSString *)param1 param2:(NSString *)param2;

@end


@implementation _TestModule

- (void)testRoute {}
- (void)testRoute:(NSString *)route param1:(NSString *)param1 param2:(NSString *)param2 {}

@end


SpecBegin(ITLinkEntityTests);

__block ITLinkEntity *linkEntity;

afterEach(^{
    linkEntity = nil;
});

describe(@"Entity Initialization", ^{
    it(@"should inititialize with empty arguments" , ^{
        linkEntity = [[ITLinkEntity alloc] initWithModule:nil link:0 arguments:nil];
        expect(linkEntity.moduleName).to.beNil();
        expect(linkEntity.linkSelector).to.beNull();
        expect(linkEntity.arguments).to.beNil();
    });

    it(@"should initialize with non-empty arguments", ^{
        linkEntity = [[ITLinkEntity alloc] initWithModule:NSStringFromClass([_TestModule class]) link:@selector(testRoute) arguments:nil];
        expect(linkEntity.moduleName).equal(NSStringFromClass([_TestModule class]));
        expect(linkEntity.linkSelector).equal(@selector(testRoute));
        expect(linkEntity.arguments).to.beNil();
    });

    it(@"should have proper instance after copying", ^{
        ITLinkEntity *const copiedEntity = [linkEntity copy];
        expect(copiedEntity).equal(linkEntity);
    });
});

SpecEnd
