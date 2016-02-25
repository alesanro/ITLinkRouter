//
//  ITLinkValue.m
//  Pods
//
//  Created by Alex Rudyak on 2/2/16.
//
//

#import "ITLinkValue.h"
#import "ITLinkNode-Private.h"

@implementation ITLinkValue

- (instancetype)initWithModuleName:(NSString *)moduleName
{
    return [self initWithModuleName:moduleName router:nil];
}

- (instancetype)initWithModuleName:(NSString *)moduleName router:(NSObject<ITAnimatableTransition, ITUnwindableTransition> *)router
{
    return [super initWithModuleName:moduleName router:router];
}

- (ITLinkNode *)flatten
{
    return [self copy];
}

- (NSInvocation *)forwardModuleInvocation
{
#ifdef DEBUG
    NSLog(@"[WARNING] Link's Value router (%@) doesn't support forward transition", self);
#endif
    return nil;
}

- (NSInvocation *)backwardModuleInvocation
{
    const SEL backLinkSelector = @selector(unwind);
    if (![self.router respondsToSelector:backLinkSelector]) {
        NSLog(@"[WARNING] Link's Value router (%@) doesn't support selector %@ and cannot perform backward transition", self, NSStringFromSelector(backLinkSelector));
        return nil;
    }

    NSMethodSignature *const signature = [self.router methodSignatureForSelector:backLinkSelector];
    NSInvocation *const invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setTarget:self.router];
    [invocation setSelector:backLinkSelector];
    [invocation retainArguments];
    return invocation;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    ITLinkValue *copyInstance = [[ITLinkValue alloc] initWithModuleName:self.moduleName router:self.router];
    return copyInstance;
}

#pragma mark - Override

- (BOOL)isEqual:(id)object
{
    if (![super isEqual:object]) {
        return NO;
    }

    if (![object isKindOfClass:[ITLinkValue class]]) {
        return NO;
    }

    return YES;
}

- (NSUInteger)hash
{
    return [super hash];
}

@end
