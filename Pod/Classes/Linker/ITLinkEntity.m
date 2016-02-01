//
//  ITLinkEntity.m
//  Pods
//
//  Created by Alex Rudyak on 1/29/16.
//
//

#import "ITLinkEntity.h"


@implementation ITLinkEntity

- (instancetype)initWithModule:(NSString *)moduleName link:(SEL)linkSelector arguments:(NSArray *)arguments
{
    self = [super init];
    if (self) {
        _moduleName = [moduleName copy];
        _linkSelector = linkSelector;
        _arguments = [arguments copy];
    }
    return self;
}

#pragma mark - Override

- (BOOL)isEqual:(id)object
{
    if (![object isKindOfClass:[self class]]) {
        return NO;
    }

    if (self == object) {
        return YES;
    }

    ITLinkEntity *otherObj = (ITLinkEntity *)object;
    if (![self.moduleName isEqualToString:otherObj.moduleName]) {
        return NO;
    }
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
    return [NSString stringWithFormat:@"[Module: %@; link: %@, args: {%@}]", self.moduleName, NSStringFromSelector(self.linkSelector), [self.arguments componentsJoinedByString:@"; "]];
}

@end
