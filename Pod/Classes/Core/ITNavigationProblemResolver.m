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

@interface ITNavigationProblemResolver ()

@property (nonatomic, getter=isResolved) BOOL resolved;

@end

@implementation ITNavigationProblemResolver
@dynamic currentChain;

- (instancetype)initWithNavigationController:(ITLinkNavigationController *)navigationController destinationChain:(ITLinkChain *)destinationChain
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
    if (self.resolved) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"You cannon navigate after resolving problem" userInfo:nil];
    }
    _resolvingChain = self.destinationChain;
}

- (void)navigateToOtherChain:(ITLinkChain *)otherChain
{
    if (self.resolved) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"You cannon navigate after resolving problem" userInfo:nil];
    }
    _resolvingChain = otherChain;
}

- (void)resolve
{
    if (self.resolved) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"You cannon resolve more than once" userInfo:nil];
    }

    if (self.resolvingChain) {
        [self.navigationController solveProblemWithResolver:self];
        self.resolved = YES;
    } else {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"You should continue a navigation or navigate to other chain before resolving problem" userInfo:nil];
    }
}

- (void)markDone
{
    if (_done) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"You cannon mark done more than once" userInfo:nil];
    }
    _done = YES;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    ITNavigationProblemResolver *const copyInstance = [[ITNavigationProblemResolver alloc] initWithNavigationController:self.navigationController destinationChain:[self.destinationChain copy]];
    copyInstance->_resolvingChain = [self.resolvingChain copy];
    return copyInstance;
}

@end
