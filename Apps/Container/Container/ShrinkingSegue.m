//
//  ShrinkingSegue.m
//  Container
//
//  Created by Clemens Wagner on 31.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ShrinkingSegue.h"

@implementation ShrinkingSegue

- (void)perform {
    UIViewController *theFromViewController = self.sourceViewController;
    UIViewController *theToViewController = self.destinationViewController;
    CGRect theBounds = theToViewController.view.bounds;
    UIView *theView = theFromViewController.view;
    UIView *theBackgroundView = theView.superview;
    
    [theFromViewController willMoveToParentViewController:nil];
    [UIView animateWithDuration:1.0 
                     animations:^{
                         theBackgroundView.alpha = 0.0;
                         theView.transform = CGAffineTransformScale(CGAffineTransformMakeTranslation(-CGRectGetMidX(theBounds), CGRectGetMidY(theBounds)), 1.0 / 32.0, 1.0 / 32.0);
                     }
                     completion:^(BOOL inFinished) {
                         [theBackgroundView removeFromSuperview];
                         [theView removeFromSuperview];
                         [theFromViewController removeFromParentViewController];
                     }];
}

@end
