//
//  LoginModuleAssembly_Testable.h
//  Example
//
//  Created by Alex Rudyak on 17/02/2016.
//  Copyright © 2016 instinctools. All rights reserved.
//

#import "LoginModuleAssembly.h"

@class LoginModuleViewController;
@class LoginModuleInteractor;
@class LoginModulePresenter;
@class LoginModuleRouter;

@interface LoginModuleAssembly ()

- (LoginModuleViewController *)viewLoginModuleModule;
- (LoginModulePresenter *)presenterLoginModuleModule;
- (LoginModuleInteractor *)interactorLoginModuleModule;
- (LoginModuleRouter *)routerLoginModuleModule;

@end
