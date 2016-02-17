//
//  LoginModulePresenterTests.m
//  Example
//
//  Created by Alex Rudyak on 17/02/2016.
//  Copyright © 2016 instinctools. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import "LoginModulePresenter.h"

#import "LoginModuleViewInput.h"
#import "LoginModuleInteractorInput.h"
#import "LoginModuleRouterInput.h"

@interface LoginModulePresenterTests : XCTestCase

@property (nonatomic, strong) LoginModulePresenter *presenter;

@property (nonatomic, strong) id mockInteractor;
@property (nonatomic, strong) id mockRouter;
@property (nonatomic, strong) id mockView;

@end

@implementation LoginModulePresenterTests

#pragma mark - Настройка окружения для тестирования

- (void)setUp
{
    [super setUp];

    self.presenter = [[LoginModulePresenter alloc] init];

    self.mockInteractor = OCMProtocolMock(@protocol(LoginModuleInteractorInput));
    self.mockRouter = OCMProtocolMock(@protocol(LoginModuleRouterInput));
    self.mockView = OCMProtocolMock(@protocol(LoginModuleViewInput));

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

#pragma mark - Тестирование методов LoginModuleModuleInput

#pragma mark - Тестирование методов LoginModuleViewOutput

- (void)testThatPresenterHandlesViewReadyEvent
{
    // given

    // when
    [self.presenter didTriggerViewReadyEvent];

    // then
    OCMVerify([self.mockView setupInitialState]);
}

#pragma mark - Тестирование методов LoginModuleInteractorOutput

@end
