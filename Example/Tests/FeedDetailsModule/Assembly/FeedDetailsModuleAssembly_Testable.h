//
//  FeedDetailsModuleAssembly_Testable.h
//  Example
//
//  Created by Alex Rudyak on 17/02/2016.
//  Copyright © 2016 instinctools. All rights reserved.
//

#import "FeedDetailsModuleAssembly.h"

@class FeedDetailsModuleViewController;
@class FeedDetailsModuleInteractor;
@class FeedDetailsModulePresenter;
@class FeedDetailsModuleRouter;

@interface FeedDetailsModuleAssembly ()

- (FeedDetailsModuleViewController *)viewFeedDetailsModuleModule;
- (FeedDetailsModulePresenter *)presenterFeedDetailsModuleModule;
- (FeedDetailsModuleInteractor *)interactorFeedDetailsModuleModule;
- (FeedDetailsModuleRouter *)routerFeedDetailsModuleModule;

@end
