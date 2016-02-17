//
//  MenuModulePresenter.h
//  Example
//
//  Created by Alex Rudyak on 17/02/2016.
//  Copyright © 2016 instinctools. All rights reserved.
//

#import "MenuModuleViewOutput.h"
#import "MenuModuleInteractorOutput.h"
#import "MenuModuleModuleInput.h"

@protocol MenuModuleViewInput;
@protocol MenuModuleInteractorInput;
@protocol MenuModuleRouterInput;

@interface MenuModulePresenter : NSObject <MenuModuleModuleInput, MenuModuleViewOutput, MenuModuleInteractorOutput>

@property (nonatomic, weak) id<MenuModuleViewInput> view;
@property (nonatomic, strong) id<MenuModuleInteractorInput> interactor;
@property (nonatomic, strong) id<MenuModuleRouterInput> router;

@end
