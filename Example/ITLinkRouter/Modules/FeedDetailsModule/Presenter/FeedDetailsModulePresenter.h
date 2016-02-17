//
//  FeedDetailsModulePresenter.h
//  Example
//
//  Created by Alex Rudyak on 17/02/2016.
//  Copyright © 2016 instinctools. All rights reserved.
//

#import "FeedDetailsModuleViewOutput.h"
#import "FeedDetailsModuleInteractorOutput.h"
#import "FeedDetailsModuleModuleInput.h"

@protocol FeedDetailsModuleViewInput;
@protocol FeedDetailsModuleInteractorInput;
@protocol FeedDetailsModuleRouterInput;

@interface FeedDetailsModulePresenter : NSObject <FeedDetailsModuleModuleInput, FeedDetailsModuleViewOutput, FeedDetailsModuleInteractorOutput>

@property (nonatomic, weak) id<FeedDetailsModuleViewInput> view;
@property (nonatomic, strong) id<FeedDetailsModuleInteractorInput> interactor;
@property (nonatomic, strong) id<FeedDetailsModuleRouterInput> router;

@end
