//
//  MenuModuleRouterTests.m
//  Example
//
//  Created by Alex Rudyak on 17/02/2016.
//  Copyright © 2016 instinctools. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import "MenuModuleRouter.h"

@interface MenuModuleRouterTests : XCTestCase

@property (nonatomic, strong) MenuModuleRouter *router;

@end

@implementation MenuModuleRouterTests

#pragma mark - Настройка окружения для тестирования

- (void)setUp
{
    [super setUp];

    self.router = [[MenuModuleRouter alloc] init];
}

- (void)tearDown
{
    self.router = nil;

    [super tearDown];
}

@end
