//
//  ITNavigationProblemResolver.m
//  Pods
//
//  Created by Alex Rudyak on 2/12/16.
//
//

#import "ITNavigationProblemResolver.h"
#import "ITLinkChain.h"
#import "ITLinkNavigationController.h"

@implementation ITNavigationProblemResolver
@dynamic currentChain;

- (instancetype)initWithNavigationController:(ITLinkNavigationController *)navigationController
                            destinationChain:(ITLinkChain *)destinationChain
{
    self = [super init];
    if (self) {
        _navigationController = navigationController;
        _destinationChain = destinationChain;
    }
    return self;
}

#pragma mark - Accessors

- (ITLinkChain *)currentChain
{
    return self.navigationController.navigationChain;
}

#pragma mark - Public

- (void)continueNavigation
{
}

- (void)navigateToOtherChain:(ITLinkChain *)otherChain
{
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    ITNavigationProblemResolver *const copyInstance =
        [[ITNavigationProblemResolver alloc] initWithNavigationController:self.navigationController
                                                         destinationChain:[self.destinationChain copy]];
    return copyInstance;
}

@end
