//
//  ITLinkEntity.h
//  Pods
//
//  Created by Alex Rudyak on 1/29/16.
//
//

#import <Foundation/Foundation.h>
#import "ITAnimatableTransition.h"
#import "ITUnwindableTransition.h"

OBJC_EXPORT NSString *ITModuleNameFromClass(Class className);


@interface ITLinkEntity : NSObject <NSCopying>

/**
 *  Name of module
 */
@property (nonatomic, readonly) NSString *moduleName;

/**
 *  Selector for the next transition
 */
@property (nonatomic, readonly) SEL linkSelector;

/**
 *  List of arguments for a transition
 */
@property (nonatomic, readonly) NSArray *arguments;

/**
 *  Object which is used to perform transition
 */
@property (strong, nonatomic) NSObject<ITAnimatableTransition, ITUnwindableTransition> *router;

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

+ (instancetype) new NS_UNAVAILABLE;

#pragma mark - Override

- (BOOL)isEqual:(id)object;

- (NSString *)debugDescription;

@end
