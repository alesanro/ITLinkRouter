//
//  LoginModuleAssemblyTests.m
//  Example
//
//  Created by Alex Rudyak on 17/02/2016.
//  Copyright © 2016 instinctools. All rights reserved.
//

#import <RamblerTyphoonUtils/AssemblyTesting.h>
#import <Typhoon/Typhoon.h>

#import "LoginModuleAssembly.h"
#import "LoginModuleAssembly_Testable.h"

#import "LoginModuleViewController.h"
#import "LoginModulePresenter.h"
#import "LoginModuleInteractor.h"
#import "LoginModuleRouter.h"

@interface LoginModuleAssemblyTests : RamblerTyphoonAssemblyTests

@property (nonatomic, strong) LoginModuleAssembly *assembly;

@end

@implementation LoginModuleAssemblyTests

#pragma mark - Настройка окружения для тестирования

- (void)setUp
{
    [super setUp];

    self.assembly = [[LoginModuleAssembly alloc] init];
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
    Class targetClass = [LoginModuleViewController class];
    NSArray *protocols = @[
        @protocol(LoginModuleViewInput)
    ];
    NSArray *dependencies = @[
        RamblerSelector(output)
    ];

    // when
    id result = [self.assembly viewLoginModuleModule];

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
    Class targetClass = [LoginModulePresenter class];
    NSArray *protocols = @[
        @protocol(LoginModuleModuleInput),
        @protocol(LoginModuleViewOutput),
        @protocol(LoginModuleInteractorOutput)
    ];
    NSArray *dependencies = @[
        RamblerSelector(interactor),
        RamblerSelector(view),
        RamblerSelector(router)
    ];

    // when
    id result = [self.assembly presenterLoginModuleModule];

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
    Class targetClass = [LoginModuleInteractor class];
    NSArray *protocols = @[
        @protocol(LoginModuleInteractorInput)
    ];
    NSArray *dependencies = @[
        RamblerSelector(output)
    ];

    // when
    id result = [self.assembly interactorLoginModuleModule];

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
    Class targetClass = [LoginModuleRouter class];
    NSArray *protocols = @[
        @protocol(LoginModuleRouterInput)
    ];
    NSArray *dependencies = @[
        RamblerSelector(transitionHandler)
    ];

    // when
    id result = [self.assembly routerLoginModuleModule];

    // then
    RamblerTyphoonAssemblyTestsTypeDescriptor *descriptor = [RamblerTyphoonAssemblyTestsTypeDescriptor descriptorWithClass:targetClass
                                                                                                              andProtocols:protocols];
    [self verifyTargetDependency:result
                  withDescriptor:descriptor
                    dependencies:dependencies];
}

@end
