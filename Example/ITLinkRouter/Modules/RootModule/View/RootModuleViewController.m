//
//  RootModuleViewController.m
//  Example
//
//  Created by Alex Rudyak on 12/02/2016.
//  Copyright © 2016 instinctools. All rights reserved.
//

#import "RootModuleViewController.h"

#import "RootModuleViewOutput.h"

@implementation RootModuleViewController

#pragma mark - Методы жизненного цикла

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.output didTriggerViewReadyEvent];
}

#pragma mark - Методы RootModuleViewInput

- (void)setupInitialState
{
    // В этом методе происходит настройка параметров view, зависящих от ее жизненого цикла (создание элементов, анимации
    // и пр.)
}

@end
