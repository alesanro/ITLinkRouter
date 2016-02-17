//
//  FeedDetailsModulePresenterTests.m
//  Example
//
//  Created by Alex Rudyak on 17/02/2016.
//  Copyright © 2016 instinctools. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import "FeedDetailsModulePresenter.h"

#import "FeedDetailsModuleViewInput.h"
#import "FeedDetailsModuleInteractorInput.h"
#import "FeedDetailsModuleRouterInput.h"

@interface FeedDetailsModulePresenterTests : XCTestCase

@property (nonatomic, strong) FeedDetailsModulePresenter *presenter;

@property (nonatomic, strong) id mockInteractor;
@property (nonatomic, strong) id mockRouter;
@property (nonatomic, strong) id mockView;

@end

@implementation FeedDetailsModulePresenterTests

#pragma mark - Настройка окружения для тестирования

- (void)setUp
{
    [super setUp];

    self.presenter = [[FeedDetailsModulePresenter alloc] init];

    self.mockInteractor = OCMProtocolMock(@protocol(FeedDetailsModuleInteractorInput));
    self.mockRouter = OCMProtocolMock(@protocol(FeedDetailsModuleRouterInput));
    self.mockView = OCMProtocolMock(@protocol(FeedDetailsModuleViewInput));

    self.presenter.interactor = self.mockInteractor;
    self.presenter.router = self.mockRouter;
    self.presenter.view = self.mockView;
}

- (void)tearDown
{
    self.presenter = nil;

    self.mockView = nil;
    self.mockRouter = nil;
    self.mockInteractor = nil;

    [super tearDown];
}

#pragma mark - Тестирование методов FeedDetailsModuleModuleInput

#pragma mark - Тестирование методов FeedDetailsModuleViewOutput

- (void)testThatPresenterHandlesViewReadyEvent
{
    // given

    // when
    [self.presenter didTriggerViewReadyEvent];

    // then
    OCMVerify([self.mockView setupInitialState]);
}

#pragma mark - Тестирование методов FeedDetailsModuleInteractorOutput

@end
