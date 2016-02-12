//
//  RootModuleViewInput.h
//  Example
//
//  Created by Alex Rudyak on 12/02/2016.
//  Copyright © 2016 instinctools. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RootModuleViewInput <NSObject>

/**
 @author Alex Rudyak

 Метод настраивает начальный стейт view
 */
- (void)setupInitialState;

@end
