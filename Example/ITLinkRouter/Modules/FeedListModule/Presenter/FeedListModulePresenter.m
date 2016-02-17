//
//  FeedListModulePresenter.m
//  Example
//
//  Created by Alex Rudyak on 17/02/2016.
//  Copyright © 2016 instinctools. All rights reserved.
//

#import "FeedListModulePresenter.h"

#import "FeedListModuleViewInput.h"
#import "FeedListModuleInteractorInput.h"
#import "FeedListModuleRouterInput.h"

@implementation FeedListModulePresenter

#pragma mark - Методы FeedListModuleModuleInput

- (void)configureModule
{
    // Стартовая конфигурация модуля, не привязанная к состоянию view
}

#pragma mark - Методы FeedListModuleViewOutput

- (void)didTriggerViewReadyEvent
{
    [self.view setupInitialState];
}

#pragma mark - Методы FeedListModuleInteractorOutput

@end
