//
//  LoginModulePresenter.h
//  Example
//
//  Created by Alex Rudyak on 17/02/2016.
//  Copyright © 2016 instinctools. All rights reserved.
//

#import "LoginModuleViewOutput.h"
#import "LoginModuleInteractorOutput.h"
#import "LoginModuleModuleInput.h"

@protocol LoginModuleViewInput;
@protocol LoginModuleInteractorInput;
@protocol LoginModuleRouterInput;

@interface LoginModulePresenter : NSObject <LoginModuleModuleInput, LoginModuleViewOutput, LoginModuleInteractorOutput>

@property (nonatomic, weak) id<LoginModuleViewInput> view;
@property (nonatomic, strong) id<LoginModuleInteractorInput> interactor;
@property (nonatomic, strong) id<LoginModuleRouterInput> router;

@end
