//
//  MenuModuleRouter.h
//  Example
//
//  Created by Alex Rudyak on 17/02/2016.
//  Copyright © 2016 instinctools. All rights reserved.
//

#import "MenuModuleRouterInput.h"

@protocol RamblerViperModuleTransitionHandlerProtocol;

@interface MenuModuleRouter : NSObject <MenuModuleRouterInput>

@property (nonatomic, weak) id<RamblerViperModuleTransitionHandlerProtocol> transitionHandler;

@end
