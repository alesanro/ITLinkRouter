//
//  RootModulePresenter.m
//  Example
//
//  Created by Alex Rudyak on 12/02/2016.
//  Copyright © 2016 instinctools. All rights reserved.
//

#import "RootModulePresenter.h"

#import "RootModuleViewInput.h"
#import "RootModuleInteractorInput.h"
#import "RootModuleRouterInput.h"

@implementation RootModulePresenter

#pragma mark - Методы RootModuleModuleInput

- (void)configureModule
{
    // Стартовая конфигурация модуля, не привязанная к состоянию view
}

#pragma mark - Методы RootModuleViewOutput

- (void)didTriggerViewReadyEvent
{
    [self.view setupInitialState];
}

#pragma mark - Методы RootModuleInteractorOutput

@end
