//
//  FeedDetailsModuleViewController.h
//  Example
//
//  Created by Alex Rudyak on 17/02/2016.
//  Copyright © 2016 instinctools. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FeedDetailsModuleViewInput.h"

@protocol FeedDetailsModuleViewOutput;

@interface FeedDetailsModuleViewController : UIViewController <FeedDetailsModuleViewInput>

@property (nonatomic, strong) id<FeedDetailsModuleViewOutput> output;

@end
