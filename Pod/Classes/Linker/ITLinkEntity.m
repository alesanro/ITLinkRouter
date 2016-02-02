//
//  ITLinkEntity.m
//  Pods
//
//  Created by Alex Rudyak on 1/29/16.
//
//

#import "ITLinkEntity.h"

NSString *ITModuleNameFromClass(Class className)
{
    NSString *const classString = NSStringFromClass(className);
    const NSRange moduleNameRange = [classString rangeOfString:@"module" options:NSCaseInsensitiveSearch];
    if (moduleNameRange.location != NSNotFound) {
        const NSInteger fullnameLength = moduleNameRange.location + moduleNameRange.length;
        return [classString substringWithRange:NSMakeRange(0, fullnameLength)];
    }
    return classString;
}


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

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    ITLinkEntity *const copyInstance = [[ITLinkEntity alloc] initWithModule:_moduleName link:_linkSelector arguments:[[NSArray alloc] initWithArray:_arguments copyItems:YES]];
    copyInstance.router = self.router;
    return copyInstance;
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
