//
//  LoginModuleInteractor.h
//  Example
//
//  Created by Alex Rudyak on 17/02/2016.
//  Copyright © 2016 instinctools. All rights reserved.
//

#import "LoginModuleInteractorInput.h"

@protocol LoginModuleInteractorOutput;

@interface LoginModuleInteractor : NSObject <LoginModuleInteractorInput>

@property (nonatomic, weak) id<LoginModuleInteractorOutput> output;

@end
