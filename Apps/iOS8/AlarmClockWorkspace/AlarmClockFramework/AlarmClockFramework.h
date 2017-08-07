//
//  AlarmClockFramework.h
//  AlarmClockFramework
//
//  Created by Clemens Wagner on 16.08.14.
//  Copyright (c) 2014 Cocoaneheads. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for AlarmClockFramework.
FOUNDATION_EXPORT double AlarmClockFrameworkVersionNumber;

//! Project version string for AlarmClockFramework.
FOUNDATION_EXPORT const unsigned char AlarmClockFrameworkVersionString[];

#if DEBUG
#define DEBUG_LOG(MESSAGE, ...) NSLog(MESSAGE, __VA_ARGS__)
#else
#define DEBUG_LOG(MESSAGE, ...) /**/
#endif

#import <AlarmClockFramework/UIView+AlarmClock.h>
#import <AlarmClockFramework/ClockView.h>