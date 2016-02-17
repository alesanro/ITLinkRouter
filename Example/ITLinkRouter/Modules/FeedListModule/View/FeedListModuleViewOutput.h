//
//  FeedListModuleViewOutput.h
//  Example
//
//  Created by Alex Rudyak on 17/02/2016.
//  Copyright © 2016 instinctools. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FeedListModuleViewOutput <NSObject>

/**
 @author Alex Rudyak

 Метод сообщает презентеру о том, что view готова к работе
 */
- (void)didTriggerViewReadyEvent;

@end
