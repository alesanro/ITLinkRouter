//
//  ITLinkValue.h
//  Pods
//
//  Created by Alex Rudyak on 2/2/16.
//
//

#import "ITLinkNode.h"

@interface ITLinkValue : ITLinkNode

- (instancetype)initWithModuleName:(NSString *)moduleName;

- (instancetype)initWithModuleName:(NSString *)moduleName router:(ROUTER_TYPE)router NS_DESIGNATED_INITIALIZER;

#pragma mark - Override

- (BOOL)isEqual:(id)object;

- (NSUInteger)hash;

@end
