//
//  ClockControl.h
//  AlarmClock
//
//  Created by Clemens Wagner on 21.07.13.
//  Copyright (c) 2013 Cocoaneheads. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 Ein ClockControl verwaltet einen Zeiger zum Einstellen der Weckzeit.
 
 @see ClockView
 */
@interface ClockControl : UIControl

/*!
 enthält die Weckzeit in Sekunden.
*/
@property (nonatomic) NSTimeInterval time;

@end