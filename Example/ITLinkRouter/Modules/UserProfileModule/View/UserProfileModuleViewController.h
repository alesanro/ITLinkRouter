//
//  UserProfileModuleViewController.h
//  Example
//
//  Created by Alex Rudyak on 17/02/2016.
//  Copyright © 2016 instinctools. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UserProfileModuleViewInput.h"

@protocol UserProfileModuleViewOutput;

@interface UserProfileModuleViewController : UIViewController <UserProfileModuleViewInput>

@property (nonatomic, strong) id<UserProfileModuleViewOutput> output;

@end
