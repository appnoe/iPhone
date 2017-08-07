//
//  UIView+AlarmClock.h
//  AlarmClock
//
//  Created by Clemens Wagner on 21.07.13.
//  Copyright (c) 2013 Cocoaneheads. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (AlarmClock)

- (CGPoint)midPoint;
- (CGPoint)pointWithRadius:(CGFloat)inRadius angle:(CGFloat)inAngle;
- (CGFloat)angleWithPoint:(CGPoint)inPoint;

@end