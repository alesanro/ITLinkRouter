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

    ITLinkAction *const link = [[ITLinkAction alloc] initWithModuleName:ITModuleNameFromClass([self class]) link:_cmd arguments:@[ destination ]];
    link.router = self;
    [self.moduleNavigator pushLink:link withResultValue:[ITLinkNode linkValueWithModuleName:ITModuleNameFromClass([_ITLoginModuleRouter class]) router:[_ITLoginModuleRouter new]]];
}

@end

@implementation _ITLoginModuleRouter

- (void)navigateToSignInWithUser:(NSString *)username password:(NSString *)password
{
    ITLinkAction *const link = [[ITLinkAction alloc] initWithModuleName:ITModuleNameFromClass([self class]) link:_cmd arguments:@[ username, password ]];
    [self.moduleNavigator pushLink:link withResultValue:nil];
}

- (void)navigateToSignUp
{
    ITLinkAction *const link = [[ITLinkAction alloc] initWithModuleName:ITModuleNameFromClass([self class]) link:_cmd arguments:nil];
    link.router = self;
    [self.moduleNavigator pushLink:link withResultValue:nil];
}

@end

@implementation _ITFeedModuleRouter

- (void)openProfile
{
    ITLinkAction *const link = [[ITLinkAction alloc] initWithModuleName:ITModuleNameFromClass([self class]) link:_cmd arguments:nil];
    link.router = self;
    [self.moduleNavigator pushLink:link withResultValue:nil];
}

@end

@implementation _ITProfileModuleRouter

- (void)editNumber:(NSString *)telephoneNumber
{
    ITLinkAction *const link = [[ITLinkAction alloc] initWithModuleName:ITModuleNameFromClass([self class]) link:_cmd arguments:@[ telephoneNumber ]];
    link.router = self;
    [self.moduleNavigator pushLink:link withResultValue:nil];
}

@end
