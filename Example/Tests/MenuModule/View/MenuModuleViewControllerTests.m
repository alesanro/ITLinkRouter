//
//  MenuModuleViewControllerTests.m
//  Example
//
//  Created by Alex Rudyak on 17/02/2016.
//  Copyright © 2016 instinctools. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import "MenuModuleViewController.h"

#import "MenuModuleViewOutput.h"

@interface MenuModuleViewControllerTests : XCTestCase

@property (nonatomic, strong) MenuModuleViewController *controller;

@property (nonatomic, strong) id mockOutput;

@end

@implementation MenuModuleViewControllerTests

#pragma mark - Настройка окружения для тестирования

- (void)setUp
{
    [super setUp];

    self.controller = [[MenuModuleViewController alloc] init];

    self.mockOutput = OCMProtocolMock(@protocol(MenuModuleViewOutput));

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

#pragma mark - Тестирование методов MenuModuleViewInput

@end
