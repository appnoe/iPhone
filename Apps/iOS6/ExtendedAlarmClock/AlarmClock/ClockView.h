//
//  ClockView.h
//  AlarmClock
//
//  Created by Clemens Wagner on 17.07.13.
//  Copyright (c) 2013 Cocoaneheads. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    PartitionOfDialNone = 0,
    PartitionOfDialHours,
    PartitionOfDialMinutes
} PartitionOfDial;

@interface ClockView : UIView

@property (nonatomic, strong) NSDate *time;
@property (nonatomic, strong) NSCalendar *calendar;
@property (nonatomic) BOOL showDigits;
@property (nonatomic) PartitionOfDial partitionOfDial;
@property (nonatomic, strong) UIColor *dialColor;

- (void)startAnimation;
- (void)stopAnimation;

@end
