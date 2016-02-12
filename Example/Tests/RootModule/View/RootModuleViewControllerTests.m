//
//  RootModuleViewControllerTests.m
//  Example
//
//  Created by Alex Rudyak on 12/02/2016.
//  Copyright © 2016 instinctools. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import "RootModuleViewController.h"

#import "RootModuleViewOutput.h"

@interface RootModuleViewControllerTests : XCTestCase

@property (nonatomic, strong) RootModuleViewController *controller;

@property (nonatomic, strong) id mockOutput;

@end

@implementation RootModuleViewControllerTests

#pragma mark - Настройка окружения для тестирования

- (void)setUp
{
    [super setUp];

    self.controller = [[RootModuleViewController alloc] init];

    self.mockOutput = OCMProtocolMock(@protocol(RootModuleViewOutput));

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

#pragma mark - Тестирование методов RootModuleViewInput

@end
