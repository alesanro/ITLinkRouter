//
//  RootModuleAssembly.m
//  Example
//
//  Created by Alex Rudyak on 12/02/2016.
//  Copyright © 2016 instinctools. All rights reserved.
//

#import "RootModuleAssembly.h"

#import "RootModuleViewController.h"
#import "RootModuleInteractor.h"
#import "RootModulePresenter.h"
#import "RootModuleRouter.h"

#import <ViperMcFlurry/ViperMcFlurry.h>

@implementation RootModuleAssembly

- (RootModuleViewController *)viewRootModuleModule
{
    return [TyphoonDefinition withClass:[RootModuleViewController class]
                          configuration:^(TyphoonDefinition *definition) {
                            [definition injectProperty:@selector(output) with:[self presenterRootModuleModule]];
                            [definition injectProperty:@selector(moduleInput) with:[self presenterRootModuleModule]];
                          }];
}

- (RootModuleInteractor *)interactorRootModuleModule
{
    return [TyphoonDefinition withClass:[RootModuleInteractor class]
                          configuration:^(TyphoonDefinition *definition) {
                            [definition injectProperty:@selector(output) with:[self presenterRootModuleModule]];
                          }];
}

- (RootModulePresenter *)presenterRootModuleModule
{
    return [TyphoonDefinition withClass:[RootModulePresenter class]
                          configuration:^(TyphoonDefinition *definition) {
                            [definition injectProperty:@selector(view) with:[self viewRootModuleModule]];
                            [definition injectProperty:@selector(interactor) with:[self interactorRootModuleModule]];
                            [definition injectProperty:@selector(router) with:[self routerRootModuleModule]];
                          }];
}

- (RootModuleRouter *)routerRootModuleModule
{
    return [TyphoonDefinition withClass:[RootModuleRouter class]
                          configuration:^(TyphoonDefinition *definition) {
                            [definition injectProperty:@selector(transitionHandler) with:[self viewRootModuleModule]];
                          }];
}

@end
