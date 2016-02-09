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
    return nil;
}

- (NSInvocation *)backwardModuleInvocation
{
    return nil;
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

@end
