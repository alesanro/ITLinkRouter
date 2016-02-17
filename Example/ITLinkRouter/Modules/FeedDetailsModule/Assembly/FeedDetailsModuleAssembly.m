//
//  FeedDetailsModuleAssembly.m
//  Example
//
//  Created by Alex Rudyak on 17/02/2016.
//  Copyright © 2016 instinctools. All rights reserved.
//

#import "FeedDetailsModuleAssembly.h"

#import "FeedDetailsModuleViewController.h"
#import "FeedDetailsModuleInteractor.h"
#import "FeedDetailsModulePresenter.h"
#import "FeedDetailsModuleRouter.h"

#import <ViperMcFlurry/ViperMcFlurry.h>

@implementation FeedDetailsModuleAssembly

- (FeedDetailsModuleViewController *)viewFeedDetailsModuleModule
{
    return [TyphoonDefinition withClass:[FeedDetailsModuleViewController class]
                          configuration:^(TyphoonDefinition *definition) {
                              [definition injectProperty:@selector(output)
                                                    with:[self presenterFeedDetailsModuleModule]];
                              [definition injectProperty:@selector(moduleInput)
                                                    with:[self presenterFeedDetailsModuleModule]];
                          }];
}

- (FeedDetailsModuleInteractor *)interactorFeedDetailsModuleModule
{
    return [TyphoonDefinition withClass:[FeedDetailsModuleInteractor class]
                          configuration:^(TyphoonDefinition *definition) {
                              [definition injectProperty:@selector(output)
                                                    with:[self presenterFeedDetailsModuleModule]];
                          }];
}

- (FeedDetailsModulePresenter *)presenterFeedDetailsModuleModule
{
    return [TyphoonDefinition withClass:[FeedDetailsModulePresenter class]
                          configuration:^(TyphoonDefinition *definition) {
                              [definition injectProperty:@selector(view)
                                                    with:[self viewFeedDetailsModuleModule]];
                              [definition injectProperty:@selector(interactor)
                                                    with:[self interactorFeedDetailsModuleModule]];
                              [definition injectProperty:@selector(router)
                                                    with:[self routerFeedDetailsModuleModule]];
                          }];
}

- (FeedDetailsModuleRouter *)routerFeedDetailsModuleModule
{
    return [TyphoonDefinition withClass:[FeedDetailsModuleRouter class]
                          configuration:^(TyphoonDefinition *definition) {
                              [definition injectProperty:@selector(transitionHandler)
                                                    with:[self viewFeedDetailsModuleModule]];
                          }];
}

@end
