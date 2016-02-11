//
//  ITLinkNodeAbstract.m
//  Pods
//
//  Created by Alex Rudyak on 2/2/16.
//
//

#import "ITLinkNode.h"
#import "ITLinkNode-Private.h"
#import "ITLinkValue.h"
#import "ITLinkAction.h"

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

- (instancetype)initWithModuleName:(NSString *)moduleName router:(NSObject<ITAnimatableTransition, ITUnwindableTransition> *)router
{
    self = [super init];
    if (self) {
        _moduleName = [moduleName copy];
        _router = router;
    }
    return self;
}

- (BOOL)isSimilar:(ITLinkNode *)object
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

- (ITLinkNode *)flatten
{
    @throw [NSException exceptionWithName:@"ITUnimplementedMethod" reason:@"Childs should implement this method by itself" userInfo:nil];
}

- (NSInvocation *)forwardModuleInvocation
{
    @throw [NSException exceptionWithName:@"ITUnimplementedMethod" reason:@"Childs should implement this method by itself" userInfo:nil];
}

- (NSInvocation *)backwardModuleInvocation
{
    @throw [NSException exceptionWithName:@"ITUnimplementedMethod" reason:@"Childs should implement this method by itself" userInfo:nil];
}

#pragma mark - Override

- (BOOL)isEqual:(id)object
{
    if (![object isKindOfClass:[ITLinkNode class]]) {
        return NO;
    }

    if (self == object) {
        return YES;
    }

    ITLinkNode *otherObj = (ITLinkNode *)object;
    if (![self.moduleName isEqualToString:otherObj.moduleName]) {
        return NO;
    }

    return YES;
}

- (NSString *)debugDescription
{
    return [NSString stringWithFormat:@"[%@ with module: %@, router: %@", NSStringFromClass([self class]), self.moduleName, self.router];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    @throw [NSException exceptionWithName:@"ITUnimplementedMethod" reason:@"Childs should implement this method by itself" userInfo:nil];
}

@end

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

+ (BOOL)isValue:(ITLinkNode *)node
{
    return [node isMemberOfClass:[ITLinkValue class]];
}

+ (BOOL)isAction:(ITLinkNode *)node
{
    return [node isMemberOfClass:[ITLinkAction class]];
}

@end
