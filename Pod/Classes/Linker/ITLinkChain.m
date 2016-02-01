//
//  ITLinkChain.m
//  Pods
//
//  Created by Alex Rudyak on 2/1/16.
//
//

#import "ITLinkChain.h"
#import "ITLinkEntity.h"


@interface ITLinkChain ()

@property (nonatomic, strong) NSMutableArray<ITLinkEntity *> *internalEntities;

@end


@implementation ITLinkChain
@dynamic entities;

- (instancetype)initWithEntities:(NSArray<ITLinkEntity *> *)internalEntities
{
    self = [super init];
    if (self) {
        _internalEntities = internalEntities ? [internalEntities mutableCopy] : [NSMutableArray array];
    }
    return self;
}

- (instancetype)init
{
    return [self initWithEntities:nil];
}

#pragma mark - Accessors

- (NSArray<ITLinkEntity *> *)entities
{
    return [NSArray arrayWithArray:self.internalEntities];
}

#pragma mark - Public

- (ITLinkChain *)appendEntity:(ITLinkEntity *)entity
{
    [self.internalEntities addObject:entity];
    return self;
}

- (ITLinkEntity *)popEntity
{
    ITLinkEntity *const removeEntity = [self.internalEntities lastObject];
    [self.internalEntities removeLastObject];
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
    [self.internalEntities enumerateObjectsUsingBlock:^(ITLinkEntity *const selfEntity, NSUInteger selfIdx, BOOL *selfStop) {
        __block BOOL hasIntersection = NO;
        [otherLinkChain.internalEntities enumerateObjectsUsingBlock:^(ITLinkEntity *const otherEntity, NSUInteger otherIdx, BOOL *otherStop) {
            if (!hasIntersection && [selfEntity isEqual:otherEntity]) {
                hasIntersection = YES;
                intersectionRange = NSMakeRange(selfIdx, 1);
                return;
            }

            if (hasIntersection) {
                ITLinkEntity *const nextEntity = self.internalEntities[selfIdx + intersectionRange.length];
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
    if (intersectionRange.location != 0) {
        return nil;
    }
    return [self subchainWithRange:intersectionRange];
}


- (ITLinkChain *)subchainWithRange:(NSRange)range
{
    NSArray *const subentities = [self.internalEntities subarrayWithRange:range];
    return [[ITLinkChain alloc] initWithEntities:subentities];
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
    [self.internalEntities enumerateObjectsUsingBlock:^(ITLinkEntity *const selfEntity, NSUInteger idx, BOOL *stop) {
        ITLinkEntity *const otherEntity = otherObj.internalEntities[idx];
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
    [self.internalEntities enumerateObjectsUsingBlock:^(ITLinkEntity *obj, NSUInteger idx, BOOL *stop) {
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
