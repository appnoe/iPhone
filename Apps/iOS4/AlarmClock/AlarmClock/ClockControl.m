//
//  ClockControl.m
//  AlarmClock
//
//  Created by Clemens Wagner on 21.07.13.
//  Copyright (c) 2013 Cocoaneheads. All rights reserved.
//

#import "ClockControl.h"
#import "UIView+AlarmClock.h"

@interface ClockControl()

@property (nonatomic) CGFloat savedAngle;

@end

@implementation ClockControl

@synthesize time;
@synthesize savedAngle;

- (id)initWithFrame:(CGRect)inFrame {
    self = [super initWithFrame:inFrame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"time"];
}

- (void)setup {
    [self addObserver:self forKeyPath:@"time" options:0 context:nil];
}

- (void)observeValueForKeyPath:(NSString *)inKeyPath ofObject:(id)inObject change:(NSDictionary *)inChange context:(void *)inContext {
    [self setNeedsDisplay];
}

- (CGFloat)angle {
    return self.time * M_PI / 21600.0;
}

- (void)setAngle:(CGFloat)inAngle {
    self.time = 21600.0 * inAngle / M_PI;
}

- (void)setTime:(NSTimeInterval)inTime {
    time = inTime;
    [self setNeedsDisplay];
}

- (BOOL)pointInside:(CGPoint)inPoint withEvent:(UIEvent *)inEvent {
    CGFloat theAngle = [self angleWithPoint:inPoint];
    CGFloat theDelta = fabs(theAngle - self.angle);

    return theDelta < 4.0 * M_PI / 180.0;
}

- (void)updateAngleWithTouch:(UITouch *)inTouch {
    CGPoint thePoint = [inTouch locationInView:self];

    self.angle = [self angleWithPoint:thePoint];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (BOOL)beginTrackingWithTouch:(UITouch *)inTouch withEvent:(UIEvent *)inEvent {
    self.savedAngle = self.angle;
    [self updateAngleWithTouch:inTouch];
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)inTouch withEvent:(UIEvent *)inEvent {
    [self updateAngleWithTouch:inTouch];
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)inTouch withEvent:(UIEvent *)inEvent {
    [self updateAngleWithTouch:inTouch];
}

- (void)cancelTrackingWithEvent:(UIEvent *)inEvent {
    self.angle = self.savedAngle;
}

- (void)drawRect:(CGRect)inRectangle {
    CGContextRef theContext = UIGraphicsGetCurrentContext();
    CGRect theBounds = self.bounds;
    CGPoint theCenter = [self midPoint];
    CGFloat theRadius = CGRectGetWidth(theBounds) / 2.0;
    CGPoint thePoint = [self pointWithRadius:theRadius * 0.7 angle:self.time * M_PI / 21600.0];
    UIColor *theColor = [UIColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:1.0];

    if(self.tracking) {
        theColor = [theColor colorWithAlphaComponent:0.5];
    }
    CGContextSaveGState(theContext);
    CGContextSetStrokeColorWithColor(theContext, theColor.CGColor);
    CGContextSetLineWidth(theContext, 8.0);
    CGContextSetLineCap(theContext, kCGLineCapRound);
    CGContextMoveToPoint(theContext, theCenter.x, theCenter.y);
    CGContextAddLineToPoint(theContext, thePoint.x, thePoint.y);
    CGContextStrokePath(theContext);
    CGContextRestoreGState(theContext);
}

@end