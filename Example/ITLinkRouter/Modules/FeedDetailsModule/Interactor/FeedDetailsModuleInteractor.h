//
//  FeedDetailsModuleInteractor.h
//  Example
//
//  Created by Alex Rudyak on 17/02/2016.
//  Copyright © 2016 instinctools. All rights reserved.
//

#import "FeedDetailsModuleInteractorInput.h"

@protocol FeedDetailsModuleInteractorOutput;

@interface FeedDetailsModuleInteractor : NSObject <FeedDetailsModuleInteractorInput>

@property (nonatomic, weak) id<FeedDetailsModuleInteractorOutput> output;

@end
