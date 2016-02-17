//
//  FeedListModuleAssembly_Testable.h
//  Example
//
//  Created by Alex Rudyak on 17/02/2016.
//  Copyright © 2016 instinctools. All rights reserved.
//

#import "FeedListModuleAssembly.h"

@class FeedListModuleViewController;
@class FeedListModuleInteractor;
@class FeedListModulePresenter;
@class FeedListModuleRouter;

@interface FeedListModuleAssembly ()

- (FeedListModuleViewController *)viewFeedListModuleModule;
- (FeedListModulePresenter *)presenterFeedListModuleModule;
- (FeedListModuleInteractor *)interactorFeedListModuleModule;
- (FeedListModuleRouter *)routerFeedListModuleModule;

@end
