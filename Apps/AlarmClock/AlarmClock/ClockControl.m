#import "ClockControl.h"
#import "UIView+AlarmClock.h"

@implementation ClockControl

@synthesize time;
@synthesize savedAngle;

- (void)dealloc {
    [super dealloc];
}

- (CGFloat)angle {
    return self.time * M_PI / 21600.0;
}

- (void)setAngle:(CGFloat)inAngle {
    self.time = 21600.0 * inAngle / M_PI;
}

- (void)drawRect:(CGRect)inRectangle {
    CGContextRef theContext = UIGraphicsGetCurrentContext();
    CGRect theBounds = self.bounds;
    CGPoint theCenter = [self midPoint];
    CGFloat theRadius = CGRectGetWidth(theBounds) / 2.0;
    CGPoint thePoint = [self pointWithRadius:theRadius * 0.7 angle:self.time * M_PI / 21600.0];

    CGContextSaveGState(theContext);
    CGContextSetRGBStrokeColor(theContext, 0.0, 0.0, 1.0, self.tracking ? 0.5 : 1.0);
    CGContextSetLineWidth(theContext, 7.0);
    CGContextSetLineCap(theContext, kCGLineCapRound);
    CGContextMoveToPoint(theContext, theCenter.x, theCenter.y);
    CGContextAddLineToPoint(theContext, thePoint.x, thePoint.y);
    CGContextStrokePath(theContext);    
    CGContextRestoreGState(theContext);
}

- (CGFloat)angleWithPoint:(CGPoint)inPoint {
    CGPoint theCenter = [self midPoint];
    CGFloat theX = inPoint.x - theCenter.x;
    CGFloat theY = inPoint.y - theCenter.y;
    CGFloat theAngle = atan2f(theX, -theY);
    
    return theAngle < 0 ? theAngle + 2 * M_PI : theAngle;
}

- (BOOL)pointInside:(CGPoint)inPoint withEvent:(UIEvent *)inEvent {
    CGFloat theAngle = [self angleWithPoint:inPoint];
    CGFloat theDelta = fabs(theAngle - self.angle);
    
    return theDelta < 2 * M_PI / 180.0;      
}

- (BOOL)beginTrackingWithTouch:(UITouch *)inTouch withEvent:(UIEvent *)inEvent {
    CGPoint thePoint = [inTouch locationInView:self];
    CGFloat theAngle = [self angleWithPoint:thePoint];
    
    self.savedAngle = self.angle;
    self.angle = theAngle;
    [self setNeedsDisplay];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    return YES;        
}

- (BOOL)continueTrackingWithTouch:(UITouch *)inTouch withEvent:(UIEvent *)inEvent {
    CGPoint thePoint = [inTouch locationInView:self];
    
    self.angle = [self angleWithPoint:thePoint];
    [self setNeedsDisplay];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)inTouch withEvent:(UIEvent *)inEvent {
    CGPoint thePoint = [inTouch locationInView:self];
    
    self.angle = [self angleWithPoint:thePoint];
    [self setNeedsDisplay];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)cancelTrackingWithEvent:(UIEvent *)inEvent {
    self.angle = self.savedAngle;
    [self setNeedsDisplay];
}

@end
