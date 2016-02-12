//
//  RootModuleInteractorTests.m
//  Example
//
//  Created by Alex Rudyak on 12/02/2016.
//  Copyright © 2016 instinctools. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import "RootModuleInteractor.h"

#import "RootModuleInteractorOutput.h"

@interface RootModuleInteractorTests : XCTestCase

@property (nonatomic, strong) RootModuleInteractor *interactor;

@property (nonatomic, strong) id mockOutput;

@end

@implementation RootModuleInteractorTests

#pragma mark - Настройка окружения для тестирования

- (void)setUp
{
    [super setUp];

    self.interactor = [[RootModuleInteractor alloc] init];

    self.mockOutput = OCMProtocolMock(@protocol(RootModuleInteractorOutput));

    self.interactor.output = self.mockOutput;
}

- (void)tearDown
{
    self.interactor = nil;

    self.mockOutput = nil;

    [super tearDown];
}

#pragma mark - Тестирование методов RootModuleInteractorInput

@end
