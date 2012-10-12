//
//  UIView+AlarmClock.m
//  AlarmClock
//
//  Created by Clemens Wagner on 30.01.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UIView+AlarmClock.h"

@implementation UIView(AlarmClock)

- (CGPoint)midPoint {
    CGRect theBounds = self.bounds;
    
    return CGPointMake(CGRectGetMidX(theBounds), CGRectGetMidY(theBounds));
}

- (CGPoint)pointWithRadius:(CGFloat)inRadius angle:(CGFloat)inAngle {
    CGPoint theCenter = [self midPoint];
    
    return CGPointMake(theCenter.x + inRadius * sin(inAngle), 
                       theCenter.y - inRadius * cos(inAngle));
}

@end
