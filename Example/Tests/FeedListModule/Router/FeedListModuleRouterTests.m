//
//  FeedListModuleRouterTests.m
//  Example
//
//  Created by Alex Rudyak on 17/02/2016.
//  Copyright © 2016 instinctools. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import "FeedListModuleRouter.h"

@interface FeedListModuleRouterTests : XCTestCase

@property (nonatomic, strong) FeedListModuleRouter *router;

@end

@implementation FeedListModuleRouterTests

#pragma mark - Настройка окружения для тестирования

- (void)setUp
{
    [super setUp];

    self.router = [[FeedListModuleRouter alloc] init];
}

- (void)tearDown
{
    self.router = nil;

    [super tearDown];
}

@end
