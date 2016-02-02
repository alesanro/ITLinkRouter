//
//  ITModuleNavigatorController.h
//  Pods
//
//  Created by Alex Rudyak on 2/1/16.
//
//

#import <Foundation/Foundation.h>

@class ITLinkEntity;
@class ITLinkChain;

/**
 *  @author Alex Rudyak <alesanro\@instinctools.ru>
 *
 *  This navigator controller responsible for managing navigation between
 *  modules withing VIPER application architecture. It used to keep track
 *  currently loaded modules, their hierarchy and transitions. It also very
 *  helpful for experiencing Deep Linking approach and allows to embed it
 *  easily. Use ITLinkChain to transform external URLs to internal 
 *  application-based navigation and perform `navigateToNewChain:` method 
 *  to go right to the destination screen.
 */
@interface ITModuleNavigatorController : NSObject

/**
 *  First (root) module link
 */
@property (nonatomic, readonly) ITLinkEntity *rootEntity;

/**
 *  The latest link that was performed for transition
 */
@property (nonatomic, readonly) ITLinkEntity *activeEntity;

/**
 *  Navigation chain which describes current stack of module navigations.
 *  Returns copy of a chain, so it can be freely modified
 */
@property (nonatomic, readonly) ITLinkChain *navigationChain;

/**
 *  Initialize instance with root entity. Creates new navigation chain
 *
 *  @param entity root entity
 *
 *  @return instance of ITModuleNavigatorController class
 */
- (instancetype)initWithRootEntity:(ITLinkEntity *)entity;

/**
 *  Initialize instance with predefined chain.
 *
 *  @param chain navigation chain
 *
 *  @return instance of ITModuleNavigatorController class
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
- (void)pushLink:(ITLinkEntity *)link;

/**
 *  Remove active link from the navigation chain.
 *  Doesn't perform any action for link or navigation stack
 */
- (void)popLink;

- (void)navigateToNewChain:(ITLinkChain *)updatedChain;

@end
