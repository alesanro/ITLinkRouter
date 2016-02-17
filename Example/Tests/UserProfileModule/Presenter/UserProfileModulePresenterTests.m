//
//  UserProfileModulePresenterTests.m
//  Example
//
//  Created by Alex Rudyak on 17/02/2016.
//  Copyright © 2016 instinctools. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import "UserProfileModulePresenter.h"

#import "UserProfileModuleViewInput.h"
#import "UserProfileModuleInteractorInput.h"
#import "UserProfileModuleRouterInput.h"

@interface UserProfileModulePresenterTests : XCTestCase

@property (nonatomic, strong) UserProfileModulePresenter *presenter;

@property (nonatomic, strong) id mockInteractor;
@property (nonatomic, strong) id mockRouter;
@property (nonatomic, strong) id mockView;

@end

@implementation UserProfileModulePresenterTests

#pragma mark - Настройка окружения для тестирования

- (void)setUp
{
    [super setUp];

    self.presenter = [[UserProfileModulePresenter alloc] init];

    self.mockInteractor = OCMProtocolMock(@protocol(UserProfileModuleInteractorInput));
    self.mockRouter = OCMProtocolMock(@protocol(UserProfileModuleRouterInput));
    self.mockView = OCMProtocolMock(@protocol(UserProfileModuleViewInput));

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

#pragma mark - Тестирование методов UserProfileModuleModuleInput

#pragma mark - Тестирование методов UserProfileModuleViewOutput

- (void)testThatPresenterHandlesViewReadyEvent
{
    // given

    // when
    [self.presenter didTriggerViewReadyEvent];

    // then
    OCMVerify([self.mockView setupInitialState]);
}

#pragma mark - Тестирование методов UserProfileModuleInteractorOutput

@end
