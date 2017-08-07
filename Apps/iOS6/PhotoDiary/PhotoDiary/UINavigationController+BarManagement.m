//
//  UINavigationController+BarManagement.m
//  PhotoDiary
//
//  Created by Clemens Wagner on 14.09.13.
//  Copyright (c) 2013 Cocoaneheads. All rights reserved.
//

#import "UINavigationController+BarManagement.h"

@implementation UINavigationController (BarManagement)

- (void)hideBarsWithDelay:(NSTimeInterval)inDelay {
    [self performSelector:@selector(hideBars) withObject:nil afterDelay:inDelay];
}

- (void)cancelHideBars {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideBars) object:nil];
}

- (void)hideBars {
    [self setBarsHidden:YES animated:YES];
}

- (BOOL)barsHidden {
    return self.navigationBarHidden && self.toolbarHidden;
}

- (void)setBarsHidden:(BOOL)inHidden {
    [self setBarsHidden:inHidden animated:NO];
}

- (void)setBarsHidden:(BOOL)inHidden animated:(BOOL)inAnimated {
    [self cancelHideBars];
    [self setNavigationBarHidden:inHidden animated:inAnimated];
    [self setToolbarHidden:inHidden animated:inAnimated];
}

@end
