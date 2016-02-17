//
//  UserProfileModuleAssembly_Testable.h
//  Example
//
//  Created by Alex Rudyak on 17/02/2016.
//  Copyright © 2016 instinctools. All rights reserved.
//

#import "UserProfileModuleAssembly.h"

@class UserProfileModuleViewController;
@class UserProfileModuleInteractor;
@class UserProfileModulePresenter;
@class UserProfileModuleRouter;

@interface UserProfileModuleAssembly ()

- (UserProfileModuleViewController *)viewUserProfileModuleModule;
- (UserProfileModulePresenter *)presenterUserProfileModuleModule;
- (UserProfileModuleInteractor *)interactorUserProfileModuleModule;
- (UserProfileModuleRouter *)routerUserProfileModuleModule;

@end
