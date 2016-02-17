//
//  MenuModuleInteractorTests.m
//  Example
//
//  Created by Alex Rudyak on 17/02/2016.
//  Copyright © 2016 instinctools. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import "MenuModuleInteractor.h"

#import "MenuModuleInteractorOutput.h"

@interface MenuModuleInteractorTests : XCTestCase

@property (nonatomic, strong) MenuModuleInteractor *interactor;

@property (nonatomic, strong) id mockOutput;

@end

@implementation MenuModuleInteractorTests

#pragma mark - Настройка окружения для тестирования

- (void)setUp
{
    [super setUp];

    self.interactor = [[MenuModuleInteractor alloc] init];

    self.mockOutput = OCMProtocolMock(@protocol(MenuModuleInteractorOutput));

    self.interactor.output = self.mockOutput;
}

- (void)tearDown
{
    self.interactor = nil;

    self.mockOutput = nil;

    [super tearDown];
}

#pragma mark - Тестирование методов MenuModuleInteractorInput

@end
