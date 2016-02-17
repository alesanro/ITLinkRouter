//
//  LoginModuleAssembly.m
//  Example
//
//  Created by Alex Rudyak on 17/02/2016.
//  Copyright © 2016 instinctools. All rights reserved.
//

#import "LoginModuleAssembly.h"

#import "LoginModuleViewController.h"
#import "LoginModuleInteractor.h"
#import "LoginModulePresenter.h"
#import "LoginModuleRouter.h"

#import <ViperMcFlurry/ViperMcFlurry.h>

@implementation LoginModuleAssembly

- (LoginModuleViewController *)viewLoginModuleModule
{
    return [TyphoonDefinition withClass:[LoginModuleViewController class]
                          configuration:^(TyphoonDefinition *definition) {
                              [definition injectProperty:@selector(output)
                                                    with:[self presenterLoginModuleModule]];
                              [definition injectProperty:@selector(moduleInput)
                                                    with:[self presenterLoginModuleModule]];
                          }];
}

- (LoginModuleInteractor *)interactorLoginModuleModule
{
    return [TyphoonDefinition withClass:[LoginModuleInteractor class]
                          configuration:^(TyphoonDefinition *definition) {
                              [definition injectProperty:@selector(output)
                                                    with:[self presenterLoginModuleModule]];
                          }];
}

- (LoginModulePresenter *)presenterLoginModuleModule
{
    return [TyphoonDefinition withClass:[LoginModulePresenter class]
                          configuration:^(TyphoonDefinition *definition) {
                              [definition injectProperty:@selector(view)
                                                    with:[self viewLoginModuleModule]];
                              [definition injectProperty:@selector(interactor)
                                                    with:[self interactorLoginModuleModule]];
                              [definition injectProperty:@selector(router)
                                                    with:[self routerLoginModuleModule]];
                          }];
}

- (LoginModuleRouter *)routerLoginModuleModule
{
    return [TyphoonDefinition withClass:[LoginModuleRouter class]
                          configuration:^(TyphoonDefinition *definition) {
                              [definition injectProperty:@selector(transitionHandler)
                                                    with:[self viewLoginModuleModule]];
                          }];
}

@end
