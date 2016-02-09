//
//  ITLinkAction.m
//  Pods
//
//  Created by Alex Rudyak on 1/29/16.
//
//

#import "ITLinkAction.h"
#import "ITLinkNode-Private.h"

static NSUInteger ITSelectorNumberOfArguments(SEL selector)
{
    NSUInteger numberOfArgumentsInSelector = 0;
    if (selector) {
        NSString *const analyzedString = NSStringFromSelector(selector);
        NSRegularExpression *const expression = [NSRegularExpression regularExpressionWithPattern:@":" options:NSRegularExpressionCaseInsensitive error:nil];
        numberOfArgumentsInSelector = [expression numberOfMatchesInString:analyzedString options:NSMatchingReportProgress range:NSMakeRange(0, analyzedString.length)];
    }
    return numberOfArgumentsInSelector;
}

@implementation ITLinkAction

- (instancetype)initWithModuleName:(NSString *)moduleName link:(SEL)linkSelector arguments:(NSArray *)arguments
{
    return [self initWithModuleName:moduleName link:linkSelector arguments:arguments router:nil];
}

- (instancetype)initWithModuleName:(NSString *)moduleName link:(SEL)linkSelector arguments:(NSArray *)arguments router:(NSObject<ITAnimatableTransition, ITUnwindableTransition> *)router
{
    self = [super initWithModuleName:moduleName router:router];
    if (self) {
        NSAssert(ITSelectorNumberOfArguments(linkSelector) == arguments.count, @"Selector's number of arguments should be equal to passed number of arguments");

        _linkSelector = linkSelector;
        _arguments = [arguments copy];
    }
    return self;
}

- (ITLinkNode *)flatten
{
    return [ITLinkNode linkValueWithModuleName:self.moduleName router:self.router];
}

- (NSInvocation *)forwardModuleInvocation
{
    if (![self.router respondsToSelector:self.linkSelector]) {
        NSLog(@"[WARNING] Link's Action router (%@) doesn't support selector %@ and cannot perform forward transition", self, NSStringFromSelector(self.linkSelector));
        return nil;
    }

    NSMethodSignature *const signature = [self.router methodSignatureForSelector:self.linkSelector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setTarget:self.router];
    [invocation setSelector:self.linkSelector];
    [self.arguments enumerateObjectsUsingBlock:^(id arg, NSUInteger idx, BOOL *stop) {
        // !!!: +2 because of the first argument is reserved for a target, the second is for a selector.
        [invocation setArgument:(__bridge void *)(arg) atIndex:idx + 2];
    }];
    return invocation;
}

- (NSInvocation *)backwardModuleInvocation
{
    const SEL backLinkSelector = @selector(unwind);
    if (![self.router respondsToSelector:backLinkSelector]) {
        NSLog(@"[WARNING] Link's Action router (%@) doesn't support selector %@ and cannot perform backward transition", self, NSStringFromSelector(backLinkSelector));
        return nil;
    }

    NSMethodSignature *const signature = [self.router methodSignatureForSelector:backLinkSelector];
    NSInvocation *const invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setTarget:self.router];
    [invocation setSelector:backLinkSelector];
    return invocation;
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
