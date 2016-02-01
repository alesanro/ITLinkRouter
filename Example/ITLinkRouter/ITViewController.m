//
//  ITViewController.m
//  ITLinkRouter
//
//  Created by Alex Rudyak on 01/29/2016.
//  Copyright (c) 2016 Alex Rudyak. All rights reserved.
//

#import "ITViewController.h"
@import ITLinkRouter;


@interface ITViewController ()

@end


@implementation ITViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    NSLog(@"View will appear - tag (%d)", self.view.tag);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonAction:(id)sender
{
    static NSInteger ViewCounter = 0;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    const NSUInteger controllersCapacity = 5;
    NSMutableArray<UIViewController *> *viewControllers = [NSMutableArray arrayWithCapacity:controllersCapacity];
    for (uint idx = 0; idx < controllersCapacity; ++idx) {
        UIViewController *const vc = [storyboard instantiateViewControllerWithIdentifier:@"ITViewController"];
        vc.view.tag = ++ViewCounter;
        [viewControllers addObject:vc];
    }

    [viewControllers enumerateObjectsUsingBlock:^(UIViewController *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
      [self.navigationController pushViewController:obj animated:(idx + 1 == controllersCapacity)];
    }];
}

@end
