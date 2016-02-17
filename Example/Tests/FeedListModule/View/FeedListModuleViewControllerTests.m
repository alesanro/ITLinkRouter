//
//  FeedListModuleViewControllerTests.m
//  Example
//
//  Created by Alex Rudyak on 17/02/2016.
//  Copyright © 2016 instinctools. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import "FeedListModuleViewController.h"

#import "FeedListModuleViewOutput.h"

@interface FeedListModuleViewControllerTests : XCTestCase

@property (nonatomic, strong) FeedListModuleViewController *controller;

@property (nonatomic, strong) id mockOutput;

@end

@implementation FeedListModuleViewControllerTests

#pragma mark - Настройка окружения для тестирования

- (void)setUp
{
    [super setUp];

    self.controller = [[FeedListModuleViewController alloc] init];

    self.mockOutput = OCMProtocolMock(@protocol(FeedListModuleViewOutput));

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

#pragma mark - Тестирование методов FeedListModuleViewInput

@end
