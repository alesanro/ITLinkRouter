//
//  MenuModulePresenterTests.m
//  Example
//
//  Created by Alex Rudyak on 17/02/2016.
//  Copyright © 2016 instinctools. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import "MenuModulePresenter.h"

#import "MenuModuleViewInput.h"
#import "MenuModuleInteractorInput.h"
#import "MenuModuleRouterInput.h"

@interface MenuModulePresenterTests : XCTestCase

@property (nonatomic, strong) MenuModulePresenter *presenter;

@property (nonatomic, strong) id mockInteractor;
@property (nonatomic, strong) id mockRouter;
@property (nonatomic, strong) id mockView;

@end

@implementation MenuModulePresenterTests

#pragma mark - Настройка окружения для тестирования

- (void)setUp
{
    [super setUp];

    self.presenter = [[MenuModulePresenter alloc] init];

    self.mockInteractor = OCMProtocolMock(@protocol(MenuModuleInteractorInput));
    self.mockRouter = OCMProtocolMock(@protocol(MenuModuleRouterInput));
    self.mockView = OCMProtocolMock(@protocol(MenuModuleViewInput));

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

#pragma mark - Тестирование методов MenuModuleModuleInput

#pragma mark - Тестирование методов MenuModuleViewOutput

- (void)testThatPresenterHandlesViewReadyEvent
{
    // given

    // when
    [self.presenter didTriggerViewReadyEvent];

    // then
    OCMVerify([self.mockView setupInitialState]);
}

#pragma mark - Тестирование методов MenuModuleInteractorOutput

@end
