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

@property (copy, nonatomic, readonly) ITLinkChain *backChain;

@property (copy, nonatomic, readonly) ITLinkChain *forwardChain;

@property (weak, nonatomic) id<ITNavigationActorDelegate> delegate;

- (instancetype)initWithBackChain:(ITLinkChain *)backChain forwardChain:(ITLinkChain *)forwardChain;

#pragma mark -

- (void)start;

- (void)next:(ITLinkNavigationType)navigationType withCurrentNode:(id<ITLinkNode>)node;

@end
