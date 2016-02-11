//
//  ITLinkNode+ITClusterFactory.m
//  Pods
//
//  Created by Alex Rudyak on 2/11/16.
//
//

#import "ITLinkNode.h"
#import "ITLinkValue.h"
#import "ITLinkAction.h"

@implementation ITLinkNode (ITCluster)

+ (instancetype)linkValueWithModuleName:(NSString *)moduleName
{
    return [[ITLinkValue alloc] initWithModuleName:moduleName];
}

+ (instancetype)linkValueWithModuleName:(NSString *)moduleName router:(NSObject<ITAnimatableTransition, ITUnwindableTransition> *)router
{
    return [[ITLinkValue alloc] initWithModuleName:moduleName router:router];
}

+ (instancetype)linkActionWithModuleName:(NSString *)moduleName link:(SEL)linkSelector arguments:(NSArray *)arguments
{
    return [[ITLinkAction alloc] initWithModuleName:moduleName link:linkSelector arguments:arguments];
}

+ (instancetype)linkActionWithModuleName:(NSString *)moduleName link:(SEL)linkSelector arguments:(NSArray *)arguments router:(NSObject<ITAnimatableTransition, ITUnwindableTransition> *)router
{
    return [[ITLinkAction alloc] initWithModuleName:moduleName link:linkSelector arguments:arguments router:router];
}

+ (instancetype)linkActionWithNode:(ITLinkNode *)node link:(SEL)linkSelector arguments:(NSArray *)arguments
{
    return [[ITLinkAction alloc] initWithModuleName:node.moduleName link:linkSelector arguments:arguments router:node.router];
}

@end
