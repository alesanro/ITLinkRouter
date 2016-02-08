//
//  ITLinkAction.m
//  Pods
//
//  Created by Alex Rudyak on 1/29/16.
//
//

#import "ITLinkAction.h"
#import "ITLinkNode-Private.h"

@implementation ITLinkAction

- (instancetype)initWithModuleName:(NSString *)moduleName link:(SEL)linkSelector arguments:(NSArray *)arguments
{
    return [self initWithModuleName:moduleName link:linkSelector arguments:arguments router:nil];
}

- (instancetype)initWithModuleName:(NSString *)moduleName link:(SEL)linkSelector arguments:(NSArray *)arguments router:(NSObject<ITAnimatableTransition, ITUnwindableTransition> *)router
{
    self = [super initWithModuleName:moduleName router:router];
    if (self) {
        _linkSelector = linkSelector;
        _arguments = [arguments copy];
    }
    return self;
}

- (ITLinkNode *)flatten
{
    return [ITLinkNode linkValueWithModuleName:self.moduleName router:self.router];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    ITLinkAction *copyInstance = [[ITLinkAction alloc] initWithModuleName:self.moduleName link:_linkSelector arguments:[[NSArray alloc] initWithArray:_arguments copyItems:YES] router:self.router];
    return copyInstance;
}

#pragma mark - Override

- (BOOL)isEqual:(id)object
{
    if (![super isEqual:object]) {
        return NO;
    }

    if (![object isKindOfClass:[ITLinkAction class]]) {
        return NO;
    }

    ITLinkAction *otherObj = (ITLinkAction *)object;
    if (self.linkSelector != otherObj.linkSelector) {
        return NO;
    }
    if (self.arguments.count != otherObj.arguments.count) {
        return NO;
    }

    return YES;
}

- (NSString *)debugDescription
{
    return [NSString stringWithFormat:@"[%@ with module: %@; link: %@, args: {%@}, router: %@]", NSStringFromClass([self class]), self.moduleName, NSStringFromSelector(self.linkSelector), [self.arguments componentsJoinedByString:@"; "], self.router];
}

@end

@implementation ITLinkNode (ITPartialBuilder)

+ (instancetype)linkActionWithAction:(ITLinkAction *)actionLink arguments:(NSArray *)arguments
{
    return [ITLinkNode linkActionWithNode:actionLink link:actionLink.linkSelector arguments:arguments];
}

@end
