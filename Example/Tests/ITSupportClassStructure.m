//
//  ITSupportClassStructure.m
//  ITLinkRouter
//
//  Created by Alex Rudyak on 2/2/16.
//  Copyright © 2016 Alex Rudyak. All rights reserved.
//

#import "ITSupportClassStructure.h"

@implementation _TestModuleRouter {
    BOOL _allowToEditModule;
}
@synthesize moduleA = _moduleA;
@synthesize moduleB = _moduleB;
@synthesize moduleC = _moduleC;

- (instancetype)initWithBuildable:(id<_ModuleNameBuilderable>)buildable completion:(_TestModuleInitializationBlock)completion
{
    NSAssert(buildable, @"[_TestModuleRouter] Buildable should be non nil");
    self = [super init];
    if (self) {
        _moduleName = [buildable getNextName];
        if (completion) {
            _allowToEditModule = YES;
            completion(self);
            _allowToEditModule = NO;
        }
    }
    return self;
}

- (void)setModuleNavigator:(ITLinkNavigationController *)moduleNavigator
{
    _moduleNavigator = moduleNavigator;
    [self.moduleA setModuleNavigator:moduleNavigator];
    [self.moduleB setModuleNavigator:moduleNavigator];
    [self.moduleC setModuleNavigator:moduleNavigator];
}

- (void)setModuleA:(_TestModuleRouter *)moduleA
{
    if (_allowToEditModule) {
        _moduleA = moduleA;
    } else {
        @throw [NSException exceptionWithName:@"ITInvalidModuleAssignment" reason:@"ModuleA should be initialized inside initialization block" userInfo:nil];
    }
}

- (void)setModuleB:(_TestModuleRouter *)moduleB
{
    if (_allowToEditModule) {
        _moduleB = moduleB;
    } else {
        @throw [NSException exceptionWithName:@"ITInvalidModuleAssignment" reason:@"ModuleB should be initialized inside initialization block" userInfo:nil];
    }
}

- (void)setModuleC:(_TestModuleRouter *)moduleC
{
    if (_allowToEditModule) {
        _moduleC = moduleC;
    } else {
        @throw [NSException exceptionWithName:@"ITInvalidModuleAssignment" reason:@"ModuleC should be initialized inside initialization block" userInfo:nil];
    }
}

- (void)navigateToA:(NSString *)param1
{
    _TestModuleRouter *const module = self.moduleA;
    if (module) {
        ITLinkNode *const actionNode = [ITLinkNode linkActionWithModuleName:self.moduleName link:_cmd arguments:@[ param1 ] router:self];
        ITLinkNode *const nextNode = [ITLinkNode linkValueWithModuleName:module.moduleName router:module];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.moduleNavigator pushLink:actionNode withResultValue:nextNode];
        });
    } else {
        @throw [NSException exceptionWithName:@"ITInvalidmoduleNavigator" reason:@"Couldn't navigate to moduleA cause it is uninitialized" userInfo:nil];
    }
}

- (void)navigateToB:(NSString *)param1
{
    _TestModuleRouter *const module = self.moduleB;
    if (module) {
        ITLinkNode *const actionNode = [ITLinkNode linkActionWithModuleName:self.moduleName link:_cmd arguments:@[ param1 ] router:self];
        ITLinkNode *const nextNode = [ITLinkNode linkValueWithModuleName:module.moduleName router:module];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.moduleNavigator pushLink:actionNode withResultValue:nextNode];
        });
    } else {
        @throw [NSException exceptionWithName:@"ITInvalidmoduleNavigator" reason:@"Couldn't navigate to moduleB cause it is uninitialized" userInfo:nil];
    }
}

- (void)navigateToC:(NSString *)param1
{
    _TestModuleRouter *const module = self.moduleC;
    if (module) {
        ITLinkNode *const actionNode = [ITLinkNode linkActionWithModuleName:self.moduleName link:_cmd arguments:@[ param1 ] router:self];
        ITLinkNode *const nextNode = [ITLinkNode linkValueWithModuleName:module.moduleName router:module];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.moduleNavigator pushLink:actionNode withResultValue:nextNode];
        });
    } else {
        @throw [NSException exceptionWithName:@"ITInvalidmoduleNavigator" reason:@"Couldn't navigate to moduleC cause it is uninitialized" userInfo:nil];
    }
}

- (void)navigateToA
{
    _TestModuleRouter *const module = self.moduleA;
    if (module) {
        ITLinkNode *const actionNode = [ITLinkNode linkActionWithModuleName:self.moduleName link:_cmd arguments:nil router:self];
        ITLinkNode *const nextNode = [ITLinkNode linkValueWithModuleName:module.moduleName router:module];
        [self.moduleNavigator pushLink:actionNode withResultValue:nextNode];
    } else {
        @throw [NSException exceptionWithName:@"ITInvalidmoduleNavigator" reason:@"Couldn't navigate to moduleA cause it is uninitialized" userInfo:nil];
    }
}

- (void)navigateToB
{
    _TestModuleRouter *const module = self.moduleB;
    if (module) {
        ITLinkNode *const actionNode = [ITLinkNode linkActionWithModuleName:self.moduleName link:_cmd arguments:nil router:self];
        ITLinkNode *const nextNode = [ITLinkNode linkValueWithModuleName:module.moduleName router:module];
        [self.moduleNavigator pushLink:actionNode withResultValue:nextNode];
    } else {
        @throw [NSException exceptionWithName:@"ITInvalidmoduleNavigator" reason:@"Couldn't navigate to moduleB cause it is uninitialized" userInfo:nil];
    }
}

- (void)navigateToC
{
    _TestModuleRouter *const module = self.moduleC;
    if (module) {
        ITLinkNode *const actionNode = [ITLinkNode linkActionWithModuleName:self.moduleName link:_cmd arguments:nil router:self];
        ITLinkNode *const nextNode = [ITLinkNode linkValueWithModuleName:module.moduleName router:module];
        [self.moduleNavigator pushLink:actionNode withResultValue:nextNode];
    } else {
        @throw [NSException exceptionWithName:@"ITInvalidmoduleNavigator" reason:@"Couldn't navigate to moduleC cause it is uninitialized" userInfo:nil];
    }
}

- (void)unwind
{
    [self.moduleNavigator popLink];
}

@end

@implementation _TestModuleRouter (_FindChilds)

- (_TestModuleRouter *)childRouterWithModuleName:(NSString *)moduleName
{
    NSAssert(moduleName.length, @"Module name should not be empty");

    if ([self.moduleName isEqualToString:moduleName]) {
        return self;
    }

    NSMutableArray<_TestModuleRouter *> *childModules = [NSMutableArray array];
    if (self.moduleA) {
        [childModules addObject:self.moduleA];
    }
    if (self.moduleB) {
        [childModules addObject:self.moduleB];
    }
    if (self.moduleC) {
        [childModules addObject:self.moduleC];
    }

    __block _TestModuleRouter *foundRouter;
    [childModules enumerateObjectsUsingBlock:^(_TestModuleRouter *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        foundRouter = [obj childRouterWithModuleName:moduleName];
        if (foundRouter) {
            *stop = YES;
        }
    }];

    return foundRouter;
}

@end

@implementation _TestArrayModuleNameBuilder {
    NSUInteger _counter;
}

- (instancetype)initWithNames:(NSArray *)moduleNames
{
    NSAssert(moduleNames.count > 0, @"[TestModuleNameBuilder] Number of module names should be more than zero ('0')");

    self = [super init];
    if (self) {
        _names = [moduleNames copy];
    }
    return self;
}

+ (instancetype)builderWithNames:(NSArray *)moduleNames
{
    return [[self alloc] initWithNames:moduleNames];
}

- (void)resetEnumeration
{
    _counter = 0;
}

- (NSString *)getNextName
{
    if (_counter >= self.names.count) {
        @throw [NSException exceptionWithName:@"ITOutOfRangeModuleName" reason:@"No more module names left" userInfo:nil];
    }

    return self.names[_counter++];
}

- (id)copyWithZone:(NSZone *)zone
{
    _TestArrayModuleNameBuilder *copyInstance = [_TestArrayModuleNameBuilder builderWithNames:self.names];
    return copyInstance;
}

@end
