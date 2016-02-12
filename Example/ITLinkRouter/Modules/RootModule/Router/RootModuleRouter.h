//
//  RootModuleRouter.h
//  Example
//
//  Created by Alex Rudyak on 12/02/2016.
//  Copyright © 2016 instinctools. All rights reserved.
//

#import "RootModuleRouterInput.h"

@protocol RamblerViperModuleTransitionHandlerProtocol;

@interface RootModuleRouter : NSObject <RootModuleRouterInput>

@property (nonatomic, weak) id<RamblerViperModuleTransitionHandlerProtocol> transitionHandler;

@end
