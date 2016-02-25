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

@interface ITNavigationActor ()

@property (nonatomic, getter=isStarted) BOOL started;
@property (nonatomic, getter=isFinished) BOOL finished;

@end

@implementation ITNavigationActor

- (instancetype)initWithSourceChain:(ITLinkChain *)sourceChain destinationChain:(ITLinkChain *)destinationChain
{
    self = [super init];
    if (self) {
        ITLinkChain *const commonChain = [sourceChain intersectionAtStartWithChain:destinationChain];
        ITLinkChain *const backNavigationChain = [sourceChain subtractIntersectedChain:commonChain];
        ITLinkChain *const forwardNavigationChain = [destinationChain subtractIntersectedChain:commonChain];
        _valid = (commonChain.length || [sourceChain.rootEntity isSimilar:destinationChain.rootEntity]);
        _backChain = backNavigationChain;
        _forwardChain = forwardNavigationChain;
        while (_forwardChain.lastEntity && ITHasValue(_forwardChain.lastEntity)) {
            [_forwardChain popEntity];
        }
    }
    return self;
}

- (void)start
{
    if (!self.isValid) {
#ifdef DEBUG
        NSLog(@"[ERROR] Actor has invalid state and cannot proceed.");
#endif
        return;
    }
    if (self.isStarted || self.isFinished) {
#ifdef DEBUG
        NSLog(@"[WARNING] Cannot start navigation because of it is already started or has finished.");
#endif
        return;
    }

    NSInvocation *nextInvocation;
    if (self.backChain.length == 1 && [self.backChain.rootEntity isSimilar:self.forwardChain.rootEntity]) {
        nextInvocation = [[self.forwardChain shiftEntity] forwardModuleInvocation];
    } else {
        nextInvocation = [[self.backChain popEntity] backwardModuleInvocation];
    }

    [self callDelegateDidStartMethod];
    if (nextInvocation) {
        [nextInvocation invoke];
    } else {
        [self callDelegateDidFinishMethod];
    }
}

- (void)runNextWithCurrentDirection:(ITLinkNavigationType)navigationType andNode:(id<ITLinkNode>)node
{
    if (!self.isStarted || self.isFinished) {
#ifdef DEBUG
        NSLog(@"[WARNING] Cannot proceed navigation because of it is already finished or hasn't been started yet.");
#endif
        return;
    }

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
    self.started = YES;
    if ([self.delegate respondsToSelector:@selector(didStartNavigation:)]) {
        [self.delegate didStartNavigation:self];
    }
}

- (void)callDelegateDidFinishMethod
{
    self.finished = YES;
    if ([self.delegate respondsToSelector:@selector(didFinishNavigation:)]) {
        [self.delegate didFinishNavigation:self];
    }
}

@end
