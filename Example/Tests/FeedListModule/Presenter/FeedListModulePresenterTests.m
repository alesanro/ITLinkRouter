//
//  FeedListModulePresenterTests.m
//  Example
//
//  Created by Alex Rudyak on 17/02/2016.
//  Copyright © 2016 instinctools. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import "FeedListModulePresenter.h"

#import "FeedListModuleViewInput.h"
#import "FeedListModuleInteractorInput.h"
#import "FeedListModuleRouterInput.h"

@interface FeedListModulePresenterTests : XCTestCase

@property (nonatomic, strong) FeedListModulePresenter *presenter;

@property (nonatomic, strong) id mockInteractor;
@property (nonatomic, strong) id mockRouter;
@property (nonatomic, strong) id mockView;

@end

@implementation FeedListModulePresenterTests

#pragma mark - Настройка окружения для тестирования

- (void)setUp
{
    [super setUp];

    self.presenter = [[FeedListModulePresenter alloc] init];

    self.mockInteractor = OCMProtocolMock(@protocol(FeedListModuleInteractorInput));
    self.mockRouter = OCMProtocolMock(@protocol(FeedListModuleRouterInput));
    self.mockView = OCMProtocolMock(@protocol(FeedListModuleViewInput));

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

#pragma mark - Тестирование методов FeedListModuleModuleInput

#pragma mark - Тестирование методов FeedListModuleViewOutput

- (void)testThatPresenterHandlesViewReadyEvent
{
    // given

    // when
    [self.presenter didTriggerViewReadyEvent];

    // then
    OCMVerify([self.mockView setupInitialState]);
}

#pragma mark - Тестирование методов FeedListModuleInteractorOutput

@end
