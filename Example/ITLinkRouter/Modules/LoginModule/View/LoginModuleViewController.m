//
//  LoginModuleViewController.m
//  Example
//
//  Created by Alex Rudyak on 17/02/2016.
//  Copyright © 2016 instinctools. All rights reserved.
//

#import "LoginModuleViewController.h"

#import "LoginModuleViewOutput.h"

@implementation LoginModuleViewController

#pragma mark - Методы жизненного цикла

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.output didTriggerViewReadyEvent];
}

#pragma mark - Методы LoginModuleViewInput

- (void)setupInitialState
{
    // В этом методе происходит настройка параметров view, зависящих от ее жизненого цикла (создание элементов, анимации и пр.)
}

@end
