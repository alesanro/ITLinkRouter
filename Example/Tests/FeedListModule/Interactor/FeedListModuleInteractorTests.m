//
//  FeedListModuleInteractorTests.m
//  Example
//
//  Created by Alex Rudyak on 17/02/2016.
//  Copyright © 2016 instinctools. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import "FeedListModuleInteractor.h"

#import "FeedListModuleInteractorOutput.h"

@interface FeedListModuleInteractorTests : XCTestCase

@property (nonatomic, strong) FeedListModuleInteractor *interactor;

@property (nonatomic, strong) id mockOutput;

@end

@implementation FeedListModuleInteractorTests

#pragma mark - Настройка окружения для тестирования

- (void)setUp
{
    [super setUp];

    self.interactor = [[FeedListModuleInteractor alloc] init];

    self.mockOutput = OCMProtocolMock(@protocol(FeedListModuleInteractorOutput));

    self.interactor.output = self.mockOutput;
}

- (void)tearDown
{
    self.interactor = nil;

    self.mockOutput = nil;

    [super tearDown];
}

#pragma mark - Тестирование методов FeedListModuleInteractorInput

@end
