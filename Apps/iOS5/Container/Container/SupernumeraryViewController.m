//
//  ModalViewController.m
//  Container
//
//  Created by Clemens Wagner on 31.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SupernumeraryViewController.h"

@implementation SupernumeraryViewController

@synthesize label;
@synthesize closeButton;

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidUnload {
    self.label = nil;
    self.closeButton = nil;
    [super viewDidUnload];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)inInterfaceOrientation duration:(NSTimeInterval)inDuration {
    [super willRotateToInterfaceOrientation:inInterfaceOrientation duration:inDuration];
    NSLog(@"willRotateToInterfaceOrientation:%d duration:%.2f", inInterfaceOrientation, inDuration);
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)inInterfaceOrientation {
    NSLog(@"didRotateFromInterfaceOrientation:%d", inInterfaceOrientation);
    [super didRotateFromInterfaceOrientation:inInterfaceOrientation];
}

- (void)viewWillAppear:(BOOL)inAnimated {
    [super viewWillAppear:inAnimated];
    NSLog(@"viewWillAppear:%@", self.label.text);
}

- (void)viewDidAppear:(BOOL)inAnimated {
    [super viewDidAppear:inAnimated];
    NSLog(@"viewDidAppear:%@", self.label.text);
}

- (void)viewWillDisappear:(BOOL)inAnimated {
    NSLog(@"viewWillDisppear:%@", self.label.text);
    [super viewWillDisappear:inAnimated];
}

- (void)viewDidDisappear:(BOOL)inAnimated {
    NSLog(@"viewDidDisappear:%@", self.label.text);
    [super viewDidDisappear:inAnimated];
}

- (void)willMoveToParentViewController:(UIViewController *)inParent {
    [super willMoveToParentViewController:inParent];
    NSLog(@"willMoveToParentViewController: %@", self.label.text);
}

- (void)didMoveToParentViewController:(UIViewController *)inParent {
    NSLog(@"didMoveToParentViewController: %@", self.label.text);
    [super didMoveToParentViewController:inParent];
}


- (IBAction)close {
    UIViewController *theToViewController = self.parentViewController;
    CGRect theBounds = theToViewController.view.bounds;
    UIView *theView = self.view;
    UIView *theBackgroundView = theView.superview;
    
    [self willMoveToParentViewController:nil];
    [UIView animateWithDuration:1.0
                     animations:^{
                         theBackgroundView.alpha = 0.0;
                         theView.transform = CGAffineTransformScale(CGAffineTransformMakeTranslation(-CGRectGetMidX(theBounds), CGRectGetMidY(theBounds)), 1.0 / 32.0, 1.0 / 32.0);
                     }
                     completion:^(BOOL inFinished) {
                         [theBackgroundView removeFromSuperview];
                         [theView removeFromSuperview];
                         [self removeFromParentViewController];
                     }];
}

@end
