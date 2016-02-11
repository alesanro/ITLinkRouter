//
//  ITLinkNavigationController.h
//  Pods
//
//  Created by Alex Rudyak on 2/1/16.
//
//

#import <Foundation/Foundation.h>

@protocol ITLinkNode;
@class ITLinkChain;

/**
 *  This navigator controller responsible for managing navigation between
 *  modules withing VIPER application architecture pattern. It used to keep track
 *  currently loaded modules, their hierarchy and transitions. It also very
 *  helpful for experiencing Deep Linking approach and allows to embed it
 *  easily. Use ITLinkChain to transform external URLs to internal 
 *  application-based navigation and perform `navigateToNewChain:` method 
 *  to go right to the destination screen.
 */
@interface ITLinkNavigationController : NSObject

/**
 *  First (root) module link
 */
@property (nonatomic, readonly) id<ITLinkNode> rootEntity;

/**
 *  The latest link that was performed for transition. It always should be 
 *  of ITLinkActionTypeValue type.
 */
@property (nonatomic, readonly) id<ITLinkNode> activeEntity;

/**
 *  Navigation chain which describes current stack of module navigations.
 *  Returns copy of a chain, so it can be freely modified.
 */
@property (nonatomic, readonly) ITLinkChain *navigationChain;

/**
 *  Initialize instance with root entity (if not a link value then it will be 
 *  flattened)
 *
 *  @param entity root entity
 *
 *  @return instance of ITLinkNavigationController class
 */
- (instancetype)initWithRootEntity:(id<ITLinkNode>)entity;

/**
 *  Initialize instance with predefined chain. The last link will be
 *  aligned to its flatten version.
 *
 *  @param chain navigation chain
 *
 *  @return instance of ITLinkNavigationController class
 */
- (instancetype)initWithChain:(ITLinkChain *)chain NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype) new NS_UNAVAILABLE;

#pragma mark - Public

/**
 *  Append link to the navigation chain.
 *  Doesn't perform any action for link or navigation stack
 *
 *  @param link link which was execuded right away
 */
- (void)pushLink:(id<ITLinkNode>)link withResultValue:(id<ITLinkNode>)valueEntity;

/**
 *  Remove active link from the navigation chain.
 *  Doesn't perform any action for link or navigation stack
 */
- (void)popLink;

/**
 *  Perform navigation through new navigation chain. To actually navigate that chain
 *  should contain instersection at the beginning of it
 *
 *  @param updatedChain chain to navigate
 */
- (void)navigateToNewChain:(ITLinkChain *)updatedChain;

@end
