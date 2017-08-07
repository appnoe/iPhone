//
//  AbstractClockView.h
//  
//
//  Created by Clemens Wagner on 01.09.13.
//
//

#import <UIKit/UIKit.h>

@interface AbstractClockView : UIView

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
