//
//  LoginModulePresenter.m
//  Example
//
//  Created by Alex Rudyak on 17/02/2016.
//  Copyright © 2016 instinctools. All rights reserved.
//

#import "LoginModulePresenter.h"

#import "LoginModuleViewInput.h"
#import "LoginModuleInteractorInput.h"
#import "LoginModuleRouterInput.h"

@implementation LoginModulePresenter

#pragma mark - Методы LoginModuleModuleInput

- (void)configureModule
{
    // Стартовая конфигурация модуля, не привязанная к состоянию view
}

#pragma mark - Методы LoginModuleViewOutput

- (void)didTriggerViewReadyEvent
{
    [self.view setupInitialState];
}

#pragma mark - Методы LoginModuleInteractorOutput

@end
