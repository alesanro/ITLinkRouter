//
//  ITUnwindableTransition.h
//  Pods
//
//  Created by Alex Rudyak on 2/2/16.
//
//

#import <Foundation/Foundation.h>
#import "ITAnimatableTransition.h"

@protocol ITUnwindableTransition <ITAnimatableTransition>

- (void)unwind;

@end
