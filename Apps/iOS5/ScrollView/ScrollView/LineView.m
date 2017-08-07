//
//  LineView.m
//  ScrollView
//
//  Created by Clemens Wagner on 25.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LineView.h"
#import <QuartzCore/QuartzCore.h>

@implementation LineView

@synthesize startPoint;
@synthesize endPoint;

+ (id)layerClass {
    return [CATiledLayer class];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    CATiledLayer *theLayer = (CATiledLayer *)self.layer;
    
    theLayer.levelsOfDetail = 1;
    theLayer.levelsOfDetailBias = 2;
}

- (BOOL)shouldCancelContentTouches {
    return NO;
}

- (void)drawRect:(CGRect)inRect {
    UIBezierPath *thePath = [UIBezierPath bezierPath];
    
    CGContextSetAllowsAntialiasing(UIGraphicsGetCurrentContext(), YES);
    [[UIColor redColor] setStroke];
    [thePath moveToPoint:self.startPoint];
    [thePath addLineToPoint:self.endPoint];
    [thePath stroke];
}

- (void)touchesBegan:(NSSet *)inTouches withEvent:(UIEvent *)inEvent {
    UITouch *theTouch = [inTouches anyObject];
    
    self.startPoint = [theTouch locationInView:self];
}

- (void)touchesMoved:(NSSet *)inTouches withEvent:(UIEvent *)inEvent {
    UITouch *theTouch = [inTouches anyObject];
    
    self.endPoint = [theTouch locationInView:self];
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)inTouches withEvent:(UIEvent *)inEvent {
    UITouch *theTouch = [inTouches anyObject];
    
    self.endPoint = [theTouch locationInView:self];
    [self setNeedsDisplay];    
}

@end
