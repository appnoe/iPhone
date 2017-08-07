//
//  ContainerViewController.m
//  Container
//
//  Created by Clemens Wagner on 31.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ContainerViewController.h"
#import "SupernumeraryViewController.h"
#import "RaisingSegue.h"
#import <QuartzCore/QuartzCore.h>

@implementation ContainerViewController

@synthesize containerView;
@synthesize viewControllers;

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *theView = self.containerView;
    NSMutableArray *theControllers = [NSMutableArray arrayWithCapacity:4];
    
    for(NSUInteger i = 0; i < 4; ++i) {
        SupernumeraryViewController *theController = 
        [self.storyboard instantiateViewControllerWithIdentifier:@"supermumerary"];
        
        [self addChildViewController:theController];
        [theView addSubview:theController.view];
        theController.label.text = [NSString stringWithFormat:@"%u", i];
        [theController didMoveToParentViewController:self];
        theController.view.layer.cornerRadius = 10.0;
        theController.view.layer.masksToBounds = YES;
        theController.view.layer.borderWidth = 1.0;
        theController.view.layer.borderColor = [UIColor blackColor].CGColor;
        theController.closeButton.hidden = YES;
        [theControllers addObject:theController];
    }
    self.viewControllers = theControllers;
}

- (void)viewDidUnload {
    self.containerView = nil;
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)inInterfaceOrientation {
    return YES;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGRect theBounds = self.containerView.bounds;
    CGRect theFrame = CGRectMake(0.0, 0.0, 
                                 CGRectGetWidth(theBounds) / 2.0, CGRectGetHeight(theBounds) / 2.0);
    NSUInteger theIndex = 0;
    
    for(UIViewController *theController in self.viewControllers) {
        UIView *theView = theController.view;
        NSUInteger theColumn = theIndex % 2;
        NSUInteger theRow = theIndex / 2;
        
        theFrame.origin.x = theColumn * theFrame.size.width;
        theFrame.origin.y = theRow * theFrame.size.height;
        theView.frame = theFrame;
        theIndex++;
    }
}

@end