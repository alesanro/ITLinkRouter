//
//  UserProfileModulePresenter.h
//  Example
//
//  Created by Alex Rudyak on 17/02/2016.
//  Copyright © 2016 instinctools. All rights reserved.
//

#import "UserProfileModuleViewOutput.h"
#import "UserProfileModuleInteractorOutput.h"
#import "UserProfileModuleModuleInput.h"

@protocol UserProfileModuleViewInput;
@protocol UserProfileModuleInteractorInput;
@protocol UserProfileModuleRouterInput;

@interface UserProfileModulePresenter : NSObject <UserProfileModuleModuleInput, UserProfileModuleViewOutput, UserProfileModuleInteractorOutput>

@property (nonatomic, weak) id<UserProfileModuleViewInput> view;
@property (nonatomic, strong) id<UserProfileModuleInteractorInput> interactor;
@property (nonatomic, strong) id<UserProfileModuleRouterInput> router;

@end
