//
//  FeedDetailsModuleRouterTests.m
//  Example
//
//  Created by Alex Rudyak on 17/02/2016.
//  Copyright © 2016 instinctools. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import "FeedDetailsModuleRouter.h"

@interface FeedDetailsModuleRouterTests : XCTestCase

@property (nonatomic, strong) FeedDetailsModuleRouter *router;

@end

@implementation FeedDetailsModuleRouterTests

#pragma mark - Настройка окружения для тестирования

- (void)setUp
{
    [super setUp];

    self.router = [[FeedDetailsModuleRouter alloc] init];
}

- (void)tearDown
{
    self.router = nil;

    [super tearDown];
}

@end
