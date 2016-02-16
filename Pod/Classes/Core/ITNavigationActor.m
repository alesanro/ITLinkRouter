//
//  ITNavigationActor.m
//  Pods
//
//  Created by Alex Rudyak on 2/16/16.
//
//

#import "ITNavigationActor.h"
#import "ITLinkChain.h"
#import "ITConstants.h"

static BOOL ITHasValue(id<ITLinkNode> node)
{
    return [node isEqual:[node flatten]];
}

@implementation ITNavigationActor

- (instancetype)initWithBackChain:(ITLinkChain *)backChain forwardChain:(ITLinkChain *)forwardChain
{
    self = [super init];
    if (self) {
        _backChain = [backChain copy];
        _forwardChain = [forwardChain copy];
        while (_forwardChain.lastEntity && ITHasValue(_forwardChain.lastEntity)) {
            [_forwardChain popEntity];
        }
    }
    return self;
}

- (void)start
{
    NSInvocation *nextInvocation;
    if (self.backChain.length == 1 && [self.backChain.rootEntity isSimilar:self.forwardChain.rootEntity]) {
        nextInvocation = [[self.forwardChain shiftEntity] forwardModuleInvocation];
    } else {
        nextInvocation = [[self.backChain popEntity] backwardModuleInvocation];
    }

    if (nextInvocation) {
        [self callDelegateDidStartMethod];
        [nextInvocation invoke];
    }
}

- (void)next:(ITLinkNavigationType)navigationType withCurrentNode:(id<ITLinkNode>)node
{
    if (navigationType == ITLinkNavigationTypeBack) {
        const BOOL shouldContinueNavigateBack = self.backChain.length > 1;
        if (shouldContinueNavigateBack) {
            [[[[self.backChain popEntity] flatten] backwardModuleInvocation] invoke];
        } else {
            const BOOL needStartForwardTransition = self.forwardChain.length && [self.forwardChain.rootEntity isSimilar:node];
            if (needStartForwardTransition) {
                [self.forwardChain.rootEntity setRouter:node.router];
                [[[self.forwardChain shiftEntity] forwardModuleInvocation] invoke];
            } else {
                [self callDelegateDidFinishMethod];
            }
        }
    } else if (navigationType == ITLinkNavigationTypeForward) {
        const BOOL needContinueForwardTransition = self.forwardChain.length && [self.forwardChain.rootEntity isSimilar:node];
        if (needContinueForwardTransition) {
            [self.forwardChain.rootEntity setRouter:node.router];
            [[[self.forwardChain shiftEntity] forwardModuleInvocation] invoke];
        } else {
            [self callDelegateDidFinishMethod];
        }
    } else {
        @throw [NSException exceptionWithName:ITNavigationInvalidNavigationType reason:@"Navigation type provided to navigation block has invalid value" userInfo:@{
            @"ProvidedTypeKey" : @(navigationType),
            @"PassedLinkKey" : node,
            @"NavigatinContextKey" : self
        }];
    }
}

#pragma mark - Delegate invocation helpers

- (void)callDelegateDidStartMethod
{
    if ([self.delegate respondsToSelector:@selector(didStartNavigation:)]) {
        [self.delegate didStartNavigation:self];
    }
}

- (void)callDelegateDidFinishMethod
{
    if ([self.delegate respondsToSelector:@selector(didFinishNavigation:)]) {
        [self.delegate didFinishNavigation:self];
    }
}

@end
