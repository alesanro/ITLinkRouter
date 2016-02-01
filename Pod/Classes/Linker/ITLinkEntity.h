//
//  ITLinkEntity.h
//  Pods
//
//  Created by Alex Rudyak on 1/29/16.
//
//

#import <Foundation/Foundation.h>

@interface ITLinkEntity : NSObject

/**
 *  Name of module
 */
@property (copy, nonatomic, readonly) NSString *moduleName;

/**
 *  Selector for the next transition
 */
@property (assign, nonatomic, readonly) SEL linkSelector;

/**
 *  List of arguments for a transition
 */
@property (copy, nonatomic, readonly) NSArray *arguments;

/**
 *  Initialize entity with
 *
 *  @param moduleName   name of module
 *  @param linkSelector selector for route
 *  @param arguments    list of arguments
 *
 *  @return instance of ITLinkEntity class
 */
- (instancetype)initWithModule:(NSString *)moduleName link:(SEL)linkSelector arguments:(NSArray *)arguments;

- (instancetype)init NS_UNAVAILABLE;

+ (instancetype)new NS_UNAVAILABLE;

#pragma mark - Override

- (BOOL)isEqual:(id)object;

@end
