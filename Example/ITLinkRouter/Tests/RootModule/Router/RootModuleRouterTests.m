//
//  RootModuleRouterTests.m
//  Example
//
//  Created by Alex Rudyak on 12/02/2016.
//  Copyright © 2016 instinctools. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import "RootModuleRouter.h"

@interface RootModuleRouterTests : XCTestCase

@property (nonatomic, strong) RootModuleRouter *router;

@end

@implementation RootModuleRouterTests

#pragma mark - Настройка окружения для тестирования

- (void)setUp
{
    [super setUp];

    self.router = [[RootModuleRouter alloc] init];
}

- (void)tearDown
{
    self.router = nil;

    [super tearDown];
}

@end
