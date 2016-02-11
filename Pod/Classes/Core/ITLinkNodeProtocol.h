//
//  ITLinkNodeProtocol.h
//  Pods
//
//  Created by Alex Rudyak on 2/11/16.
//
//

#import <Foundation/Foundation.h>
#import "ITAnimatableTransition.h"
#import "ITUnwindableTransition.h"

OBJC_EXPORT NSString *ITModuleNameFromClass(Class className);

#define ROUTER_TYPE NSObject<ITAnimatableTransition, ITUnwindableTransition> *

@protocol ITLinkNode <NSObject, NSCopying>

/**
 *  Name of module
 */
@property (copy, nonatomic, readonly) NSString *moduleName;

/**
 *  Object which is used to perform transition
 */
@property (strong, nonatomic) ROUTER_TYPE router;

/**
 *  Define if NOT equal objects has the same module name
 *
 *  @param object other node object
 *
 *  @return YES if both objects have equal moduleName, NO otherwise
 */
- (BOOL)isSimilar:(id<ITLinkNode>)object;

/**
 *  Flattening node by returning the most simple instance of
 *  ITLinkNode hierarchy.
 *
 *  Should be overrided in children classes
 *
 *  @return instance of the simple link node
 */
- (id<ITLinkNode>)flatten;

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

@end
