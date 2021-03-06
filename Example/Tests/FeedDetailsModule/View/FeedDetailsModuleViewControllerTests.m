//
//  FeedDetailsModuleViewControllerTests.m
//  Example
//
//  Created by Alex Rudyak on 17/02/2016.
//  Copyright © 2016 instinctools. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import "FeedDetailsModuleViewController.h"

#import "FeedDetailsModuleViewOutput.h"

@interface FeedDetailsModuleViewControllerTests : XCTestCase

@property (nonatomic, strong) FeedDetailsModuleViewController *controller;

@property (nonatomic, strong) id mockOutput;

@end

@implementation FeedDetailsModuleViewControllerTests

#pragma mark - Настройка окружения для тестирования

- (void)setUp
{
    [super setUp];

    self.controller = [[FeedDetailsModuleViewController alloc] init];

    self.mockOutput = OCMProtocolMock(@protocol(FeedDetailsModuleViewOutput));

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

#pragma mark - Тестирование методов FeedDetailsModuleViewInput

@end
