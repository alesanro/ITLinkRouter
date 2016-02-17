//
//  FeedListModulePresenter.h
//  Example
//
//  Created by Alex Rudyak on 17/02/2016.
//  Copyright © 2016 instinctools. All rights reserved.
//

#import "FeedListModuleViewOutput.h"
#import "FeedListModuleInteractorOutput.h"
#import "FeedListModuleModuleInput.h"

@protocol FeedListModuleViewInput;
@protocol FeedListModuleInteractorInput;
@protocol FeedListModuleRouterInput;

@interface FeedListModulePresenter : NSObject <FeedListModuleModuleInput, FeedListModuleViewOutput, FeedListModuleInteractorOutput>

@property (nonatomic, weak) id<FeedListModuleViewInput> view;
@property (nonatomic, strong) id<FeedListModuleInteractorInput> interactor;
@property (nonatomic, strong) id<FeedListModuleRouterInput> router;

@end
