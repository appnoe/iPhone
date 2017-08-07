//
//  ClockView.m
//  AlarmClock
//
//  Created by Clemens Wagner on 17.07.13.
//  Copyright (c) 2013 Cocoaneheads. All rights reserved.
//

#import "ClockView.h"
#import "UIView+AlarmClock.h"

@implementation ClockView

- (void)dealloc {
    [self stopAnimation];
}

- (void)drawClockHandWithRadius:(CGFloat)inRadius angle:(CGFloat)inAngle lineWidth:(CGFloat)inLineWidth {
    CGContextRef theContext = UIGraphicsGetCurrentContext();
    CGPoint theCenter = [self midPoint];
    CGPoint thePoint = [self pointWithRadius:inRadius * 0.7 angle:inAngle];

    CGContextSetLineWidth(theContext, inLineWidth);
    CGContextMoveToPoint(theContext, theCenter.x, theCenter.y);
    CGContextAddLineToPoint(theContext, thePoint.x, thePoint.y);
    CGContextStrokePath(theContext);
}

- (void)drawClockHands {
    CGContextRef theContext = UIGraphicsGetCurrentContext();
    CGFloat theRadius = CGRectGetWidth(self.bounds) / 2.0;
    NSDateComponents *theComponents = [self.calendar components:NSCalendarUnitHour |
                                       NSCalendarUnitMinute | NSCalendarUnitSecond
                                                       fromDate:self.time];
    CGFloat theSecond = theComponents.second * M_PI / 30.0;
    CGFloat theMinute = theComponents.minute * M_PI / 30.0;
    CGFloat theHour = (theComponents.hour + theComponents.minute / 60.0) * M_PI / 6.0;

    CGContextSetRGBStrokeColor(theContext, 0.25, 0.25, 0.25, 1.0);
    CGContextSetLineCap(theContext, kCGLineCapButt);
    [self drawClockHandWithRadius:theRadius * 0.7 angle:theHour lineWidth:theRadius / 20.0];
    [self drawClockHandWithRadius:theRadius * 0.9 angle:theMinute lineWidth:theRadius / 40.0];
    CGContextSetRGBStrokeColor(theContext, 1.0, 0.0, 0.0, 1.0);
    [self drawClockHandWithRadius:theRadius * 0.95 angle:theSecond lineWidth:theRadius / 80.0];
}


- (void)drawRect:(CGRect)inRectangle {
    CGContextRef theContext = UIGraphicsGetCurrentContext();
    CGRect theBounds = self.bounds;
    CGFloat theRadius = CGRectGetWidth(theBounds) / 2.0;

    CGContextSaveGState(theContext);
    CGContextSetRGBFillColor(theContext, 1.0, 1.0, 1.0, 1.0);
    CGContextAddEllipseInRect(theContext, theBounds);
    CGContextFillPath(theContext);
    CGContextAddEllipseInRect(theContext, theBounds);
    CGContextClip(theContext);
    if([self respondsToSelector:@selector(tintColor)]) {
        UIColor *theColor = self.tintColor;

        CGContextSetStrokeColorWithColor(theContext, theColor.CGColor);
        CGContextSetFillColorWithColor(theContext, theColor.CGColor);
    }
    else {
        CGContextSetRGBStrokeColor(theContext, 0.25, 0.25, 0.25, 1.0);
        CGContextSetRGBFillColor(theContext, 0.25, 0.25, 0.25, 1.0);
    }
    CGContextSetLineWidth(theContext, theRadius / 20.0);
    CGContextSetLineCap(theContext, kCGLineCapRound);
    for(NSInteger i = 0; i < 60; ++i) {
        CGFloat theAngle = i * M_PI / 30.0;

        if(i % 5 == 0) {
            CGFloat theInnerRadius = theRadius * (i % 15 == 0 ? 0.7 : 0.8);
            CGPoint theInnerPoint = [self pointWithRadius:theInnerRadius angle:theAngle];
            CGPoint theOuterPoint = [self pointWithRadius:theRadius angle:theAngle];
            CGContextMoveToPoint(theContext, theInnerPoint.x, theInnerPoint.y);
            CGContextAddLineToPoint(theContext, theOuterPoint.x, theOuterPoint.y);
            CGContextStrokePath(theContext);
        }
        else {
            CGPoint thePoint = [self pointWithRadius:theRadius * 0.95 angle:theAngle];
            CGContextAddArc(theContext,thePoint.x, thePoint.y, theRadius / 40.0, 0.0, 2 * M_PI, YES);
            CGContextFillPath(theContext);
        }
    }
    [self drawClockHands];
    CGContextRestoreGState(theContext);
}

- (void)tintColorDidChange {
    [super tintColorDidChange];
    [self setNeedsDisplay];
}




@end
