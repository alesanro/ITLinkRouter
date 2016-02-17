//
//  FeedDetailsModuleInteractorTests.m
//  Example
//
//  Created by Alex Rudyak on 17/02/2016.
//  Copyright © 2016 instinctools. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import "FeedDetailsModuleInteractor.h"

#import "FeedDetailsModuleInteractorOutput.h"

@interface FeedDetailsModuleInteractorTests : XCTestCase

@property (nonatomic, strong) FeedDetailsModuleInteractor *interactor;

@property (nonatomic, strong) id mockOutput;

@end

@implementation FeedDetailsModuleInteractorTests

#pragma mark - Настройка окружения для тестирования

- (void)setUp
{
    [super setUp];

    self.interactor = [[FeedDetailsModuleInteractor alloc] init];

    self.mockOutput = OCMProtocolMock(@protocol(FeedDetailsModuleInteractorOutput));

    self.interactor.output = self.mockOutput;
}

- (void)tearDown
{
    self.interactor = nil;

    self.mockOutput = nil;

    [super tearDown];
}

#pragma mark - Тестирование методов FeedDetailsModuleInteractorInput

@end
