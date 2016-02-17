//
//  FeedListModuleInteractor.h
//  Example
//
//  Created by Alex Rudyak on 17/02/2016.
//  Copyright © 2016 instinctools. All rights reserved.
//

#import "FeedListModuleInteractorInput.h"

@protocol FeedListModuleInteractorOutput;

@interface FeedListModuleInteractor : NSObject <FeedListModuleInteractorInput>

@property (nonatomic, weak) id<FeedListModuleInteractorOutput> output;

@end
