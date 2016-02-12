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

typedef NS_ENUM(NSUInteger, ITLinkNavigationType) { ITLinkNavigationTypeForward, ITLinkNavigationTypeBack };

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
    assert(self.navigationResolver);

    if (self.problemBlock) {
        self.problemBlock(description, self.navigationResolver);
    }
}

- (void)pushLink:(id<ITLinkNode>)link withResultValue:(id<ITLinkNode>)valueEntity
{
    NSParameterAssert(link);
    NSParameterAssert(valueEntity);
    NSParameterAssert(!ITHasValue(link));

    self.navigationInProgress = YES;
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

    self.navigationInProgress = NO;
}

- (void)popLink
{
    self.navigationInProgress = YES;
    __unused id<ITLinkNode> const popedLinkEntity = [self.linkChain popEntity];
    [self.linkChain appendEntity:[[self.linkChain popEntity] flatten]];

    if (self.navigationBlock) {
        self.navigationBlock(ITLinkNavigationTypeBack, self.linkChain.lastEntity);
    }

    self.navigationInProgress = NO;
}

- (void)navigateToNewChain:(ITLinkChain *)updatedChain
{
    [self navigateToNewChain:updatedChain
         andHandleAnyProblem:^(ITProblemDictionary *problemDict, ITNavigationProblemResolver *resolver){
             // todo: handle problems by default
         }];
}

- (void)navigateToNewChain:(ITLinkChain *)updatedChain andHandleAnyProblem:(ITProblemHanderBlock)handlerBlock
{
    assert(!self.navigationResolver);
    self.navigationResolver =
        [[ITNavigationProblemResolver alloc] initWithNavigationController:self destinationChain:updatedChain];
    self.problemBlock = handlerBlock;

    if (!updatedChain.length) {
        NSLog(@"[WARNING] There is nothing to navigate - destination chain is empty");
        return;
    }

    if (self.navigationInProgress) {
        NSLog(@"[ERROR] Cannot proceed new navigation since another navigation action is performing right now");
        return;
    }

    ITLinkChain *const commonChain = [self.linkChain intersectionAtStartWithChain:updatedChain];
    if (!(commonChain.length || [self.linkChain.rootEntity isSimilar:updatedChain.rootEntity])) {
        NSLog(@"[WARNING] There is no instersection between two chains. Seems like you are trying navigate to already "
              @"active screen");
        return;
    }

    ITLinkChain *const backNavigationChain = [self.linkChain subtractIntersectedChain:commonChain];
    ITLinkChain *const forwardNavigationChain = [updatedChain subtractIntersectedChain:commonChain];
    while (forwardNavigationChain.lastEntity && ITHasValue(forwardNavigationChain.lastEntity)) {
        [forwardNavigationChain popEntity];
    }
    self.navigationBlock =
        [[self _generateNavigationBlockWithBackChain:backNavigationChain forwardChain:forwardNavigationChain] copy];
    [self _beginNavigationWithBackChain:backNavigationChain forwardChain:forwardNavigationChain];
}

#pragma mark - Internal

- (void)_cleanupNavigationData
{
    self.navigationBlock = nil;
    [self.navigationResolver resolve];
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
    [nextInvocation invoke];
}

- (ITSequentialNavigationBlock)_generateNavigationBlockWithBackChain:(ITLinkChain *)backChain
                                                        forwardChain:(ITLinkChain *)forwardChain
{
    __weak typeof(self) const weakSelf = self;
    return ^(ITLinkNavigationType navigationType, id<ITLinkNode> currentNode) {
      __strong typeof(weakSelf) const strongSelf = weakSelf;
      if (navigationType == ITLinkNavigationTypeBack) {
          if (backChain.length <= 1) {
              const BOOL needStartForwardTransition =
                  forwardChain.length && [forwardChain.rootEntity isSimilar:currentNode];
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
          const BOOL needContinueForwardTransition =
              forwardChain.length && [forwardChain.rootEntity isSimilar:currentNode];
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
