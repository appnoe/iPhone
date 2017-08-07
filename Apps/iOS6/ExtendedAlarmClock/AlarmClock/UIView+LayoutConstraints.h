//
//  UIView+LayoutConstraints.h
//  AlarmClock
//
//  Created by Clemens Wagner on 18.08.13.
//  Copyright (c) 2013 Cocoaneheads. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (LayoutConstraints)

- (NSArray *)constraintsForView:(UIView *)inView;
- (void)removeConstraintsForView:(UIView *)inView;

@end
