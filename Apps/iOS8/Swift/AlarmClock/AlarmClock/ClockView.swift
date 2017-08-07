//
//  ClockView.swift
//  AlarmClock
//
//  Created by Clemens Wagner on 21.06.14.
//  Copyright (c) 2014 Clemens Wagner. All rights reserved.
//

import UIKit

@IBDesignable
class ClockView: UIView {
    var time : NSDate = NSDate() {
    didSet {
        setNeedsDisplay()
    }
    }
    var calendar : NSCalendar = NSCalendar.currentCalendar()
    @IBInspectable var secondHandColor : UIColor?
    var timer : NSTimer?
    
    func startAnimation() {
        if timer == nil {
            timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector:"updateTime:", userInfo: nil, repeats: true)
        }
    }

    func stopAnimation() {
        timer?.invalidate()
        timer = nil
    }
    
    func updateTime(inTimer:NSTimer) {
        time = NSDate()
    }

    override func tintColorDidChange() {
        super.tintColorDidChange()
        setNeedsDisplay()
    }
    
    override func drawRect(inRect: CGRect) {
        let theContext = UIGraphicsGetCurrentContext()
        let theBounds = bounds
        let theRadius = CGFloat(theBounds.width) / 2
        
        CGContextSaveGState(theContext)
        CGContextSetRGBFillColor(theContext, 1.0, 1.0, 1.0, 1.0)
        CGContextAddEllipseInRect(theContext, theBounds)
        CGContextFillPath(theContext)
        CGContextAddEllipseInRect(theContext, theBounds)
        CGContextClip(theContext)
        CGContextSetStrokeColorWithColor(theContext, tintColor.CGColor)
        CGContextSetFillColorWithColor(theContext, tintColor.CGColor)
        CGContextSetLineWidth(theContext, theRadius / 20)
        CGContextSetLineCap(theContext, kCGLineCapRound)
        for i in 0..<60 {
            let theAngle = CGFloat(i) * C_PI / 30.0
            
            if i % 5 == 0 {
                let theInnerRadius = theRadius * (i % 15 == 0 ? 0.7 : 0.8)
                let theInnerPoint = pointWithRadius(theInnerRadius, angle:theAngle)
                let theOuterPoint = pointWithRadius(theRadius, angle:theAngle)
                
                CGContextMoveToPoint(theContext, theInnerPoint.x, theInnerPoint.y)
                CGContextAddLineToPoint(theContext, theOuterPoint.x, theOuterPoint.y)
                CGContextStrokePath(theContext)
            }
            else {
                let thePoint = pointWithRadius(theRadius * 0.95, angle:theAngle)
                
                CGContextAddArc(theContext, thePoint.x, thePoint.y, theRadius / 40.0, 0, 2 * C_PI, 1)
                CGContextFillPath(theContext)
            }
        }
        drawClockHands()
        CGContextRestoreGState(theContext)
    }
    
    func drawClockHands() {
        let theContext = UIGraphicsGetCurrentContext()
        let theCenter = midPoint
        let theRadius = bounds.width / 2.0
        let theComponents = calendar.components(NSCalendarUnit.HourCalendarUnit |
            NSCalendarUnit.MinuteCalendarUnit | NSCalendarUnit.SecondCalendarUnit, fromDate:time)
        let theSecond = CGFloat(theComponents.second) * C_PI / 30.0
        let theMinute = CGFloat(theComponents.minute) * C_PI / 30.0
        let theHour = (CGFloat(theComponents.hour) + CGFloat(theComponents.minute) / 60.0) * C_PI / 6.0
        // Stundenzeiger zeichnen
        var thePoint = pointWithRadius(theRadius * 0.7, angle:theHour)
        
        CGContextSetRGBStrokeColor(theContext, 0.25, 0.25, 0.25, 1.0)
        CGContextSetLineWidth(theContext, theRadius / 20.0)
        CGContextSetLineCap(theContext, kCGLineCapButt)
        CGContextMoveToPoint(theContext, theCenter.x, theCenter.y)
        CGContextAddLineToPoint(theContext, thePoint.x, thePoint.y)
        CGContextStrokePath(theContext)
        // Minutenzeiger zeichnen
        thePoint = pointWithRadius(theRadius * 0.9, angle:theMinute)
        CGContextSetLineWidth(theContext, theRadius / 40.0)
        CGContextMoveToPoint(theContext, theCenter.x, theCenter.y)
        CGContextAddLineToPoint(theContext, thePoint.x, thePoint.y)
        CGContextStrokePath(theContext)
        // Sekundenzeiger zeichnen
        let theColor = secondHandColor == nil ? UIColor.redColor() : secondHandColor!
        
        thePoint = pointWithRadius(theRadius * 0.95, angle:theSecond)
        CGContextSetLineWidth(theContext, theRadius / 80.0)
        CGContextSetStrokeColorWithColor(theContext, theColor.CGColor)
        CGContextMoveToPoint(theContext, theCenter.x, theCenter.y)
        CGContextAddLineToPoint(theContext, thePoint.x, thePoint.y)
        CGContextStrokePath(theContext)
    }
}