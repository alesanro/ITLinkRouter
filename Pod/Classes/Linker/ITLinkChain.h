//
//  ITLinkChain.h
//  Pods
//
//  Created by Alex Rudyak on 2/1/16.
//
//

#import <Foundation/Foundation.h>

@class ITLinkNode;

@interface ITLinkChain : NSObject <NSCopying>

/**
 *  List of link entities
 */
@property (copy, nonatomic, readonly) NSArray<ITLinkNode *> *entities;

/**
 *  First (root) entity in the list of link entities
 */
@property (nonatomic, readonly) ITLinkNode *rootEntity;

/**
 *  Last entity in the list of link entities
 */
@property (nonatomic, readonly) ITLinkNode *lastEntity;

/**
 *  Length of the chain
 */
@property (nonatomic, readonly) NSInteger length;

/**
 *  Initialize chain with link entities
 *
 *  @param linkEntities list of entities
 *
 *  @return instance of ITLinkChain class
 */
- (instancetype)initWithEntities:(NSArray<ITLinkNode *> *)linkEntities NS_DESIGNATED_INITIALIZER;

#pragma mark - Public

/**
 *  Append new entity to existed list of link entities
 *
 *  @param entity new entity to add
 *
 *  @return reference to 'self' to make available chained operations
 */
- (ITLinkChain *)appendEntity:(ITLinkNode *)entity;

/**
 *  Remove last entity from the list of link entities
 *
 *  @return removed link entity
 */
- (ITLinkNode *)popEntity;

/**
 *  Remove first entity from the list of link entities
 *
 *  @return removed link entity
 */
- (ITLinkNode *)shiftEntity;

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
 *          Retur empty chain (with zero length) if no matches were found
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

/**
 *  Subtract from current the current chain other chain. Result will not be nil
 *  in case when both chains have non-nil intersection.
 *
 *  @param otherChain subtracted chain
 *
 *  @return chain without common elements with another chain
 */
- (ITLinkChain *)subtractIntersectedChain:(ITLinkChain *)otherChain;

#pragma mark - Override

- (BOOL)isEqual:(id)object;

- (NSString *)debugDescription;

@end
