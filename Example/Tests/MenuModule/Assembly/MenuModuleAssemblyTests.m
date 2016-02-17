//
//  MenuModuleAssemblyTests.m
//  Example
//
//  Created by Alex Rudyak on 17/02/2016.
//  Copyright © 2016 instinctools. All rights reserved.
//

#import <RamblerTyphoonUtils/AssemblyTesting.h>
#import <Typhoon/Typhoon.h>

#import "MenuModuleAssembly.h"
#import "MenuModuleAssembly_Testable.h"

#import "MenuModuleViewController.h"
#import "MenuModulePresenter.h"
#import "MenuModuleInteractor.h"
#import "MenuModuleRouter.h"

@interface MenuModuleAssemblyTests : RamblerTyphoonAssemblyTests

@property (nonatomic, strong) MenuModuleAssembly *assembly;

@end

@implementation MenuModuleAssemblyTests

#pragma mark - Настройка окружения для тестирования

- (void)setUp
{
    [super setUp];

    self.assembly = [[MenuModuleAssembly alloc] init];
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
    Class targetClass = [MenuModuleViewController class];
    NSArray *protocols = @[
        @protocol(MenuModuleViewInput)
    ];
    NSArray *dependencies = @[
        RamblerSelector(output)
    ];

    // when
    id result = [self.assembly viewMenuModuleModule];

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
    Class targetClass = [MenuModulePresenter class];
    NSArray *protocols = @[
        @protocol(MenuModuleModuleInput),
        @protocol(MenuModuleViewOutput),
        @protocol(MenuModuleInteractorOutput)
    ];
    NSArray *dependencies = @[
        RamblerSelector(interactor),
        RamblerSelector(view),
        RamblerSelector(router)
    ];

    // when
    id result = [self.assembly presenterMenuModuleModule];

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
    Class targetClass = [MenuModuleInteractor class];
    NSArray *protocols = @[
        @protocol(MenuModuleInteractorInput)
    ];
    NSArray *dependencies = @[
        RamblerSelector(output)
    ];

    // when
    id result = [self.assembly interactorMenuModuleModule];

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
    Class targetClass = [MenuModuleRouter class];
    NSArray *protocols = @[
        @protocol(MenuModuleRouterInput)
    ];
    NSArray *dependencies = @[
        RamblerSelector(transitionHandler)
    ];

    // when
    id result = [self.assembly routerMenuModuleModule];

    // then
    RamblerTyphoonAssemblyTestsTypeDescriptor *descriptor = [RamblerTyphoonAssemblyTestsTypeDescriptor descriptorWithClass:targetClass
                                                                                                              andProtocols:protocols];
    [self verifyTargetDependency:result
                  withDescriptor:descriptor
                    dependencies:dependencies];
}

@end
