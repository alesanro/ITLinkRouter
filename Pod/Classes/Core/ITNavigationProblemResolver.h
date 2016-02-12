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

@property (weak, nonatomic, readonly) ITLinkNavigationController *navigationController;

@property (nonatomic, readonly) ITLinkChain *currentChain;

@property (nonatomic, readonly) ITLinkChain *destinationChain;

- (instancetype)initWithNavigationController:(ITLinkNavigationController *)navigationController
                            destinationChain:(ITLinkChain *)destinationChain;

#pragma mark - Public

/**
 *  Restore navigation process by handling original destination chain;
 */
- (void)continueNavigation;

- (void)navigateToOtherChain:(ITLinkChain *)otherChain;

- (void)resolve;

@end
