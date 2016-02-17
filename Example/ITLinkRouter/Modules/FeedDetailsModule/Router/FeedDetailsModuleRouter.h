//
//  FeedDetailsModuleRouter.h
//  Example
//
//  Created by Alex Rudyak on 17/02/2016.
//  Copyright © 2016 instinctools. All rights reserved.
//

#import "FeedDetailsModuleRouterInput.h"

@protocol RamblerViperModuleTransitionHandlerProtocol;

@interface FeedDetailsModuleRouter : NSObject <FeedDetailsModuleRouterInput>

@property (nonatomic, weak) id<RamblerViperModuleTransitionHandlerProtocol> transitionHandler;

@end
