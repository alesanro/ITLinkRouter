//
//  UserProfileModulePresenter.m
//  Example
//
//  Created by Alex Rudyak on 17/02/2016.
//  Copyright © 2016 instinctools. All rights reserved.
//

#import "UserProfileModulePresenter.h"

#import "UserProfileModuleViewInput.h"
#import "UserProfileModuleInteractorInput.h"
#import "UserProfileModuleRouterInput.h"

@implementation UserProfileModulePresenter

#pragma mark - Методы UserProfileModuleModuleInput

- (void)configureModule
{
    // Стартовая конфигурация модуля, не привязанная к состоянию view
}

#pragma mark - Методы UserProfileModuleViewOutput

- (void)didTriggerViewReadyEvent
{
    [self.view setupInitialState];
}

#pragma mark - Методы UserProfileModuleInteractorOutput

@end
