//
//  UserProfileModuleRouter.h
//  Example
//
//  Created by Alex Rudyak on 17/02/2016.
//  Copyright © 2016 instinctools. All rights reserved.
//

#import "UserProfileModuleRouterInput.h"

@protocol RamblerViperModuleTransitionHandlerProtocol;

@interface UserProfileModuleRouter : NSObject <UserProfileModuleRouterInput>

@property (nonatomic, weak) id<RamblerViperModuleTransitionHandlerProtocol> transitionHandler;

@end
