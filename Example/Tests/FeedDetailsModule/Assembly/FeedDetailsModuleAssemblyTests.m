//
//  FeedDetailsModuleAssemblyTests.m
//  Example
//
//  Created by Alex Rudyak on 17/02/2016.
//  Copyright © 2016 instinctools. All rights reserved.
//

#import <RamblerTyphoonUtils/AssemblyTesting.h>
#import <Typhoon/Typhoon.h>

#import "FeedDetailsModuleAssembly.h"
#import "FeedDetailsModuleAssembly_Testable.h"

#import "FeedDetailsModuleViewController.h"
#import "FeedDetailsModulePresenter.h"
#import "FeedDetailsModuleInteractor.h"
#import "FeedDetailsModuleRouter.h"

@interface FeedDetailsModuleAssemblyTests : RamblerTyphoonAssemblyTests

@property (nonatomic, strong) FeedDetailsModuleAssembly *assembly;

@end

@implementation FeedDetailsModuleAssemblyTests

#pragma mark - Настройка окружения для тестирования

- (void)setUp
{
    [super setUp];

    self.assembly = [[FeedDetailsModuleAssembly alloc] init];
    [self.assembly activate];
}

- (void)tearDown
{
    self.assembly = nil;

    [super tearDown];
}

#pragma mark - Тестирование создания элементов модуля

- (void)testThatAssemblyCreatesViewController
{
    // given
    Class targetClass = [FeedDetailsModuleViewController class];
    NSArray *protocols = @[
        @protocol(FeedDetailsModuleViewInput)
    ];
    NSArray *dependencies = @[
        RamblerSelector(output)
    ];

    // when
    id result = [self.assembly viewFeedDetailsModuleModule];

    // then
    RamblerTyphoonAssemblyTestsTypeDescriptor *descriptor = [RamblerTyphoonAssemblyTestsTypeDescriptor descriptorWithClass:targetClass
                                                                                                              andProtocols:protocols];
    [self verifyTargetDependency:result
                  withDescriptor:descriptor
                    dependencies:dependencies];
}

- (void)testThatAssemblyCreatesPresenter
{
    // given
    Class targetClass = [FeedDetailsModulePresenter class];
    NSArray *protocols = @[
        @protocol(FeedDetailsModuleModuleInput),
        @protocol(FeedDetailsModuleViewOutput),
        @protocol(FeedDetailsModuleInteractorOutput)
    ];
    NSArray *dependencies = @[
        RamblerSelector(interactor),
        RamblerSelector(view),
        RamblerSelector(router)
    ];

    // when
    id result = [self.assembly presenterFeedDetailsModuleModule];

    // then
    RamblerTyphoonAssemblyTestsTypeDescriptor *descriptor = [RamblerTyphoonAssemblyTestsTypeDescriptor descriptorWithClass:targetClass
                                                                                                              andProtocols:protocols];
    [self verifyTargetDependency:result
                  withDescriptor:descriptor
                    dependencies:dependencies];
}

- (void)testThatAssemblyCreatesInteractor
{
    // given
    Class targetClass = [FeedDetailsModuleInteractor class];
    NSArray *protocols = @[
        @protocol(FeedDetailsModuleInteractorInput)
    ];
    NSArray *dependencies = @[
        RamblerSelector(output)
    ];

    // when
    id result = [self.assembly interactorFeedDetailsModuleModule];

    // then
    RamblerTyphoonAssemblyTestsTypeDescriptor *descriptor = [RamblerTyphoonAssemblyTestsTypeDescriptor descriptorWithClass:targetClass
                                                                                                              andProtocols:protocols];
    [self verifyTargetDependency:result
                  withDescriptor:descriptor
                    dependencies:dependencies];
}

- (void)testThatAssemblyCreatesRouter
{
    // given
    Class targetClass = [FeedDetailsModuleRouter class];
    NSArray *protocols = @[
        @protocol(FeedDetailsModuleRouterInput)
    ];
    NSArray *dependencies = @[
        RamblerSelector(transitionHandler)
    ];

    // when
    id result = [self.assembly routerFeedDetailsModuleModule];

    // then
    RamblerTyphoonAssemblyTestsTypeDescriptor *descriptor = [RamblerTyphoonAssemblyTestsTypeDescriptor descriptorWithClass:targetClass
                                                                                                              andProtocols:protocols];
    [self verifyTargetDependency:result
                  withDescriptor:descriptor
                    dependencies:dependencies];
}

@end
