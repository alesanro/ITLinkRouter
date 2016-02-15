//
//  ITNavigationProblemResolver.h
//  Pods
//
//  Created by Alex Rudyak on 2/12/16.
//
//

#import <Foundation/Foundation.h>

@class ITLinkNavigationController;
@class ITLinkChain;

@interface ITNavigationProblemResolver : NSObject <NSCopying>

@property (nonatomic, readonly, getter=isResolved) BOOL resolved;

@property (nonatomic, readonly, getter=isDone) BOOL done;

/**
 *  Attached navigation controller.
 */
@property (weak, nonatomic, readonly) ITLinkNavigationController *navigationController;

/**
 *  Current navigation chain. The equal one that navigation controller has.
 */
@property (nonatomic, readonly) ITLinkChain *currentChain;

/**
 *  Current navigation destination chain.
 */
@property (nonatomic, readonly) ITLinkChain *destinationChain;

/**
 *  Chain that will be used after resolving
 */
@property (nonatomic, readonly) ITLinkChain *resolvingChain;

/**
 *  Initialize resolver object
 *
 *  @param navigationController active link navigation controller
 *  @param destinationChain     chain that will be used for continuing navigation
 *
 *  @return instance of ITNavigationProblemResolver class
 */
- (instancetype)initWithNavigationController:(ITLinkNavigationController *)navigationController destinationChain:(ITLinkChain *)destinationChain;

#pragma mark - Public

/**
 *  Mark resolver to continue navigation process by handling original destination chain;
 */
- (void)continueNavigation;

/**
 *  Mark resolver to use the new chain to process navigation
 *
 *  @param otherChain new destination chain
 */
- (void)navigateToOtherChain:(ITLinkChain *)otherChain;

#pragma mark - State manipulation

/**
 *  Finalize resolving process. Should be called at the end of all resolving processes
 */
- (void)resolve;

/**
 *  Mark resolver as done after it was used for resolving any problem.
 *  Must be called only once per object lifecycle
 */
- (void)markDone;

@end
