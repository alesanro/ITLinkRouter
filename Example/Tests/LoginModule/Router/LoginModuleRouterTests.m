//
//  LoginModuleRouterTests.m
//  Example
//
//  Created by Alex Rudyak on 17/02/2016.
//  Copyright © 2016 instinctools. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import "LoginModuleRouter.h"

@interface LoginModuleRouterTests : XCTestCase

@property (nonatomic, strong) LoginModuleRouter *router;

@end

@implementation LoginModuleRouterTests

#pragma mark - Настройка окружения для тестирования

- (void)setUp
{
    [super setUp];

    self.router = [[LoginModuleRouter alloc] init];
}

- (void)tearDown
{
    self.router = nil;

    [super tearDown];
}

@end
