//
//  UserProfileModuleViewControllerTests.m
//  Example
//
//  Created by Alex Rudyak on 17/02/2016.
//  Copyright © 2016 instinctools. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import "UserProfileModuleViewController.h"

#import "UserProfileModuleViewOutput.h"

@interface UserProfileModuleViewControllerTests : XCTestCase

@property (nonatomic, strong) UserProfileModuleViewController *controller;

@property (nonatomic, strong) id mockOutput;

@end

@implementation UserProfileModuleViewControllerTests

#pragma mark - Настройка окружения для тестирования

- (void)setUp
{
    [super setUp];

    self.controller = [[UserProfileModuleViewController alloc] init];

    self.mockOutput = OCMProtocolMock(@protocol(UserProfileModuleViewOutput));

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

#pragma mark - Тестирование методов UserProfileModuleViewInput

@end
