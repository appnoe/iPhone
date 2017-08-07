//
//  FrontView.m
//  Games
//
//  Created by Clemens Wagner on 23.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FrontView.h"

const float kFrontViewAngles[] = { 120.0, 90.0, 144.0, 60.0, 102.857143, 45.0 };
NSString * const kFrontViewColors[] = { @"redColor", @"greenColor", @"blueColor" };

@implementation FrontView

@synthesize type;

- (void)setType:(NSUInteger)inType {
    if(type != inType) {
        type = inType;
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)inRect {
    NSUInteger theType = self.type;
    NSUInteger theCount = (theType / 3) % 6;
    SEL theColorSelector = NSSelectorFromString(kFrontViewColors[theType % 3]);
    float theBaseAngle = kFrontViewAngles[theCount] * M_PI / 180.0;
    CGSize theSize = self.frame.size;
    CGPoint theCenter = CGPointMake(theSize.width / 2.0, theSize.height / 2.0);
    CGFloat theRadius = theSize.height * 0.4;
    CGContextRef theContext = UIGraphicsGetCurrentContext();
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    UIColor *theColor = [[UIColor class] performSelector:theColorSelector];
#pragma clang diagnostic pop
    
    theCount += 3;
    CGContextSaveGState(theContext);
    CGContextSetFillColorWithColor(theContext, theColor.CGColor);
    CGContextMoveToPoint(theContext, theCenter.x, theCenter.y - theRadius);
    for(NSUInteger i = 1; i < theCount; ++i) {
        float theAngle = i * theBaseAngle;
        
        CGContextAddLineToPoint(theContext, 
                                theCenter.x + sin(theAngle) * theRadius, 
                                theCenter.y - cos(theAngle) * theRadius);
    }
    CGContextClosePath(theContext);
    CGContextFillPath(theContext);
    CGContextRestoreGState(theContext);
}

@end
