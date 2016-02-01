//
//  ITLinkChain.h
//  Pods
//
//  Created by Alex Rudyak on 2/1/16.
//
//

#import <Foundation/Foundation.h>

@class ITLinkEntity;


@interface ITLinkChain : NSObject

/**
 *  List of link entities
 */
@property (copy, nonatomic, readonly) NSArray<ITLinkEntity *> *entities;

/**
 *  First (root) entity in the list of link entities
 */
@property (nonatomic, readonly) ITLinkEntity *rootEntity;

/**
 *  Initialize chain with link entities
 *
 *  @param linkEntities list of entities
 *
 *  @return instance of ITLinkChain class
 */
- (instancetype)initWithEntities:(NSArray<ITLinkEntity *> *)linkEntities NS_DESIGNATED_INITIALIZER;

#pragma mark - Public

/**
 *  Append new entity to existed list of link entities
 *
 *  @param entity new entity to add
 *
 *  @return reference to 'self' to make available chained operations
 */
- (ITLinkChain *)appendEntity:(ITLinkEntity *)entity;

/**
 *  Remove last entity from the list of link entities
 *
 *  @return removed link entity
 */
- (ITLinkEntity *)popEntity;

/**
 *  Find first intersection range (greed algorithm) between two link chains.
 *
 *  @param otherLinkChain other chain to compare
 *
 *  @return range of found intersection. If no matches were found then location
 *           value will be equal to @b NSNotFound
 */
- (NSRange)intersectionRangeWithChain:(ITLinkChain *)otherLinkChain;

/**
 *  Find first intersection (greed algorithm) between two link chains.
 *
 *  @param otherLinkChain other chain to compare
 *
 *  @return new chain object which contains only common entities.
 *          @a nil if no matches were found
 */
- (ITLinkChain *)intersectionWithChain:(ITLinkChain *)otherLinkChain;

/**
 *  Find common part between two link chaines. Parts considered common if they
 *  both start from the equal root link entity and have zero or more equal
 *  entities sequentially.
 *
 *  @param otherLinkChain other chain to compare
 *
 *  @return new chain object which contains only common entities.
 *          @a nil if no matches were found
 */
- (ITLinkChain *)intersectionAtStartWithChain:(ITLinkChain *)otherLinkChain;

/**
 *  Extract new link chain with a subset of link entities
 *
 *  @param range range of subset
 *
 *  @return new object with subset of link entities
 */
- (ITLinkChain *)subchainWithRange:(NSRange)range;

#pragma mark - Override

- (BOOL)isEqual:(id)object;

@end
