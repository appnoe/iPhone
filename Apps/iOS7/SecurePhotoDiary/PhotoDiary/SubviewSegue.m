//
//  SubviewSegue.m
//  PhotoDiary
//
//  Created by Clemens Wagner on 31.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SubviewSegue.h"

@implementation SubviewSegue

- (void)perform {
    UIViewController *theFromViewController = self.sourceViewController;
    UIViewController *theToViewController = self.destinationViewController;
    CGRect theBounds = theFromViewController.view.bounds;
    UIView *theView = theToViewController.view;
    UIView *theBackgroundView = [[UIView alloc] initWithFrame:theBounds];
    CGRect theFrame = theView.frame;
    
    theFrame.origin.x = (CGRectGetWidth(theBounds) - CGRectGetWidth(theFrame)) / 2.0;
    theFrame.origin.y = (CGRectGetHeight(theBounds) - CGRectGetHeight(theFrame)) / 2.0;
    theView.frame = theFrame;
    [theFromViewController addChildViewController:theToViewController];
    theBackgroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
    theBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    theBackgroundView.alpha = 0.0;
    [theBackgroundView addSubview:theView];
    [theFromViewController.view addSubview:theBackgroundView];
    [UIView animateWithDuration:0.5
                     animations:^{
                         theBackgroundView.alpha = 1.0;
                     }
                     completion:^(BOOL inFinished) {
                         [theToViewController didMoveToParentViewController:theFromViewController];
                     }];
}

@end
