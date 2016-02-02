//
//  ITSupportClassStructure.h
//  ITLinkRouter
//
//  Created by Alex Rudyak on 2/2/16.
//  Copyright © 2016 Alex Rudyak. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface _ITBasicRouter : NSObject <ITUnwindableTransition>

@property (nonatomic, getter=isAnimatable) BOOL animatable;
@property (nonatomic, strong) ITModuleNavigatorController *moduleNavigator;

@end


@interface _ITRootModuleRouter : _ITBasicRouter <ITUnwindableTransition>


- (void)navigateToLogin:(NSString *)destination;

@end


@interface _ITLoginModuleRouter : _ITBasicRouter <ITUnwindableTransition>

- (void)navigateToSignInWithUser:(NSString *)username password:(NSString *)password;

- (void)navigateToSignUp;

@end


@interface _ITFeedModuleRouter : _ITBasicRouter <ITUnwindableTransition>

- (void)openProfile;

@end


@interface _ITProfileModuleRouter : _ITBasicRouter <ITUnwindableTransition>

- (void)editNumber:(NSString *)telephoneNumber;

@end
