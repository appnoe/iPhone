//
//  UINavigationController+BarManagement.h
//  PhotoDiary
//
//  Created by Clemens Wagner on 14.09.13.
//  Copyright (c) 2013 Cocoaneheads. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (BarManagement)

@property (nonatomic) BOOL barsHidden;

- (void)setBarsHidden:(BOOL)inHidden animated:(BOOL)inAnimated;
- (void)hideBarsWithDelay:(NSTimeInterval)inDelay;
- (void)cancelHideBars;

@end
