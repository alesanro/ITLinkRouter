//
//  LoginModuleViewControllerTests.m
//  Example
//
//  Created by Alex Rudyak on 17/02/2016.
//  Copyright © 2016 instinctools. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import "LoginModuleViewController.h"

#import "LoginModuleViewOutput.h"

@interface LoginModuleViewControllerTests : XCTestCase

@property (nonatomic, strong) LoginModuleViewController *controller;

@property (nonatomic, strong) id mockOutput;

@end

@implementation LoginModuleViewControllerTests

#pragma mark - Настройка окружения для тестирования

- (void)setUp
{
    [super setUp];

    self.controller = [[LoginModuleViewController alloc] init];

    self.mockOutput = OCMProtocolMock(@protocol(LoginModuleViewOutput));

    self.controller.output = self.mockOutput;
}

- (void)tearDown
{
    self.controller = nil;

    self.mockOutput = nil;

    [super tearDown];
}

#pragma mark - Тестирование жизненного цикла

- (void)testThatControllerNotifiesPresenterOnDidLoad
{
    // given

    // when
    [self.controller viewDidLoad];

    // then
    OCMVerify([self.mockOutput didTriggerViewReadyEvent]);
}

#pragma mark - Тестирование методов интерфейса

#pragma mark - Тестирование методов LoginModuleViewInput

@end
