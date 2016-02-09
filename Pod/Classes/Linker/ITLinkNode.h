//
//  ITLinkNodeAbstract.h
//  Pods
//
//  Created by Alex Rudyak on 2/2/16.
//
//

#import <Foundation/Foundation.h>
#import "ITAnimatableTransition.h"
#import "ITUnwindableTransition.h"

OBJC_EXPORT NSString *ITModuleNameFromClass(Class className);

#define ROUTER_TYPE NSObject<ITAnimatableTransition, ITUnwindableTransition> *

@interface ITLinkNode : NSObject <NSCopying>

/**
 *  Name of module
 */
@property (copy, nonatomic, readonly) NSString *moduleName;

/**
 *  Object which is used to perform transition
 */
@property (strong, nonatomic) ROUTER_TYPE router;

- (instancetype)init NS_UNAVAILABLE;

+ (instancetype) new NS_UNAVAILABLE;

/**
 *  Define if NOT equal objects has the same module name
 *
 *  @param object other node object
 *
 *  @return YES if both objects have equal moduleName, otherwise NO
 */
- (BOOL)isSimilar:(ITLinkNode *)object;

/**
 *  Flattening node by returning the most simple instance of
 *  ITLinkNode hierarchy. 
 *
 *  Should be overrided in children classes
 *
 *  @return instance of the simple link node
 */
- (ITLinkNode *)flatten;

/**
 *  Return invocation object for router to perform forward transition
 *
 *  Should be overrided in children classes
 *
 *  @return instance of NSInvocation class
 */
- (NSInvocation *)forwardModuleInvocation;

/**
 *  Return invocation object for router to perform back transition
 *
 *  Should be overrided in children classes
 *
 *  @return instance of NSInvocation class
 */
- (NSInvocation *)backwardModuleInvocation;

#pragma mark - Override

- (BOOL)isEqual:(id)object;

- (NSString *)debugDescription;

@end

@interface ITLinkNode (ITCluster)

+ (instancetype)linkActionWithModuleName:(NSString *)moduleName link:(SEL)linkSelector arguments:(NSArray *)arguments;

+ (instancetype)linkActionWithModuleName:(NSString *)moduleName link:(SEL)linkSelector arguments:(NSArray *)arguments router:(ROUTER_TYPE)router;

+ (instancetype)linkValueWithModuleName:(NSString *)moduleName;

+ (instancetype)linkValueWithModuleName:(NSString *)moduleName router:(ROUTER_TYPE)router;

+ (instancetype)linkActionWithNode:(ITLinkNode *)node link:(SEL)linkSelector arguments:(NSArray *)arguments;

@end
