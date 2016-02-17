//
//  LoginModuleRouter.h
//  Example
//
//  Created by Alex Rudyak on 17/02/2016.
//  Copyright © 2016 instinctools. All rights reserved.
//

#import "LoginModuleRouterInput.h"

@protocol RamblerViperModuleTransitionHandlerProtocol;

@interface LoginModuleRouter : NSObject <LoginModuleRouterInput>

@property (nonatomic, weak) id<RamblerViperModuleTransitionHandlerProtocol> transitionHandler;

@end
