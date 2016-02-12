//
//  RootModuleAssembly_Testable.h
//  Example
//
//  Created by Alex Rudyak on 12/02/2016.
//  Copyright © 2016 instinctools. All rights reserved.
//

#import "RootModuleAssembly.h"

@class RootModuleViewController;
@class RootModuleInteractor;
@class RootModulePresenter;
@class RootModuleRouter;

@interface RootModuleAssembly ()

- (RootModuleViewController *)viewRootModuleModule;
- (RootModulePresenter *)presenterRootModuleModule;
- (RootModuleInteractor *)interactorRootModuleModule;
- (RootModuleRouter *)routerRootModuleModule;

@end
