//
//  LoginModuleViewController.h
//  Example
//
//  Created by Alex Rudyak on 17/02/2016.
//  Copyright © 2016 instinctools. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LoginModuleViewInput.h"

@protocol LoginModuleViewOutput;

@interface LoginModuleViewController : UIViewController <LoginModuleViewInput>

@property (nonatomic, strong) id<LoginModuleViewOutput> output;

@end
