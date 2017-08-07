#import "AnimationViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface AnimationViewController()

@property (nonatomic, strong) IBOutlet UIView *squareView;
@property (nonatomic, strong) IBOutlet UISegmentedControl *curveSegment;

- (IBAction)flipAnimation:(id)inSender;

@end

@implementation AnimationViewController

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
