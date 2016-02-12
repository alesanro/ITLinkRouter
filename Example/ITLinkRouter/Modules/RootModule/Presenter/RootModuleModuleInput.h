//
//  RootModuleModuleInput.h
//  Example
//
//  Created by Alex Rudyak on 12/02/2016.
//  Copyright © 2016 instinctools. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ViperMcFlurry/ViperMcFlurry.h>

@protocol RootModuleModuleInput <RamblerViperModuleInput>

/**
 @author Alex Rudyak

 Метод инициирует стартовую конфигурацию текущего модуля
 */
- (void)configureModule;

@end
