//
//  MenuModuleAssembly_Testable.h
//  Example
//
//  Created by Alex Rudyak on 17/02/2016.
//  Copyright © 2016 instinctools. All rights reserved.
//

#import "MenuModuleAssembly.h"

@class MenuModuleViewController;
@class MenuModuleInteractor;
@class MenuModulePresenter;
@class MenuModuleRouter;

@interface MenuModuleAssembly ()

- (MenuModuleViewController *)viewMenuModuleModule;
- (MenuModulePresenter *)presenterMenuModuleModule;
- (MenuModuleInteractor *)interactorMenuModuleModule;
- (MenuModuleRouter *)routerMenuModuleModule;

@end
