//
//  FeedListModuleAssemblyTests.m
//  Example
//
//  Created by Alex Rudyak on 17/02/2016.
//  Copyright © 2016 instinctools. All rights reserved.
//

#import <RamblerTyphoonUtils/AssemblyTesting.h>
#import <Typhoon/Typhoon.h>

#import "FeedListModuleAssembly.h"
#import "FeedListModuleAssembly_Testable.h"

#import "FeedListModuleViewController.h"
#import "FeedListModulePresenter.h"
#import "FeedListModuleInteractor.h"
#import "FeedListModuleRouter.h"

@interface FeedListModuleAssemblyTests : RamblerTyphoonAssemblyTests

@property (nonatomic, strong) FeedListModuleAssembly *assembly;

@end

@implementation FeedListModuleAssemblyTests

#pragma mark - Настройка окружения для тестирования

- (void)setUp
{
    [super setUp];

    self.assembly = [[FeedListModuleAssembly alloc] init];
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
    Class targetClass = [FeedListModuleViewController class];
    NSArray *protocols = @[
        @protocol(FeedListModuleViewInput)
    ];
    NSArray *dependencies = @[
        RamblerSelector(output)
    ];

    // when
    id result = [self.assembly viewFeedListModuleModule];

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
    Class targetClass = [FeedListModulePresenter class];
    NSArray *protocols = @[
        @protocol(FeedListModuleModuleInput),
        @protocol(FeedListModuleViewOutput),
        @protocol(FeedListModuleInteractorOutput)
    ];
    NSArray *dependencies = @[
        RamblerSelector(interactor),
        RamblerSelector(view),
        RamblerSelector(router)
    ];

    // when
    id result = [self.assembly presenterFeedListModuleModule];

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
    Class targetClass = [FeedListModuleInteractor class];
    NSArray *protocols = @[
        @protocol(FeedListModuleInteractorInput)
    ];
    NSArray *dependencies = @[
        RamblerSelector(output)
    ];

    // when
    id result = [self.assembly interactorFeedListModuleModule];

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
    Class targetClass = [FeedListModuleRouter class];
    NSArray *protocols = @[
        @protocol(FeedListModuleRouterInput)
    ];
    NSArray *dependencies = @[
        RamblerSelector(transitionHandler)
    ];

    // when
    id result = [self.assembly routerFeedListModuleModule];

    // then
    RamblerTyphoonAssemblyTestsTypeDescriptor *descriptor = [RamblerTyphoonAssemblyTestsTypeDescriptor descriptorWithClass:targetClass
                                                                                                              andProtocols:protocols];
    [self verifyTargetDependency:result
                  withDescriptor:descriptor
                    dependencies:dependencies];
}

@end
