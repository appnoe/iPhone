//
//  ClockView.h
//  AlarmClock
//
//  Created by Clemens Wagner on 17.07.13.
//  Copyright (c) 2013 Cocoaneheads. All rights reserved.
//

#import <UIKit/UIKit.h>

#if DEBUG
#define DEBUG_LOG(MESSAGE, ...) NSLog(MESSAGE, __VA_ARGS__)
#else
#define DEBUG_LOG(MESSAGE, ...) /**/
#endif

/*!
 Ein ClockView zeichnet ein Zifferblatt mit Uhrzeigern.
*/
@interface ClockView : UIView

/// Die angezeigte Zeit des Views
@property (nonatomic, strong) NSDate *time;

/// Der View berechnet die Zeigerstellung bezüglich dieses Kalenders.
@property (nonatomic, strong) NSCalendar *calendar;

/*!
 startet die kontinuierliche Aktualisierung der Zeit.
 
 @see time
 @see calendar
 */
- (void)startAnimation;
/*!
 stoppt die kontinuierliche Aktualisierung der Zeit.

 @see time
 @see calendar
 */
- (void)stopAnimation;

@end