//
//  ITLinkNodeAbstract.m
//  Pods
//
//  Created by Alex Rudyak on 2/2/16.
//
//

#import "ITLinkNode.h"
#import "ITExceptions.h"
#import "ITLinkNode-Private.h"

static NSString *const kITImplementMethodInChildsMessage = @"Childs should implement this method by itself";

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

@implementation ITLinkNode
@synthesize moduleName = _moduleName;
@synthesize router = _router;

- (instancetype)initWithModuleName:(NSString *)moduleName router:(NSObject<ITAnimatableTransition, ITUnwindableTransition> *)router
{
    NSParameterAssert(moduleName.length);

    self = [super init];
    if (self) {
        _moduleName = [moduleName copy];
        _router = router;
    }
    return self;
}

- (BOOL)isSimilar:(id<ITLinkNode>)object
{
    if ([self isEqual:object]) {
        return YES;
    }

    if (![object isKindOfClass:[ITLinkNode class]]) {
        return NO;
    }

    if ([self.moduleName isEqual:object.moduleName]) {
        return YES;
    }

    return NO;
}

- (id<ITLinkNode>)flatten
{
    @throw [NSException exceptionWithName:ITUnimplementedMethod reason:kITImplementMethodInChildsMessage userInfo:nil];
}

- (NSInvocation *)forwardModuleInvocation
{
    @throw [NSException exceptionWithName:ITUnimplementedMethod reason:kITImplementMethodInChildsMessage userInfo:nil];
}

- (NSInvocation *)backwardModuleInvocation
{
    @throw [NSException exceptionWithName:ITUnimplementedMethod reason:kITImplementMethodInChildsMessage userInfo:nil];
}

#pragma mark - Override

- (BOOL)isEqual:(id<ITLinkNode>)otherObj
{
    if (![otherObj isKindOfClass:[ITLinkNode class]]) {
        return NO;
    }

    if (self == otherObj) {
        return YES;
    }

    if (![self.moduleName isEqualToString:otherObj.moduleName]) {
        return NO;
    }

    return YES;
}

- (NSUInteger)hash
{
    return [self.moduleName hash];
}

- (NSString *)debugDescription
{
    return [NSString stringWithFormat:@"[%@ with module: %@, router: %@", NSStringFromClass([self class]), self.moduleName, self.router];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    @throw [NSException exceptionWithName:ITUnimplementedMethod reason:kITImplementMethodInChildsMessage userInfo:nil];
}

@end
