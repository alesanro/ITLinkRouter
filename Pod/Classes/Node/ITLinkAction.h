//
//  ITLinkAction.h
//  Pods
//
//  Created by Alex Rudyak on 1/29/16.
//
//

#import "ITLinkNode.h"

@interface ITLinkAction : ITLinkNode

/**
 *  Selector for the next transition
 */
@property (nonatomic, readonly) SEL linkSelector;

/**
 *  List of arguments for a transition
 */
@property (nonatomic, readonly) NSArray *arguments;

/**
 *  Initialize entity with
 *
 *  @param moduleName   name of module
 *  @param linkSelector selector for route
 *  @param arguments    list of arguments
 *
 *  @return instance of ITLinkAction class
 */
- (instancetype)initWithModuleName:(NSString *)moduleName link:(SEL)linkSelector arguments:(NSArray *)arguments;

- (instancetype)initWithModuleName:(NSString *)moduleName link:(SEL)linkSelector arguments:(NSArray *)arguments router:(ROUTER_TYPE)router;

- (instancetype)init NS_UNAVAILABLE;

+ (instancetype) new NS_UNAVAILABLE;

#pragma mark - Override

- (BOOL)isEqual:(id)object;

- (NSUInteger)hash;

- (NSString *)debugDescription;

@end
