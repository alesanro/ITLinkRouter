//
//  UserProfileModuleInteractorTests.m
//  Example
//
//  Created by Alex Rudyak on 17/02/2016.
//  Copyright © 2016 instinctools. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import "UserProfileModuleInteractor.h"

#import "UserProfileModuleInteractorOutput.h"

@interface UserProfileModuleInteractorTests : XCTestCase

@property (nonatomic, strong) UserProfileModuleInteractor *interactor;

@property (nonatomic, strong) id mockOutput;

@end

@implementation UserProfileModuleInteractorTests

#pragma mark - Настройка окружения для тестирования

- (void)setUp
{
    [super setUp];

    self.interactor = [[UserProfileModuleInteractor alloc] init];

    self.mockOutput = OCMProtocolMock(@protocol(UserProfileModuleInteractorOutput));

    self.interactor.output = self.mockOutput;
}

- (void)tearDown
{
    self.interactor = nil;

    self.mockOutput = nil;

    [super tearDown];
}

#pragma mark - Тестирование методов UserProfileModuleInteractorInput

@end
