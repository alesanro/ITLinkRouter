//
//  RootModulePresenter.h
//  Example
//
//  Created by Alex Rudyak on 12/02/2016.
//  Copyright © 2016 instinctools. All rights reserved.
//

#import "RootModuleViewOutput.h"
#import "RootModuleInteractorOutput.h"
#import "RootModuleModuleInput.h"

@protocol RootModuleViewInput;
@protocol RootModuleInteractorInput;
@protocol RootModuleRouterInput;

@interface RootModulePresenter : NSObject <RootModuleModuleInput, RootModuleViewOutput, RootModuleInteractorOutput>

@property (nonatomic, weak) id<RootModuleViewInput> view;
@property (nonatomic, strong) id<RootModuleInteractorInput> interactor;
@property (nonatomic, strong) id<RootModuleRouterInput> router;

@end
