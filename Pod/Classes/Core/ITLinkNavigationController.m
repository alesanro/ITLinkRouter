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
#import "ITConstants.h"

NSString *const ITNavigationProblemTypeKey = @"ITNavigationProblemType";
NSString *const ITNavigationProblemDescriptionKey = @"ITNavigationProblemDescription";

typedef NS_ENUM(NSUInteger, ITLinkNavigationType) {
    ITLinkNavigationTypeForward,
    ITLinkNavigationTypeBack
};

typedef void (^ITSequentialNavigationBlock)(ITLinkNavigationType navigationType, id<ITLinkNode> currentNode);

static BOOL ITHasValue(id<ITLinkNode> node)
{
    return [node isEqual:[node flatten]];
}

@interface ITLinkNavigationController ()

@property (copy, nonatomic) ITLinkChain *linkChain;
@property (copy, nonatomic) ITSequentialNavigationBlock navigationBlock;
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

#pragma Accessors

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
        [self _cleanupNavigationData];
        [resolver markDone];
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
        @throw [NSException exceptionWithName:ITNavigationInvalidLinkSimilarity
                                       reason:@"Last chain element and link should be similar"
                                     userInfo:@{
                                         @"CurrentChainKey" : self.linkChain,
                                         @"PassedLinkKey" : link,
                                         @"NavigatinContextKey" : self
                                     }];
    }

    id<ITLinkNode> const valueNode = [self.linkChain popEntity];
    [link setRouter:link.router ?: valueNode.router];
    [self.linkChain appendEntity:link];
    [self.linkChain appendEntity:[valueEntity flatten]];

    if (self.navigationBlock) {
        self.navigationBlock(ITLinkNavigationTypeForward, valueEntity);
    }
}

- (void)popLink
{
    __unused id<ITLinkNode> const popedLinkEntity = [self.linkChain popEntity];
    [self.linkChain appendEntity:[[self.linkChain popEntity] flatten]];

    if (self.navigationBlock) {
        self.navigationBlock(ITLinkNavigationTypeBack, self.linkChain.lastEntity);
    }
}

- (void)navigateToNewChain:(ITLinkChain *)updatedChain
{
    [self navigateToNewChain:updatedChain andHandleAnyProblem:^(ITProblemDictionary *problemDict, ITNavigationProblemResolver *resolver) {
// todo: handle problems by default
#ifdef DEBUG
        NSLog(@"[WARNING] You haven't set up handler for resolving problems in navigation");
#endif
    }];
}

- (void)navigateToNewChain:(ITLinkChain *)updatedChain andHandleAnyProblem:(ITProblemHanderBlock)handlerBlock
{
    if (!updatedChain.length) {
        NSLog(@"[WARNING] There is nothing to navigate - destination chain is empty");
        return;
    }
    if (self.navigationInProgress) {
        NSLog(@"[ERROR] Cannot proceed new navigation since another navigation action is performing right now");
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

    ITLinkChain *const commonChain = [self.linkChain intersectionAtStartWithChain:updatedChain];
    if (!(commonChain.length || [self.linkChain.rootEntity isSimilar:updatedChain.rootEntity])) {
        NSLog(@"[WARNING] There is no instersection between two chains. Seems like you are trying navigate to already "
              @"active screen");
        return;
    }

    self.navigationResolver = [[ITNavigationProblemResolver alloc] initWithNavigationController:self destinationChain:updatedChain];
    self.problemBlock = handlerBlock;

    ITLinkChain *const backNavigationChain = [self.linkChain subtractIntersectedChain:commonChain];
    ITLinkChain *const forwardNavigationChain = [updatedChain subtractIntersectedChain:commonChain];
    while (forwardNavigationChain.lastEntity && ITHasValue(forwardNavigationChain.lastEntity)) {
        [forwardNavigationChain popEntity];
    }
    self.navigationBlock = [[self _generateNavigationBlockWithBackChain:backNavigationChain forwardChain:forwardNavigationChain] copy];
    [self _beginNavigationWithBackChain:backNavigationChain forwardChain:forwardNavigationChain];
}

#pragma mark - Internal

- (void)_cleanupNavigationData
{
    self.navigationInProgress = NO;
    self.navigationBlock = nil;
    self.navigationResolver = nil;
    self.problemBlock = nil;
}

- (void)_beginNavigationWithBackChain:(ITLinkChain *)backChain forwardChain:(ITLinkChain *)forwardChain
{
    NSInvocation *nextInvocation;
    if (backChain.length == 1 && [backChain.rootEntity isSimilar:forwardChain.rootEntity]) {
        nextInvocation = [[forwardChain shiftEntity] forwardModuleInvocation];
    } else {
        nextInvocation = [[backChain popEntity] backwardModuleInvocation];
    }

    if (nextInvocation) {
        self.navigationInProgress = YES;
        [nextInvocation invoke];
    }
}

- (ITSequentialNavigationBlock)_generateNavigationBlockWithBackChain:(ITLinkChain *)backChain forwardChain:(ITLinkChain *)forwardChain
{
    __weak typeof(self) const weakSelf = self;
    return ^(ITLinkNavigationType navigationType, id<ITLinkNode> currentNode) {
      __strong typeof(weakSelf) const strongSelf = weakSelf;
      if (navigationType == ITLinkNavigationTypeBack) {
          if (backChain.length <= 1) {
              const BOOL needStartForwardTransition = forwardChain.length && [forwardChain.rootEntity isSimilar:currentNode];
              if (needStartForwardTransition) {
                  [forwardChain.rootEntity setRouter:currentNode.router];
                  [[[forwardChain shiftEntity] forwardModuleInvocation] invoke];
                  return;
              }
              [strongSelf _cleanupNavigationData];
              return;
          } else {
              [[[[backChain popEntity] flatten] backwardModuleInvocation] invoke];
          }
      } else if (navigationType == ITLinkNavigationTypeForward) {
          const BOOL needContinueForwardTransition = forwardChain.length && [forwardChain.rootEntity isSimilar:currentNode];
          if (needContinueForwardTransition) {
              [forwardChain.rootEntity setRouter:currentNode.router];
              [[[forwardChain shiftEntity] forwardModuleInvocation] invoke];
              return;
          } else {
              [strongSelf _cleanupNavigationData];
              return;
          }
      } else {
          @throw [NSException exceptionWithName:ITNavigationInvalidNavigationType
                                         reason:@"Navigation type provided to navigation block has invalid value"
                                       userInfo:@{
                                           @"ProvidedTypeKey" : @(navigationType),
                                           @"PassedLinkKey" : currentNode,
                                           @"NavigatinContextKey" : strongSelf
                                       }];
      }
    };
}

@end
