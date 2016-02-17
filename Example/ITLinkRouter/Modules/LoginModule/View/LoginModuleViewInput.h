//
//  LoginModuleViewInput.h
//  Example
//
//  Created by Alex Rudyak on 17/02/2016.
//  Copyright © 2016 instinctools. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LoginModuleViewInput <NSObject>

/**
 @author Alex Rudyak

 Метод настраивает начальный стейт view
 */
- (void)setupInitialState;

@end
