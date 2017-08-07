#import "RotationView.h"

@implementation RotationView

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect theFrame = self.frame;
    CGRect theFirstFrame = [[self.subviews objectAtIndex:0] frame];
    UIView *theSecondView = [self.subviews objectAtIndex:1];
    CGRect theSecondFrame = theSecondView.frame;
    
    if(CGRectGetWidth(theFrame) < CGRectGetHeight(theFrame)) {
        theSecondFrame.origin.x = 0.0;
        theSecondFrame.origin.y = CGRectGetMaxY(theFirstFrame);
        theSecondFrame.size.width = CGRectGetWidth(theFrame);
        theSecondFrame.size.height = CGRectGetHeight(theFrame) - CGRectGetMaxY(theFirstFrame);
    }
    else {
        theSecondFrame.origin.x = CGRectGetMaxX(theFirstFrame);
        theSecondFrame.origin.y = 0.0;
        theSecondFrame.size.width = CGRectGetWidth(theFrame) - CGRectGetMaxX(theFirstFrame);
        theSecondFrame.size.height = CGRectGetHeight(theFrame);        
    }
    theSecondView.frame = theSecondFrame;
}

@end
