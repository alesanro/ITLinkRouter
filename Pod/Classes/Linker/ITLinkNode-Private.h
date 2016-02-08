//
//  ITLinkNode-Private.h
//  Pods
//
//  Created by Alex Rudyak on 2/4/16.
//
//

#import "ITLinkNode.h"

@interface ITLinkNode ()

- (instancetype)initWithModuleName:(NSString *)moduleName;

- (instancetype)initWithModuleName:(NSString *)moduleName router:(ROUTER_TYPE)router NS_DESIGNATED_INITIALIZER;

@end
