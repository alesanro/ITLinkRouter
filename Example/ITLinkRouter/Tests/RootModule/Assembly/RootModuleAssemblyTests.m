//
//  RootModuleAssemblyTests.m
//  Example
//
//  Created by Alex Rudyak on 12/02/2016.
//  Copyright © 2016 instinctools. All rights reserved.
//

#import <RamblerTyphoonUtils/AssemblyTesting.h>
#import <Typhoon/Typhoon.h>

#import "RootModuleAssembly.h"
#import "RootModuleAssembly_Testable.h"

#import "RootModuleViewController.h"
#import "RootModulePresenter.h"
#import "RootModuleInteractor.h"
#import "RootModuleRouter.h"

@interface RootModuleAssemblyTests : RamblerTyphoonAssemblyTests

@property (nonatomic, strong) RootModuleAssembly *assembly;

@end

@implementation RootModuleAssemblyTests

#pragma mark - Настройка окружения для тестирования

- (void)setUp
{
    [super setUp];

    self.assembly = [[RootModuleAssembly alloc] init];
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
    Class targetClass = [RootModuleViewController class];
    NSArray *protocols = @[ @protocol(RootModuleViewInput) ];
    NSArray *dependencies = @[ RamblerSelector(output) ];

    // when
    id result = [self.assembly viewRootModuleModule];

    // then
    RamblerTyphoonAssemblyTestsTypeDescriptor *descriptor =
        [RamblerTyphoonAssemblyTestsTypeDescriptor descriptorWithClass:targetClass andProtocols:protocols];
    [self verifyTargetDependency:result withDescriptor:descriptor dependencies:dependencies];
}

- (void)testThatAssemblyCreatesPresenter
{
    // given
    Class targetClass = [RootModulePresenter class];
    NSArray *protocols =
        @[ @protocol(RootModuleModuleInput), @protocol(RootModuleViewOutput), @protocol(RootModuleInteractorOutput) ];
    NSArray *dependencies = @[ RamblerSelector(interactor), RamblerSelector(view), RamblerSelector(router) ];

    // when
    id result = [self.assembly presenterRootModuleModule];

    // then
    RamblerTyphoonAssemblyTestsTypeDescriptor *descriptor =
        [RamblerTyphoonAssemblyTestsTypeDescriptor descriptorWithClass:targetClass andProtocols:protocols];
    [self verifyTargetDependency:result withDescriptor:descriptor dependencies:dependencies];
}

- (void)testThatAssemblyCreatesInteractor
{
    // given
    Class targetClass = [RootModuleInteractor class];
    NSArray *protocols = @[ @protocol(RootModuleInteractorInput) ];
    NSArray *dependencies = @[ RamblerSelector(output) ];

    // when
    id result = [self.assembly interactorRootModuleModule];

    // then
    RamblerTyphoonAssemblyTestsTypeDescriptor *descriptor =
        [RamblerTyphoonAssemblyTestsTypeDescriptor descriptorWithClass:targetClass andProtocols:protocols];
    [self verifyTargetDependency:result withDescriptor:descriptor dependencies:dependencies];
}

- (void)testThatAssemblyCreatesRouter
{
    // given
    Class targetClass = [RootModuleRouter class];
    NSArray *protocols = @[ @protocol(RootModuleRouterInput) ];
    NSArray *dependencies = @[ RamblerSelector(transitionHandler) ];

    // when
    id result = [self.assembly routerRootModuleModule];

    // then
    RamblerTyphoonAssemblyTestsTypeDescriptor *descriptor =
        [RamblerTyphoonAssemblyTestsTypeDescriptor descriptorWithClass:targetClass andProtocols:protocols];
    [self verifyTargetDependency:result withDescriptor:descriptor dependencies:dependencies];
}

@end
