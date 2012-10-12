//
//  Toolbar.m
//  Bars
//
//  Created by Clemens Wagner on 26.03.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Toolbar.h"

@implementation Toolbar

- (void)drawRect:(CGRect)inRect {
    CGSize theSize = self.bounds.size;
    CGFloat theX = 0;
    CGContextRef theContext = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(theContext);
    CGContextSetRGBFillColor(theContext, 1.0, 1.0, 1.0, 1.0);
    CGContextFillRect(theContext, self.bounds);
    CGContextSetRGBFillColor(theContext, 0.0, 0.0, 0.0, 1.0);
    while(theX < theSize.width) {
        CGContextMoveToPoint(theContext, theX, 0.0);
        CGContextAddLineToPoint(theContext, theX + theSize.height, 0.0);
        CGContextAddLineToPoint(theContext, theX, theSize.height);
        CGContextAddLineToPoint(theContext, theX - theSize.height, theSize.height);
        CGContextClosePath(theContext);
        CGContextFillPath(theContext);
        theX += 2 * theSize.height;
    }
    CGContextRestoreGState(theContext);
}

@end
