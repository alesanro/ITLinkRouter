//
//  UserProfileModuleAssemblyTests.m
//  Example
//
//  Created by Alex Rudyak on 17/02/2016.
//  Copyright © 2016 instinctools. All rights reserved.
//

#import <RamblerTyphoonUtils/AssemblyTesting.h>
#import <Typhoon/Typhoon.h>

#import "UserProfileModuleAssembly.h"
#import "UserProfileModuleAssembly_Testable.h"

#import "UserProfileModuleViewController.h"
#import "UserProfileModulePresenter.h"
#import "UserProfileModuleInteractor.h"
#import "UserProfileModuleRouter.h"

@interface UserProfileModuleAssemblyTests : RamblerTyphoonAssemblyTests

@property (nonatomic, strong) UserProfileModuleAssembly *assembly;

@end

@implementation UserProfileModuleAssemblyTests

#pragma mark - Настройка окружения для тестирования

- (void)setUp
{
    [super setUp];

    self.assembly = [[UserProfileModuleAssembly alloc] init];
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
    Class targetClass = [UserProfileModuleViewController class];
    NSArray *protocols = @[
        @protocol(UserProfileModuleViewInput)
    ];
    NSArray *dependencies = @[
        RamblerSelector(output)
    ];

    // when
    id result = [self.assembly viewUserProfileModuleModule];

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
    Class targetClass = [UserProfileModulePresenter class];
    NSArray *protocols = @[
        @protocol(UserProfileModuleModuleInput),
        @protocol(UserProfileModuleViewOutput),
        @protocol(UserProfileModuleInteractorOutput)
    ];
    NSArray *dependencies = @[
        RamblerSelector(interactor),
        RamblerSelector(view),
        RamblerSelector(router)
    ];

    // when
    id result = [self.assembly presenterUserProfileModuleModule];

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
    Class targetClass = [UserProfileModuleInteractor class];
    NSArray *protocols = @[
        @protocol(UserProfileModuleInteractorInput)
    ];
    NSArray *dependencies = @[
        RamblerSelector(output)
    ];

    // when
    id result = [self.assembly interactorUserProfileModuleModule];

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
    Class targetClass = [UserProfileModuleRouter class];
    NSArray *protocols = @[
        @protocol(UserProfileModuleRouterInput)
    ];
    NSArray *dependencies = @[
        RamblerSelector(transitionHandler)
    ];

    // when
    id result = [self.assembly routerUserProfileModuleModule];

    // then
    RamblerTyphoonAssemblyTestsTypeDescriptor *descriptor = [RamblerTyphoonAssemblyTestsTypeDescriptor descriptorWithClass:targetClass
                                                                                                              andProtocols:protocols];
    [self verifyTargetDependency:result
                  withDescriptor:descriptor
                    dependencies:dependencies];
}

@end
