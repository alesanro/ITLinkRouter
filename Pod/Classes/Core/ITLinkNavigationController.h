//
//  ITLinkNavigationController.h
//  Pods
//
//  Created by Alex Rudyak on 2/1/16.
//
//

#import <Foundation/Foundation.h>
#import "ITLinkNodeProtocol.h"

OBJC_EXPORT NSString *const ITNavigationProblemTypeKey;
OBJC_EXPORT NSString *const ITNavigationProblemDescriptionKey;

@class ITLinkChain;
@class ITNavigationProblemResolver;

typedef NSDictionary<NSString *, id> ITProblemDictionary;
typedef void (^ITProblemHanderBlock)(ITProblemDictionary *problemDict, ITNavigationProblemResolver *resolver);

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
 *  Method is helpful when during navigation you faced with a problem
 *  (i.e. user hasn't logged in or no permissions are granted to navigate
 *  to a destination view). Method triggers invocation of problem handler
 *  passed when navigation was initiated.
 *
 *  @param description dictionary to describe encountered problem
 */
- (void)reportProblem:(ITProblemDictionary *)description;

/**
 *  Perform solving of encountered problem with resolver object. Rather then
 *  create your own resolver object use one from handle block of navigation method
 *  to specify needed actions and call `resolve` method.
 *
 *  @param resolver object that holds solution for some problem
 */
- (void)solveProblemWithResolver:(ITNavigationProblemResolver *)resolver;

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

/**
 *  Perform navigation through new navigation chain. To actually navigate that chain
 *  should contain instersection at the beginning of it.
 *
 *  You can also handle all problems encountered during navigation by providing
 *  block which will allow you to make appropriated decision and resolve problems
 *
 *  @param updatedChain chain to navigate
 *  @param handlerBlock problem handler block; reused during single navigation cycle
 */
- (void)navigateToNewChain:(ITLinkChain *)updatedChain andHandleAnyProblem:(ITProblemHanderBlock)handlerBlock;

@end
