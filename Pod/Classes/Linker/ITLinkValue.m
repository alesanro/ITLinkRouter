//
//  ITLinkValue.m
//  Pods
//
//  Created by Alex Rudyak on 2/2/16.
//
//

#import "ITLinkValue.h"


@implementation ITLinkValue

- (BOOL)isEqual:(id)object
{
    if (![super isEqual:object]) {
        return NO;
    }

    if (![object isKindOfClass:[ITLinkValue class]]) {
        return NO;
    }

    return YES;
}

@end
