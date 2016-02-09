//
//  ITSupportClassStructure.m
//  ITLinkRouter
//
//  Created by Alex Rudyak on 2/2/16.
//  Copyright © 2016 Alex Rudyak. All rights reserved.
//

#import "ITSupportClassStructure.h"

@implementation _ITBasicRouter

- (void)unwind
{
}

@end

@implementation _ITRootModuleRouter

- (instancetype)init
{
    self = [super init];
    if (self) {
        // somehow need to add root module link after initialization
    }
    return self;
}

- (void)navigateToLogin:(NSString *)destination
{
    assert(self.moduleNavigator);

    ITLinkNode *const link = [ITLinkNode linkActionWithModuleName:ITModuleNameFromClass(self.class) link:_cmd arguments:@[ destination ] router:self];
    _ITLoginModuleRouter *const destinationRouter = [_ITLoginModuleRouter new];
    destinationRouter.moduleNavigator = self.moduleNavigator;
    [self.moduleNavigator pushLink:link withResultValue:[ITLinkNode linkValueWithModuleName:ITModuleNameFromClass(destinationRouter.class) router:destinationRouter]];
}

@end

@implementation _ITLoginModuleRouter

- (void)navigateToSignInWithUser:(NSString *)username password:(NSString *)password
{
    ITLinkNode *const link = [ITLinkNode linkActionWithModuleName:ITModuleNameFromClass(self.class) link:_cmd arguments:@[ username, password ]];
    _ITFeedModuleRouter *const destinationRouter = [_ITFeedModuleRouter new];
    destinationRouter.moduleNavigator = self.moduleNavigator;
    [self.moduleNavigator pushLink:link withResultValue:[ITLinkNode linkValueWithModuleName:ITModuleNameFromClass(destinationRouter.class) router:destinationRouter]];
}

- (void)navigateToSignUp
{
    ITLinkNode *const link = [ITLinkNode linkActionWithModuleName:ITModuleNameFromClass(self.class) link:_cmd arguments:nil router:self];
    _ITProfileModuleRouter *const destinationRouter = [_ITProfileModuleRouter new];
    destinationRouter.moduleNavigator = self.moduleNavigator;
    [self.moduleNavigator pushLink:link withResultValue:[ITLinkNode linkValueWithModuleName:ITModuleNameFromClass(destinationRouter.class) router:destinationRouter]];
}

@end

@implementation _ITFeedModuleRouter

- (void)openProfile
{
    ITLinkNode *const link = [ITLinkNode linkActionWithModuleName:ITModuleNameFromClass(self.class) link:_cmd arguments:nil router:self];
    _ITProfileModuleRouter *const destinationRouter = [_ITProfileModuleRouter new];
    destinationRouter.moduleNavigator = self.moduleNavigator;
    [self.moduleNavigator pushLink:link withResultValue:[ITLinkNode linkValueWithModuleName:ITModuleNameFromClass(destinationRouter.class) router:destinationRouter]];
}

@end

@implementation _ITProfileModuleRouter

- (void)editNumber:(NSString *)telephoneNumber
{
    ITLinkNode *const link = [ITLinkNode linkActionWithModuleName:ITModuleNameFromClass(self.class) link:_cmd arguments:@[ telephoneNumber ] router:self];
    NSObject *const destinationRouter = [NSObject new];
    [self.moduleNavigator pushLink:link withResultValue:[ITLinkNode linkValueWithModuleName:ITModuleNameFromClass(destinationRouter.class)]];
}

@end
