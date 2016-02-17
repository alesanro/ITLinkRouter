//
//  FeedDetailsModulePresenter.m
//  Example
//
//  Created by Alex Rudyak on 17/02/2016.
//  Copyright © 2016 instinctools. All rights reserved.
//

#import "FeedDetailsModulePresenter.h"

#import "FeedDetailsModuleViewInput.h"
#import "FeedDetailsModuleInteractorInput.h"
#import "FeedDetailsModuleRouterInput.h"

@implementation FeedDetailsModulePresenter

#pragma mark - Методы FeedDetailsModuleModuleInput

- (void)configureModule
{
    // Стартовая конфигурация модуля, не привязанная к состоянию view
}

#pragma mark - Методы FeedDetailsModuleViewOutput

- (void)didTriggerViewReadyEvent
{
    [self.view setupInitialState];
}

#pragma mark - Методы FeedDetailsModuleInteractorOutput

@end
