//
//  UIView+AlarmClock.h
//  AlarmClock
//
//  Created by Clemens Wagner on 21.07.13.
//  Copyright (c) 2013 Cocoaneheads. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (AlarmClock)

/*!
 liefert den Mittelpunkt des Views bezüglich des Bounds-Rechtecks.
 
 @returns der Mittelpunkt relativ zum View
*/
- (CGPoint)midPoint;
/*!
 berechnet einen Punkt, der in einem vorgegebenen Abstand und einem Winkel im Uhrzeigersinn vom Mittelpunkt liegt. Die (positive) y-Achse entspricht dabei dem Winkel 0.

 @param inRadius die Entfernung des Punktes zum Mittelpunkt
 @param inAngle der Winkel des Punktes im Bogenmaß
 @returns der berechnete Punkt
 */
- (CGPoint)pointWithRadius:(CGFloat)inRadius angle:(CGFloat)inAngle;


/*!
 berechnet den Winkel zu der Linie, die sich aus der Verbindung des Mittelpunktes mit dem angegebenen Punkt ergibt.
 
 @see pointWithRadius:angle:
 */
- (CGFloat)angleWithPoint:(CGPoint)inPoint;

@end