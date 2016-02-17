//
//  MenuModuleInteractor.h
//  Example
//
//  Created by Alex Rudyak on 17/02/2016.
//  Copyright © 2016 instinctools. All rights reserved.
//

#import "MenuModuleInteractorInput.h"

@protocol MenuModuleInteractorOutput;

@interface MenuModuleInteractor : NSObject <MenuModuleInteractorInput>

@property (nonatomic, weak) id<MenuModuleInteractorOutput> output;

@end
