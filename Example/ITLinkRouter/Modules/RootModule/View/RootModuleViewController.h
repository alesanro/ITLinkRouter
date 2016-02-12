//
//  RootModuleViewController.h
//  Example
//
//  Created by Alex Rudyak on 12/02/2016.
//  Copyright © 2016 instinctools. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RootModuleViewInput.h"

@protocol RootModuleViewOutput;

@interface RootModuleViewController : UIViewController <RootModuleViewInput>

@property (nonatomic, strong) id<RootModuleViewOutput> output;

@end
