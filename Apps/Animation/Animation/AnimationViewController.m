#import "AnimationViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation AnimationViewController
@synthesize squareView;
@synthesize curveSegment;

- (void)dealloc {
    self.squareView = nil;
    self.curveSegment = nil;
    [super dealloc];
}

- (void)viewDidUnload {
    self.squareView = nil;
    self.curveSegment = nil;
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)inInterfaceOrientation {
    return inInterfaceOrientation == UIInterfaceOrientationPortrait;
}

- (IBAction)flipAnimation:(id)inSender {
    if([inSender isSelected]) {
        [self.squareView.layer removeAllAnimations];
        [inSender setSelected:NO];
    }
    else {
        UIViewAnimationOptions theCurve = self.curveSegment.selectedSegmentIndex << 16;
        
        [inSender setSelected:YES];
        [UIView animateWithDuration:4.0 
                              delay:0.0 
                            options:theCurve | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse
                         animations:^{
                             self.squareView.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(1.25 * M_PI), 2.0, 2.0);
                         }
                         completion:^(BOOL inFinished) {
                             NSLog(@"finished=%d", inFinished);
                             self.squareView.transform = CGAffineTransformIdentity;
                             [inSender setSelected:NO];
                         }];
    }
}

@end
