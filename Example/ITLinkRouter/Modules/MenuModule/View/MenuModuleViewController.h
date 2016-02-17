//
//  MenuModuleViewController.h
//  Example
//
//  Created by Alex Rudyak on 17/02/2016.
//  Copyright © 2016 instinctools. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MenuModuleViewInput.h"

@protocol MenuModuleViewOutput;

@interface MenuModuleViewController : UIViewController <MenuModuleViewInput>

@property (nonatomic, strong) id<MenuModuleViewOutput> output;

@end
