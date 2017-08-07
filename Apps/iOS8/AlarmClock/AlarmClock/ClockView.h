//
//  ClockView.h
//  AlarmClock
//
//  Created by Clemens Wagner on 17.07.13.
//  Copyright (c) 2013 Cocoaneheads. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 Ein ClockView zeichnet ein Zifferblatt mit Uhrzeigern.
*/
IB_DESIGNABLE
@interface ClockView : UIView

/// Die angezeigte Zeit des Views
@property (nonatomic, strong) NSDate *time;

/// Der View berechnet die Zeigerstellung bezüglich dieses Kalenders.
@property (nonatomic, strong) NSCalendar *calendar;

/// Enthält die Farbe des Sekundenzeigers.
@property (nonatomic, strong) IBInspectable UIColor *secondHandColor;

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