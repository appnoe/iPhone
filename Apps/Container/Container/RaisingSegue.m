//
//  RotationSegue.m
//  Container
//
//  Created by Clemens Wagner on 31.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RaisingSegue.h"

@implementation RaisingSegue

- (void)perform {
    UIViewController *theFromViewController = self.sourceViewController;
    UIViewController *theToViewController = self.destinationViewController;
    CGRect theBounds = theFromViewController.view.bounds;
    UIView *theView = theToViewController.view;
    UIView *theBackgroundView = [[UIView alloc] initWithFrame:theBounds];
    
    [theFromViewController addChildViewController:theToViewController];
    theBackgroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    theBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    theBackgroundView.alpha = 0.0;
    [theBackgroundView addSubview:theView];
    [theFromViewController.view addSubview:theBackgroundView];
    theView.frame = CGRectInset(theBounds, 20.0, 20.0);
    theView.transform = CGAffineTransformScale(CGAffineTransformMakeTranslation(-CGRectGetMidX(theBounds), CGRectGetMidY(theBounds)), 1.0 / 32.0, 1.0 / 32.0);
    [UIView animateWithDuration:1.0 
                     animations:^{                         
                         theBackgroundView.alpha = 1.0;
                         theView.transform = CGAffineTransformIdentity;
                     }
                     completion:^(BOOL inFinished) {
                         [theToViewController didMoveToParentViewController:theFromViewController];                         
                     }];
}

@end
