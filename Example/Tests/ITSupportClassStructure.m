//
//  ITSupportClassStructure.m
//  ITLinkRouter
//
//  Created by Alex Rudyak on 2/2/16.
//  Copyright © 2016 Alex Rudyak. All rights reserved.
//

#import "ITSupportClassStructure.h"


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

    ITLinkEntity *const link = [[ITLinkEntity alloc] initWithModule:ITModuleNameFromClass([self class]) link:_cmd arguments:@[ destination ]];
    link.router = self;
    [self.moduleNavigator pushLink:link];
}

- (void)unwind
{
}

@end


@implementation _ITLoginModuleRouter

- (void)navigateToSignInWithUser:(NSString *)username password:(NSString *)password
{
    ITLinkEntity *const link = [[ITLinkEntity alloc] initWithModule:ITModuleNameFromClass([self class]) link:_cmd arguments:@[ username, password ]];
    [self.moduleNavigator pushLink:link];
}

- (void)navigateToSignUp
{
    ITLinkEntity *const link = [[ITLinkEntity alloc] initWithModule:ITModuleNameFromClass([self class]) link:_cmd arguments:nil];
    link.router = self;
    [self.moduleNavigator pushLink:link];
}

- (void)unwind
{
}

@end


@implementation _ITFeedModuleRouter

- (void)openProfile
{
    ITLinkEntity *const link = [[ITLinkEntity alloc] initWithModule:ITModuleNameFromClass([self class]) link:_cmd arguments:nil];
    link.router = self;
    [self.moduleNavigator pushLink:link];
}

- (void)unwind
{
}

@end


@implementation _ITProfileModuleRouter

- (void)editNumber:(NSString *)telephoneNumber
{
    ITLinkEntity *const link = [[ITLinkEntity alloc] initWithModule:ITModuleNameFromClass([self class]) link:_cmd arguments:@[ telephoneNumber ]];
    link.router = self;
    [self.moduleNavigator pushLink:link];
}

- (void)unwind
{
}

@end
