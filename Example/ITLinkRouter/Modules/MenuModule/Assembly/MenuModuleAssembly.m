//
//  MenuModuleAssembly.m
//  Example
//
//  Created by Alex Rudyak on 17/02/2016.
//  Copyright © 2016 instinctools. All rights reserved.
//

#import "MenuModuleAssembly.h"

#import "MenuModuleViewController.h"
#import "MenuModuleInteractor.h"
#import "MenuModulePresenter.h"
#import "MenuModuleRouter.h"

#import <ViperMcFlurry/ViperMcFlurry.h>

@implementation MenuModuleAssembly

- (MenuModuleViewController *)viewMenuModuleModule
{
    return [TyphoonDefinition withClass:[MenuModuleViewController class]
                          configuration:^(TyphoonDefinition *definition) {
                              [definition injectProperty:@selector(output)
                                                    with:[self presenterMenuModuleModule]];
                              [definition injectProperty:@selector(moduleInput)
                                                    with:[self presenterMenuModuleModule]];
                          }];
}

- (MenuModuleInteractor *)interactorMenuModuleModule
{
    return [TyphoonDefinition withClass:[MenuModuleInteractor class]
                          configuration:^(TyphoonDefinition *definition) {
                              [definition injectProperty:@selector(output)
                                                    with:[self presenterMenuModuleModule]];
                          }];
}

- (MenuModulePresenter *)presenterMenuModuleModule
{
    return [TyphoonDefinition withClass:[MenuModulePresenter class]
                          configuration:^(TyphoonDefinition *definition) {
                              [definition injectProperty:@selector(view)
                                                    with:[self viewMenuModuleModule]];
                              [definition injectProperty:@selector(interactor)
                                                    with:[self interactorMenuModuleModule]];
                              [definition injectProperty:@selector(router)
                                                    with:[self routerMenuModuleModule]];
                          }];
}

- (MenuModuleRouter *)routerMenuModuleModule
{
    return [TyphoonDefinition withClass:[MenuModuleRouter class]
                          configuration:^(TyphoonDefinition *definition) {
                              [definition injectProperty:@selector(transitionHandler)
                                                    with:[self viewMenuModuleModule]];
                          }];
}

@end
