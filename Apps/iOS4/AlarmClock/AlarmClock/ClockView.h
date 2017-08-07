//
//  ClockView.h
//  AlarmClock
//
//  Created by Clemens Wagner on 17.07.13.
//  Copyright (c) 2013 Cocoaneheads. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 zeichnet ein Zifferblatt mit Uhrzeigern.
*/
@interface ClockView : UIView

@property (nonatomic, strong) NSDate *time;
@property (nonatomic, strong) NSCalendar *calendar;

- (void)startAnimation;
- (void)stopAnimation;

@end
