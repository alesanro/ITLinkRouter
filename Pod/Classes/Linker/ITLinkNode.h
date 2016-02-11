//
//  ITLinkNodeAbstract.h
//  Pods
//
//  Created by Alex Rudyak on 2/2/16.
//
//

#import <Foundation/Foundation.h>
#import "ITLinkNodeProtocol.h"

/**
 *  Basic class which implements protocol ITLinkNode.
 */
@interface ITLinkNode : NSObject <ITLinkNode>

- (instancetype)init NS_UNAVAILABLE;

+ (instancetype) new NS_UNAVAILABLE;

#pragma mark - Override

- (BOOL)isEqual:(id)object;

- (NSString *)debugDescription;

@end

/**
 *  Link node factory category
 */
@interface ITLinkNode (ITClusterFactory)

+ (instancetype)linkActionWithNode:(id<ITLinkNode>)node link:(SEL)linkSelector arguments:(NSArray *)arguments;

+ (instancetype)linkActionWithModuleName:(NSString *)moduleName link:(SEL)linkSelector arguments:(NSArray *)arguments;

+ (instancetype)linkActionWithModuleName:(NSString *)moduleName link:(SEL)linkSelector arguments:(NSArray *)arguments router:(ROUTER_TYPE)router;

+ (instancetype)linkValueWithModuleName:(NSString *)moduleName;

+ (instancetype)linkValueWithModuleName:(NSString *)moduleName router:(ROUTER_TYPE)router;

/**
 *  Check if node is action type
 *
 *  @param node instance of node
 *
 *  @return YES if instance is Action; NO otherwise
 */
+ (BOOL)isAction:(id<ITLinkNode>)node;

/**
 *  Check if node is value type
 *
 *  @param node instance of node
 *
 *  @return YES if istance if Value; NO otherwise
 */
+ (BOOL)isValue:(id<ITLinkNode>)node;

@end
