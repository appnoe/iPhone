//
//  ClockView.m
//  AlarmClock
//
//  Created by Clemens Wagner on 17.07.13.
//  Copyright (c) 2013 Cocoaneheads. All rights reserved.
//

#import "ClockView.h"
#import "UIView+AlarmClock.h"

@interface ClockView()

@property(nonatomic, strong) NSTimer *timer;

@end

@implementation ClockView

@synthesize time;
@synthesize calendar;
@synthesize timer;

- (id)initWithFrame:(CGRect)inFrame {
    self = [super initWithFrame:inFrame];
    if(self) {
        self.calendar = [NSCalendar currentCalendar];
        self.time = [NSDate date];
    }
    return self;
}

- (void)dealloc {
    [self stopAnimation];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.calendar = [NSCalendar currentCalendar];
    self.time = [NSDate date];
}

- (void)drawDigits {
    CGFloat theRadius = CGRectGetWidth(self.bounds) / 2.0;
    UIFont *theFont = [UIFont systemFontOfSize:24];
    CGRect theFrame;

    [[UIColor darkGrayColor] set];
    theRadius *= self.partitionOfDial == PartitionOfDialNone ?
    0.9 : 0.6;
    for(int i = 1; i <= 12; ++i) {
        NSString *theText =
        [NSString stringWithFormat:@"%d", i];

        theFrame.origin = [self pointWithRadius:theRadius
                                          angle:i * M_PI / 6];
        theFrame.size = [theText sizeWithFont:theFont];
        theFrame = CGRectOffset(theFrame,
                                -CGRectGetWidth(theFrame) / 2.0,
                                -CGRectGetHeight(theFrame) / 2.0);
        [theText drawInRect:theFrame withFont:theFont];
    }
}

- (void)drawClockHands {
    CGContextRef theContext = UIGraphicsGetCurrentContext();
    CGPoint theCenter = [self midPoint];
    CGFloat theRadius = CGRectGetWidth(self.bounds) / 2.0;
    NSDateComponents *theComponents = [self.calendar components:NSCalendarUnitHour |
                                       NSCalendarUnitMinute | NSCalendarUnitSecond
                                                       fromDate:self.time];
    CGFloat theSecond = theComponents.second * M_PI / 30.0;
    CGFloat theMinute = theComponents.minute * M_PI / 30.0;
    CGFloat theHour = (theComponents.hour + theComponents.minute / 60.0) * M_PI / 6.0;
    // Stundenzeiger zeichnen
    CGPoint thePoint = [self pointWithRadius:theRadius * 0.7 angle:theHour];

    CGContextSetRGBStrokeColor(theContext, 0.25, 0.25, 0.25, 1.0);
    CGContextSetLineWidth(theContext, theRadius / 20.0);
    CGContextSetLineCap(theContext, kCGLineCapButt);
    CGContextMoveToPoint(theContext, theCenter.x, theCenter.y);
    CGContextAddLineToPoint(theContext, thePoint.x, thePoint.y);
    CGContextStrokePath(theContext);
    // Minutenzeiger zeichnen
    thePoint = [self pointWithRadius:theRadius * 0.9 angle:theMinute];
    CGContextSetLineWidth(theContext, theRadius / 40.0);
    CGContextMoveToPoint(theContext, theCenter.x, theCenter.y);
    CGContextAddLineToPoint(theContext, thePoint.x, thePoint.y);
    CGContextStrokePath(theContext);
    // Sekundenzeiger zeichnen
    thePoint = [self pointWithRadius:theRadius * 0.95 angle:theSecond];
    CGContextSetLineWidth(theContext, theRadius / 80.0);
    CGContextSetRGBStrokeColor(theContext, 1.0, 0.0, 0.0, 1.0);
    CGContextMoveToPoint(theContext, theCenter.x, theCenter.y);
    CGContextAddLineToPoint(theContext, thePoint.x, thePoint.y);
    CGContextStrokePath(theContext);
}


- (void)drawRect:(CGRect)inRectangle {
    CGContextRef theContext = UIGraphicsGetCurrentContext();
    CGRect theBounds = self.bounds;
    CGFloat theRadius = CGRectGetWidth(theBounds) / 2.0;

    CGContextSaveGState(theContext);
    [self.dialColor setFill];
    CGContextAddEllipseInRect(theContext, theBounds);
    CGContextFillPath(theContext);
    CGContextAddEllipseInRect(theContext, theBounds);
    CGContextClip(theContext);
    CGContextSetStrokeColorWithColor(theContext, self.tintColor.CGColor);
    CGContextSetFillColorWithColor(theContext, self.tintColor.CGColor);
    CGContextSetLineWidth(theContext, theRadius / 20.0);
    CGContextSetLineCap(theContext, kCGLineCapRound);
    if(self.partitionOfDial != PartitionOfDialNone) {
        // Zifferneinteilung zeichnen
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
            else if(self.partitionOfDial == PartitionOfDialMinutes) {
                // Minuteneinteilungsstrich darstellen
                CGPoint thePoint = [self pointWithRadius:theRadius * 0.95 angle:theAngle];
                CGContextAddArc(theContext,thePoint.x, thePoint.y, theRadius / 40.0, 0.0, 2 * M_PI, YES);
                CGContextFillPath(theContext);
            }
        }
    }
    if(self.showDigits) {
        [self drawDigits];
    }
    [self drawClockHands];
    CGContextRestoreGState(theContext);
}

- (void)startAnimation {
    if(self.timer == nil) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                                      target:self
                                                    selector:@selector(updateTime:)
                                                    userInfo:nil
                                                     repeats:YES];
    }
}

- (void)stopAnimation {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)updateTime:(NSTimer *)inTimer {
    self.time = [NSDate date];
    [self setNeedsDisplay];
}

@end
