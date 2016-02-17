//
//  FeedListModuleViewController.h
//  Example
//
//  Created by Alex Rudyak on 17/02/2016.
//  Copyright © 2016 instinctools. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FeedListModuleViewInput.h"

@protocol FeedListModuleViewOutput;

@interface FeedListModuleViewController : UIViewController <FeedListModuleViewInput>

@property (nonatomic, strong) id<FeedListModuleViewOutput> output;

@end
