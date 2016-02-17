//
//  UserProfileModuleAssembly.m
//  Example
//
//  Created by Alex Rudyak on 17/02/2016.
//  Copyright © 2016 instinctools. All rights reserved.
//

#import "UserProfileModuleAssembly.h"

#import "UserProfileModuleViewController.h"
#import "UserProfileModuleInteractor.h"
#import "UserProfileModulePresenter.h"
#import "UserProfileModuleRouter.h"

#import <ViperMcFlurry/ViperMcFlurry.h>

@implementation UserProfileModuleAssembly

- (UserProfileModuleViewController *)viewUserProfileModuleModule
{
    return [TyphoonDefinition withClass:[UserProfileModuleViewController class]
                          configuration:^(TyphoonDefinition *definition) {
                              [definition injectProperty:@selector(output)
                                                    with:[self presenterUserProfileModuleModule]];
                              [definition injectProperty:@selector(moduleInput)
                                                    with:[self presenterUserProfileModuleModule]];
                          }];
}

- (UserProfileModuleInteractor *)interactorUserProfileModuleModule
{
    return [TyphoonDefinition withClass:[UserProfileModuleInteractor class]
                          configuration:^(TyphoonDefinition *definition) {
                              [definition injectProperty:@selector(output)
                                                    with:[self presenterUserProfileModuleModule]];
                          }];
}

- (UserProfileModulePresenter *)presenterUserProfileModuleModule
{
    return [TyphoonDefinition withClass:[UserProfileModulePresenter class]
                          configuration:^(TyphoonDefinition *definition) {
                              [definition injectProperty:@selector(view)
                                                    with:[self viewUserProfileModuleModule]];
                              [definition injectProperty:@selector(interactor)
                                                    with:[self interactorUserProfileModuleModule]];
                              [definition injectProperty:@selector(router)
                                                    with:[self routerUserProfileModuleModule]];
                          }];
}

- (UserProfileModuleRouter *)routerUserProfileModuleModule
{
    return [TyphoonDefinition withClass:[UserProfileModuleRouter class]
                          configuration:^(TyphoonDefinition *definition) {
                              [definition injectProperty:@selector(transitionHandler)
                                                    with:[self viewUserProfileModuleModule]];
                          }];
}

@end
