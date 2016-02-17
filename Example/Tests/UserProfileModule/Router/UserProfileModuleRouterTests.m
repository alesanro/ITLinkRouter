//
//  UserProfileModuleRouterTests.m
//  Example
//
//  Created by Alex Rudyak on 17/02/2016.
//  Copyright © 2016 instinctools. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import "UserProfileModuleRouter.h"

@interface UserProfileModuleRouterTests : XCTestCase

@property (nonatomic, strong) UserProfileModuleRouter *router;

@end

@implementation UserProfileModuleRouterTests

#pragma mark - Настройка окружения для тестирования

- (void)setUp
{
    [super setUp];

    self.router = [[UserProfileModuleRouter alloc] init];
}

- (void)tearDown
{
    self.router = nil;

    [super tearDown];
}

@end
