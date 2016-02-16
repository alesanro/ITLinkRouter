//
//  ITNavigationActor.h
//  Pods
//
//  Created by Alex Rudyak on 2/16/16.
//
//

#import <Foundation/Foundation.h>
#import "ITLinkNodeProtocol.h"

@class ITLinkChain;
@class ITNavigationActor;

typedef NS_ENUM(NSUInteger, ITLinkNavigationType) {
    ITLinkNavigationTypeForward,
    ITLinkNavigationTypeBack
};

@protocol ITNavigationActorDelegate <NSObject>

- (void)didStartNavigation:(ITNavigationActor *)navigationActor;
- (void)didFinishNavigation:(ITNavigationActor *)navigationActor;

@end

@interface ITNavigationActor : NSObject

/**
 *  Chain for backward navigation
 */
@property (copy, nonatomic, readonly) ITLinkChain *backChain;

/**
 *  Chain for forward navigation
 */
@property (copy, nonatomic, readonly) ITLinkChain *forwardChain;

/**
 *  Indicate if actor are able to perform navigation
 */
@property (nonatomic, readonly, getter=isValid) BOOL valid;

/**
 *  Indicate if actor done with navigation
 */
@property (nonatomic, readonly, getter=isFinished) BOOL finished;

/**
 *  Indicate if actor in a process of navigation
 */
@property (nonatomic, readonly, getter=isStarted) BOOL started;

/**
 *  Delegate object that will be notified about start and finish of navigation
 */
@property (weak, nonatomic) id<ITNavigationActorDelegate> delegate;

/**
 *  Initialization method for navigation actor
 *
 *  @param backChain    back chain
 *  @param forwardChain forward chain
 *
 *  @return instance of ITNavigationActor class
 */
- (instancetype)initWithSourceChain:(ITLinkChain *)sourceChain destinationChain:(ITLinkChain *)destinationChain;

#pragma mark -

/**
 *  Begin navigation. Should always be invoked before any other
 *  proceedings (i.e next:withCurrentNode and etc.)
 */
- (void)start;

/**
 *  Continues navigation by specifying performed current navigation direction and current node
 *
 *  @param navigationType type of performed navigation on the previous step
 *  @param node           result node from the previous navigation
 */
- (void)next:(ITLinkNavigationType)navigationType withCurrentNode:(id<ITLinkNode>)node;

@end
