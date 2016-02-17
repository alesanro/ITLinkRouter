//
//  FeedListModuleRouter.h
//  Example
//
//  Created by Alex Rudyak on 17/02/2016.
//  Copyright © 2016 instinctools. All rights reserved.
//

#import "FeedListModuleRouterInput.h"

@protocol RamblerViperModuleTransitionHandlerProtocol;

@interface FeedListModuleRouter : NSObject <FeedListModuleRouterInput>

@property (nonatomic, weak) id<RamblerViperModuleTransitionHandlerProtocol> transitionHandler;

@end
