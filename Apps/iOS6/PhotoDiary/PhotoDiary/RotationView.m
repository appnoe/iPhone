#import "RotationView.h"

@implementation RotationView

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect theBounds = self.bounds;
    CGRect theFirstFrame = [self.subviews[0] frame];
    UIView *theSecondView = self.subviews[1];
    CGRect theSecondFrame = theSecondView.frame;
    
    if(CGRectGetWidth(theBounds) < CGRectGetHeight(theBounds)) {
        theSecondFrame.origin.x = 0.0;
        theSecondFrame.origin.y = CGRectGetMaxY(theFirstFrame);
        theSecondFrame.size.width = CGRectGetWidth(theBounds);
        theSecondFrame.size.height = CGRectGetHeight(theBounds) - CGRectGetMaxY(theFirstFrame);
    }
    else {
        theSecondFrame.origin.x = CGRectGetMaxX(theFirstFrame);
        theSecondFrame.origin.y = 0.0;
        theSecondFrame.size.width = CGRectGetWidth(theBounds) - CGRectGetMaxX(theFirstFrame);
        theSecondFrame.size.height = CGRectGetHeight(theBounds);        
    }
    theSecondView.frame = theSecondFrame;
}

@end