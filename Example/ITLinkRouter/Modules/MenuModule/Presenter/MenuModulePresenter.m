//
//  MenuModulePresenter.m
//  Example
//
//  Created by Alex Rudyak on 17/02/2016.
//  Copyright © 2016 instinctools. All rights reserved.
//

#import "MenuModulePresenter.h"

#import "MenuModuleViewInput.h"
#import "MenuModuleInteractorInput.h"
#import "MenuModuleRouterInput.h"

@implementation MenuModulePresenter

#pragma mark - Методы MenuModuleModuleInput

- (void)configureModule
{
    // Стартовая конфигурация модуля, не привязанная к состоянию view
}

#pragma mark - Методы MenuModuleViewOutput

- (void)didTriggerViewReadyEvent
{
    [self.view setupInitialState];
}

#pragma mark - Методы MenuModuleInteractorOutput

@end
