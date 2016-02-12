//
//  RootModulePresenterTests.m
//  Example
//
//  Created by Alex Rudyak on 12/02/2016.
//  Copyright © 2016 instinctools. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import "RootModulePresenter.h"

#import "RootModuleViewInput.h"
#import "RootModuleInteractorInput.h"
#import "RootModuleRouterInput.h"

@interface RootModulePresenterTests : XCTestCase

@property (nonatomic, strong) RootModulePresenter *presenter;

@property (nonatomic, strong) id mockInteractor;
@property (nonatomic, strong) id mockRouter;
@property (nonatomic, strong) id mockView;

@end

@implementation RootModulePresenterTests

#pragma mark - Настройка окружения для тестирования

- (void)setUp
{
    [super setUp];

    self.presenter = [[RootModulePresenter alloc] init];

    self.mockInteractor = OCMProtocolMock(@protocol(RootModuleInteractorInput));
    self.mockRouter = OCMProtocolMock(@protocol(RootModuleRouterInput));
    self.mockView = OCMProtocolMock(@protocol(RootModuleViewInput));

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

#pragma mark - Тестирование методов RootModuleModuleInput

#pragma mark - Тестирование методов RootModuleViewOutput

- (void)testThatPresenterHandlesViewReadyEvent
{
    // given

    // when
    [self.presenter didTriggerViewReadyEvent];

    // then
    OCMVerify([self.mockView setupInitialState]);
}

#pragma mark - Тестирование методов RootModuleInteractorOutput

@end
