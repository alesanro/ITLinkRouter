//
//  ITLinkChain.m
//  Pods
//
//  Created by Alex Rudyak on 2/1/16.
//
//

#import "ITLinkChain.h"

@interface ITLinkChain ()

@property (nonatomic, strong) NSMutableArray<id<ITLinkNode>> *internalEntities;

@end

@implementation ITLinkChain
@dynamic entities;
@dynamic rootEntity;
@dynamic lastEntity;

- (instancetype)initWithEntities:(NSArray<id<ITLinkNode>> *)linkEntities
{
    self = [super init];
    if (self) {
        _internalEntities = linkEntities.count ? [linkEntities mutableCopy] : [NSMutableArray array];
    }
    return self;
}

- (instancetype)init
{
    return [self initWithEntities:nil];
}

#pragma mark - Accessors

- (NSArray<id<ITLinkNode>> *)entities
{
    return [NSArray arrayWithArray:self.internalEntities];
}

- (id<ITLinkNode>)rootEntity
{
    return self.internalEntities.firstObject;
}

- (id<ITLinkNode>)lastEntity
{
    return self.internalEntities.lastObject;
}

- (NSInteger)length
{
    return self.internalEntities.count;
}

#pragma mark - Public

- (ITLinkChain *)appendEntity:(id<ITLinkNode>)entity
{
    [self.internalEntities addObject:entity];
    return self;
}

- (id<ITLinkNode>)popEntity
{
    id<ITLinkNode> const removeEntity = self.internalEntities.lastObject;
    [self.internalEntities removeLastObject];
    return removeEntity;
}

- (id<ITLinkNode>)shiftEntity
{
    id<ITLinkNode> const removeEntity = self.internalEntities.firstObject;
    if (self.internalEntities.count) {
        [self.internalEntities removeObjectAtIndex:0];
    }
    return removeEntity;
}

- (NSRange)intersectionRangeWithChain:(ITLinkChain *)otherLinkChain
{
    const NSRange notFoundRange = NSMakeRange(NSNotFound, 0);

    if ([self isEqual:otherLinkChain]) {
        return NSMakeRange(0, self.internalEntities.count);
    }
    if (!self.internalEntities.count) {
        return notFoundRange;
    }
    if (!otherLinkChain.internalEntities.count) {
        return notFoundRange;
    }

    __block NSRange intersectionRange;
    [self.internalEntities enumerateObjectsUsingBlock:^(id<ITLinkNode> const selfEntity, NSUInteger selfIdx, BOOL *selfStop) {
        __block BOOL hasIntersection = NO;
        [otherLinkChain.internalEntities enumerateObjectsUsingBlock:^(id<ITLinkNode> const otherEntity, NSUInteger otherIdx, BOOL *otherStop) {
            if (!hasIntersection && [selfEntity isEqual:otherEntity]) {
                hasIntersection = YES;
                intersectionRange = NSMakeRange(selfIdx, 1);
                return;
            }

            if (hasIntersection) {
                const NSInteger nextIdx = selfIdx + intersectionRange.length;
                if (self.internalEntities.count <= nextIdx) {
                    *otherStop = YES;
                    return;
                }

                id<ITLinkNode> const nextEntity = self.internalEntities[nextIdx];
                if ([otherEntity isEqual:nextEntity]) {
                    intersectionRange.length++;
                } else {
                    *otherStop = YES;
                }
            }
        }];

        if (!hasIntersection) {
            intersectionRange = notFoundRange;
        } else {
            *selfStop = YES;
        }
    }];

    return intersectionRange;
}

- (ITLinkChain *)intersectionWithChain:(ITLinkChain *)otherLinkChain
{
    return [self subchainWithRange:[self intersectionRangeWithChain:otherLinkChain]];
}

- (ITLinkChain *)intersectionAtStartWithChain:(ITLinkChain *)otherLinkChain
{
    const NSRange intersectionRange = [self intersectionRangeWithChain:otherLinkChain];
    const NSRange reverseIntersectionRange = [otherLinkChain intersectionRangeWithChain:self];
    if (intersectionRange.location == 0 && NSEqualRanges(intersectionRange, reverseIntersectionRange)) {
        return [self subchainWithRange:intersectionRange];
    }

    return [ITLinkChain new];
}

- (ITLinkChain *)subchainWithRange:(NSRange)range
{
    const NSRange entitiesRange = NSMakeRange(0, self.internalEntities.count);
    const NSRange rangeIntersection = NSIntersectionRange(range, entitiesRange);
    NSArray *const subentities = [self.internalEntities subarrayWithRange:rangeIntersection];
    return [[ITLinkChain alloc] initWithEntities:subentities];
}

- (ITLinkChain *)subtractIntersectedChain:(ITLinkChain *)otherChain
{
    const NSRange entitiesRange = NSMakeRange(0, self.internalEntities.count);
    const NSRange intersectedRange = [self intersectionRangeWithChain:otherChain];
    const NSRange rangeIntersection = NSIntersectionRange(entitiesRange, intersectedRange);
    ITLinkChain *const updatedChain = [self copy];
    [updatedChain.internalEntities removeObjectsInRange:rangeIntersection];
    return updatedChain;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    ITLinkChain *const copyInstance = [[ITLinkChain alloc] initWithEntities:[[NSArray alloc] initWithArray:self.internalEntities copyItems:YES]];
    return copyInstance;
}

#pragma mark - Override

- (BOOL)isEqual:(id)object
{
    if (![object isKindOfClass:[self class]]) {
        return NO;
    }

    if (self == object) {
        return YES;
    }

    ITLinkChain *const otherObj = (ITLinkChain *)object;
    if (self.internalEntities.count != otherObj.internalEntities.count) {
        return NO;
    }

    __block BOOL equal = YES;
    [self.internalEntities enumerateObjectsUsingBlock:^(id<ITLinkNode> const selfEntity, NSUInteger idx, BOOL *stop) {
        id<ITLinkNode> const otherEntity = otherObj.internalEntities[idx];
        equal = [selfEntity isEqual:otherEntity];
        if (!equal) {
            *stop = YES;
        }
    }];

    return equal;
}

- (NSString *)debugDescription
{
    NSMutableString *description = [NSMutableString stringWithFormat:@"LinkChain (%@): [\n", [super debugDescription]];
    [self.internalEntities enumerateObjectsUsingBlock:^(id<ITLinkNode> const obj, NSUInteger idx, BOOL *stop) {
        [description appendFormat:@"\t%@", [obj debugDescription]];
        if (idx + 1 != self.internalEntities.count) {
            [description appendFormat:@"\n\t\t\t|"];
            [description appendFormat:@"\n\t\t\tV"];
            [description appendFormat:@"\n"];
        }
    }];
    [description appendString:@"\n]"];
    return description;
}

@end
