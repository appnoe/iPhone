//
//  UIView+LayoutConstraints.m
//  AlarmClock
//
//  Created by Clemens Wagner on 18.08.13.
//  Copyright (c) 2013 Cocoaneheads. All rights reserved.
//

#import "UIView+LayoutConstraints.h"

@implementation UIView (LayoutConstraints)

- (NSArray *)constraintsForView:(UIView *)inView {
    NSPredicate *thePredicate = [NSPredicate predicateWithFormat:@"firstItem == %@ OR secondItem == %@",
                                 inView, inView];
    return [self.constraints filteredArrayUsingPredicate:thePredicate];
}

- (void)removeConstraintsForView:(UIView *)inView {
    NSArray *theConstraints = [self constraintsForView:inView];

    [self removeConstraints:theConstraints];
}

@end
