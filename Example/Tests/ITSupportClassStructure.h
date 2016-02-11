//
//  ITSupportClassStructure.h
//  ITLinkRouter
//
//  Created by Alex Rudyak on 2/2/16.
//  Copyright © 2016 Alex Rudyak. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol _ModuleNameBuilderable <NSObject, NSCopying>

- (void)resetEnumeration;

- (NSString *)getNextName;

@end

@class _TestModuleRouter;

typedef void (^_TestModuleInitializationBlock)(_TestModuleRouter *moduleRouter);

@interface _TestModuleRouter : NSObject <ITUnwindableTransition>

@property (nonatomic, getter=isAnimatable) BOOL animatable;
@property (strong, nonatomic) ITLinkNavigationController *moduleNavigator;

@property (copy, nonatomic, readonly) NSString *moduleName;

/**
 *  Modules A, B and C must be initialized inside initialization block; otherwise on assignment it will throw an exception
 */

@property (strong, nonatomic) _TestModuleRouter *moduleA;
@property (strong, nonatomic) _TestModuleRouter *moduleB;
@property (strong, nonatomic) _TestModuleRouter *moduleC;

- (instancetype)initWithBuildable:(id<_ModuleNameBuilderable>)buidable completion:(_TestModuleInitializationBlock)completion;

- (instancetype)init NS_UNAVAILABLE;

+ (instancetype) new NS_UNAVAILABLE;

- (void)navigateToA:(NSString *)param1;

- (void)navigateToB:(NSString *)param1;

- (void)navigateToC:(NSString *)param1;

- (void)navigateToA;

- (void)navigateToB;

- (void)navigateToC;

@end

@interface _TestModuleRouter (_FindChilds)

- (_TestModuleRouter *)childRouterWithModuleName:(NSString *)moduleName;

@end

@interface _TestArrayModuleNameBuilder : NSObject <_ModuleNameBuilderable>

@property (copy, nonatomic, readonly) NSArray<NSString *> *names;

- (instancetype)initWithNames:(NSArray<NSString *> *)moduleNames;

+ (instancetype)builderWithNames:(NSArray<NSString *> *)moduleNames;

@end
