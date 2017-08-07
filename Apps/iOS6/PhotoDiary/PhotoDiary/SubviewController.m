#import "SubviewController.h"

@implementation SubviewController

@synthesize delegate;

- (void)viewWillAppear:(BOOL)inAnimated {
    [super viewWillAppear:inAnimated];
    if([self.delegate respondsToSelector:@selector(subviewControllerWillAppear:)]) {
        [self.delegate subviewControllerWillAppear:self];
    }
}

- (void)viewWillDisappear:(BOOL)inAnimated {
    if([self.delegate respondsToSelector:@selector(subviewControllerWillDisappear:)]) {
        [self.delegate subviewControllerWillDisappear:self];
    }
    [super viewWillDisappear:inAnimated];
}

- (void)presentFromViewController:(UIViewController *)inViewController animated:(BOOL)inAnimated {
    CGRect theBounds = inViewController.view.bounds;
    UIView *theView = self.view;
    UIView *theBackgroundView = [[UIView alloc] initWithFrame:theBounds];
    CGRect theFrame = theView.frame;

    theFrame.origin.x = (CGRectGetWidth(theBounds) - CGRectGetWidth(theFrame)) / 2.0;
    theFrame.origin.y = (CGRectGetHeight(theBounds) - CGRectGetHeight(theFrame)) / 2.0;
    theView.frame = theFrame;
    [inViewController addChildViewController:self];
    theBackgroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
    theBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    theBackgroundView.alpha = 0.0;
    [theBackgroundView addSubview:theView];
    [inViewController.view addSubview:theBackgroundView];
    [UIView animateWithDuration:inAnimated ? 0.75 : 0.0
                     animations:^{
                         theBackgroundView.alpha = 1.0;
                     }
                     completion:^(BOOL inFinished) {
                         [self didMoveToParentViewController:inViewController];
                     }];
}

- (void)dismissAnimated:(BOOL)inAnimated {
    UIView *theView = self.view;
    UIView *theBackgroundView = theView.superview;
    
    [self willMoveToParentViewController:nil];
    [UIView animateWithDuration:inAnimated ? 0.75 : 0.0
                     animations:^{
                         theBackgroundView.alpha = 0.0;
                     }
                     completion:^(BOOL inFinished) {
                         [theBackgroundView removeFromSuperview];
                         [theView removeFromSuperview];
                         [self removeFromParentViewController];
                     }];
}

@end

@implementation SubviewSegue

- (void)perform {
    [self.destinationViewController presentFromViewController:self.sourceViewController animated:YES];
}

@end