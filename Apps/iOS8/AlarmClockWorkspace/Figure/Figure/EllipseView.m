//
//  Ellipse.m
//  Figure
//
//  Created by Clemens Wagner on 19.08.14.
//  Copyright (c) 2014 Clemens Wagner. All rights reserved.
//

#import "EllipseView.h"

@implementation EllipseView

- (void)drawRect:(CGRect)inRect {
    CGContextRef theContext = UIGraphicsGetCurrentContext();
    CGRect theBounds = self.bounds;
    
    CGContextSaveGState(theContext);
    CGContextSetFillColorWithColor(theContext, self.tintColor.CGColor);
    CGContextAddEllipseInRect(theContext, theBounds);
    CGContextFillPath(theContext);
    CGContextRestoreGState(theContext);    
}

@end
