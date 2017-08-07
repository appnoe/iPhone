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

- (void)dismissSubviewAnimated:(BOOL)inAnimated {
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