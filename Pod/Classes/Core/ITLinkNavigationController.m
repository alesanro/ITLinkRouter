//
//  ITLinkNavigationController.m
//  Pods
//
//  Created by Alex Rudyak on 2/1/16.
//
//

#import "ITLinkNavigationController.h"
#import "ITLinkChain.h"
#import "ITNavigationProblemResolver.h"
#import "ITNavigationActor.h"
#import "ITConstants.h"

NSString *const ITNavigationProblemTypeKey = @"ITNavigationProblemType";
NSString *const ITNavigationProblemDescriptionKey = @"ITNavigationProblemDescription";

NSString *const ITNavigationWithChainStartedNotificationName = @"ITNavigationWithChainStartedNotificationName";
NSString *const ITNavigationWithChainFinishedNotificationName = @"ITNavigationWithChainFinishedNotificationName";
NSString *const ITNavigationWithChainNotificationSenderKey = @"ITNavigationWithChainNotificationSenderKey";

static BOOL ITHasValue(id<ITLinkNode> node)
{
    return [node isEqual:[node flatten]];
}

@interface ITLinkNavigationController () <ITNavigationActorDelegate>

@property (copy, nonatomic) ITLinkChain *linkChain;
@property (strong, nonatomic) ITNavigationActor *navigationActor;
@property (nonatomic) BOOL navigationInProgress;
@property (strong, nonatomic) ITNavigationProblemResolver *navigationResolver;
@property (copy, nonatomic) ITProblemHanderBlock problemBlock;

@end

@implementation ITLinkNavigationController
@dynamic rootEntity;
@dynamic activeEntity;
@dynamic navigationChain;

- (instancetype)initWithChain:(ITLinkChain *)chain
{
    self = [super init];
    if (self) {
        _linkChain = [chain copy];
        if (_linkChain.length) {
            id<ITLinkNode> const flattenLastEntity = [[_linkChain popEntity] flatten];
            [_linkChain appendEntity:flattenLastEntity];
        }
    }
    return self;
}

- (instancetype)initWithRootEntity:(id<ITLinkNode>)entity
{
    return [self initWithChain:[[ITLinkChain alloc] initWithEntities:@[ [entity flatten] ]]];
}

#pragma mark - Accessors

- (id<ITLinkNode>)rootEntity
{
    return self.linkChain.rootEntity;
}

- (id<ITLinkNode>)activeEntity
{
    return self.linkChain.lastEntity;
}

- (ITLinkChain *)navigationChain
{
    return [self.linkChain copy];
}

- (NSNotificationCenter *)notificationCenter
{
    if (!_notificationCenter) {
        _notificationCenter = [NSNotificationCenter defaultCenter];
    }
    return _notificationCenter;
}

#pragma mark - Public

- (void)reportProblem:(ITProblemDictionary *)description
{
    if (self.problemBlock && self.navigationResolver) {
        self.problemBlock(description, self.navigationResolver);
    } else {
#ifdef DEBUG
        NSLog(@"[WARNING] Cannot take into account a reported problem because no handleBlock has been defined.");
        @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Cannot take into account a reported problem because no handleBlock has been defined" userInfo:nil];
#endif
    }
}

- (void)solveProblemWithResolver:(ITNavigationProblemResolver *)resolver
{
    NSParameterAssert(resolver);

    if (!resolver.isDone) {
        ITLinkChain *const resolvingChain = resolver.resolvingChain;
        const ITProblemHanderBlock oldHandlerBlock = [self.problemBlock copy];
        [resolver markDone];
        [self _cleanupNavigationData];
        [self navigateToNewChain:resolvingChain andHandleAnyProblem:oldHandlerBlock];
    } else {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Cannot solve problem because it has already been done" userInfo:nil];
    }
}

- (void)pushLink:(id<ITLinkNode>)link withResultValue:(id<ITLinkNode>)valueEntity
{
    NSParameterAssert(link);
    NSParameterAssert(valueEntity);
    NSParameterAssert(!ITHasValue(link));

    if (![link isSimilar:self.linkChain.lastEntity]) {
        @throw [NSException exceptionWithName:ITNavigationInvalidLinkSimilarity reason:@"Last chain element and link should be similar" userInfo:@{
            @"CurrentChainKey" : self.linkChain,
            @"PassedLinkKey" : link,
            @"NavigatinContextKey" : self
        }];
    }

    id<ITLinkNode> const valueNode = [self.linkChain popEntity];
    [link setRouter:link.router ?: valueNode.router];
    [self.linkChain appendEntity:link];
    [self.linkChain appendEntity:[valueEntity flatten]];

    [self.navigationActor next:ITLinkNavigationTypeForward withCurrentNode:valueEntity];
}

- (void)popLink
{
    __unused id<ITLinkNode> const popedLinkEntity = [self.linkChain popEntity];
    [self.linkChain appendEntity:[[self.linkChain popEntity] flatten]];

    [self.navigationActor next:ITLinkNavigationTypeBack withCurrentNode:self.linkChain.lastEntity];
}

- (void)navigateToNewChain:(ITLinkChain *)updatedChain andHandleAnyProblem:(ITProblemHanderBlock)handlerBlock
{
    if (!updatedChain.length) {
#ifdef DEBUG
        NSLog(@"[WARNING] There is nothing to navigate - destination chain is empty");
#endif
        return;
    }
    if (self.navigationInProgress) {
#ifdef DEBUG
        NSLog(@"[ERROR] Cannot proceed new navigation since another navigation action is performing right now");
#endif
        if (handlerBlock) {
            ITProblemDictionary *const problem = @{
                ITNavigationProblemTypeKey : @"ITConcurentNavigation",
                ITNavigationProblemDescriptionKey : @"It is not possible to have to instant navigations for single instance of navigation controller"
            };
            handlerBlock(problem, nil);
        } else {
            @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"It is not possible to have to instant navigations for single instance of navigation controller" userInfo:nil];
        }
        return;
    }

    ITNavigationActor *const localNavigationActor = [[ITNavigationActor alloc] initWithSourceChain:self.linkChain destinationChain:updatedChain];
    if (!localNavigationActor.isValid) {
#ifdef DEBUG
        NSLog(@"[WARNING] There is no instersection between two chains. Seems like you are trying navigate to already active screen");
#endif
        return;
    }

    self.navigationResolver = [[ITNavigationProblemResolver alloc] initWithNavigationController:self destinationChain:updatedChain];
    self.problemBlock = handlerBlock;
    self.navigationActor = localNavigationActor;
    self.navigationActor.delegate = self;
    [self.navigationActor start];
}

#pragma mark - ITNavigationActorDelegate

- (void)didStartNavigation:(ITNavigationActor *)navigationActor
{
    self.navigationInProgress = YES;
    [self.notificationCenter postNotificationName:ITNavigationWithChainStartedNotificationName object:nil userInfo:@{
        ITNavigationWithChainNotificationSenderKey : self
    }];
}

- (void)didFinishNavigation:(ITNavigationActor *)navigationActor
{
    [self _cleanupNavigationData];
    [self.notificationCenter postNotificationName:ITNavigationWithChainFinishedNotificationName object:nil userInfo:@{
        ITNavigationWithChainNotificationSenderKey : self
    }];
}

#pragma mark - Internal

- (void)_cleanupNavigationData
{
    self.navigationInProgress = NO;
    self.navigationActor = nil;
    self.navigationResolver = nil;
    self.problemBlock = nil;
}

@end
