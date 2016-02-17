//
//  LoginModuleInteractorTests.m
//  Example
//
//  Created by Alex Rudyak on 17/02/2016.
//  Copyright © 2016 instinctools. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import "LoginModuleInteractor.h"

#import "LoginModuleInteractorOutput.h"

@interface LoginModuleInteractorTests : XCTestCase

@property (nonatomic, strong) LoginModuleInteractor *interactor;

@property (nonatomic, strong) id mockOutput;

@end

@implementation LoginModuleInteractorTests

#pragma mark - Настройка окружения для тестирования

- (void)setUp
{
    [super setUp];

    self.interactor = [[LoginModuleInteractor alloc] init];

    self.mockOutput = OCMProtocolMock(@protocol(LoginModuleInteractorOutput));

    self.interactor.output = self.mockOutput;
}

- (void)tearDown
{
    self.interactor = nil;

    self.mockOutput = nil;

    [super tearDown];
}

#pragma mark - Тестирование методов LoginModuleInteractorInput

@end
