//
//  ITModuleNavigatorController.m
//  Pods
//
//  Created by Alex Rudyak on 2/1/16.
//
//

#import "ITModuleNavigatorController.h"
#import "ITLinkAction.h"
#import "ITLinkChain.h"
#import "ITConstants.h"


@interface ITModuleNavigatorController ()

@property (copy, nonatomic) ITLinkChain *linkChain;

@end


@implementation ITModuleNavigatorController
@dynamic rootEntity;
@dynamic activeEntity;
@dynamic navigationChain;

- (instancetype)initWithChain:(ITLinkChain *)chain
{
    self = [super init];
    if (self) {
        _linkChain = [chain copy];
    }
    return self;
}

- (instancetype)initWithRootEntity:(ITLinkAction *)entity
{
    return [self initWithChain:[[ITLinkChain alloc] initWithEntities:@[ entity ]]];
}

#pragma Accessors

- (ITLinkAction *)rootEntity
{
    return self.linkChain.rootEntity;
}

- (ITLinkAction *)activeEntity
{
    return self.linkChain.lastEntity;
}

- (ITLinkChain *)navigationChain
{
    return [self.linkChain copy];
}

#pragma mark - Public

- (void)pushLink:(ITLinkAction *)link withResultValue:(ITLinkAction *)valueEntity
{
    if (!link) {
        @throw [NSException exceptionWithName:ITNavigationInvalidArgument reason:@"Link should not be nil when pushLink: is performing" userInfo:nil];
    }
    if ([self.linkChain.lastEntity isEqual:link]) {
        return;
    }

    [self.linkChain appendEntity:link];
}

- (void)popLink
{
    __unused ITLinkAction *const popedLinkEntity = [self.linkChain popEntity];
}

- (void)navigateToNewChain:(ITLinkChain *)updatedChain
{
}

#pragma mark - Internal

@end
