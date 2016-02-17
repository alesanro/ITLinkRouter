//
//  FeedListModuleAssembly.m
//  Example
//
//  Created by Alex Rudyak on 17/02/2016.
//  Copyright © 2016 instinctools. All rights reserved.
//

#import "FeedListModuleAssembly.h"

#import "FeedListModuleViewController.h"
#import "FeedListModuleInteractor.h"
#import "FeedListModulePresenter.h"
#import "FeedListModuleRouter.h"

#import <ViperMcFlurry/ViperMcFlurry.h>

@implementation FeedListModuleAssembly

- (FeedListModuleViewController *)viewFeedListModuleModule
{
    return [TyphoonDefinition withClass:[FeedListModuleViewController class]
                          configuration:^(TyphoonDefinition *definition) {
                              [definition injectProperty:@selector(output)
                                                    with:[self presenterFeedListModuleModule]];
                              [definition injectProperty:@selector(moduleInput)
                                                    with:[self presenterFeedListModuleModule]];
                          }];
}

- (FeedListModuleInteractor *)interactorFeedListModuleModule
{
    return [TyphoonDefinition withClass:[FeedListModuleInteractor class]
                          configuration:^(TyphoonDefinition *definition) {
                              [definition injectProperty:@selector(output)
                                                    with:[self presenterFeedListModuleModule]];
                          }];
}

- (FeedListModulePresenter *)presenterFeedListModuleModule
{
    return [TyphoonDefinition withClass:[FeedListModulePresenter class]
                          configuration:^(TyphoonDefinition *definition) {
                              [definition injectProperty:@selector(view)
                                                    with:[self viewFeedListModuleModule]];
                              [definition injectProperty:@selector(interactor)
                                                    with:[self interactorFeedListModuleModule]];
                              [definition injectProperty:@selector(router)
                                                    with:[self routerFeedListModuleModule]];
                          }];
}

- (FeedListModuleRouter *)routerFeedListModuleModule
{
    return [TyphoonDefinition withClass:[FeedListModuleRouter class]
                          configuration:^(TyphoonDefinition *definition) {
                              [definition injectProperty:@selector(transitionHandler)
                                                    with:[self viewFeedListModuleModule]];
                          }];
}

@end
