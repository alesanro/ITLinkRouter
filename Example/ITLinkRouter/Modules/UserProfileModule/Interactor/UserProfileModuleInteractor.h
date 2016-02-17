//
//  UserProfileModuleInteractor.h
//  Example
//
//  Created by Alex Rudyak on 17/02/2016.
//  Copyright © 2016 instinctools. All rights reserved.
//

#import "UserProfileModuleInteractorInput.h"

@protocol UserProfileModuleInteractorOutput;

@interface UserProfileModuleInteractor : NSObject <UserProfileModuleInteractorInput>

@property (nonatomic, weak) id<UserProfileModuleInteractorOutput> output;

@end
