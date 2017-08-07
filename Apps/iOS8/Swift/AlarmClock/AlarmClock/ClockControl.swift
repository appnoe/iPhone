//
//  ClockControl.swift
//  AlarmClock
//
//  Created by Clemens Wagner on 05.08.14.
//  Copyright (c) 2014 Clemens Wagner. All rights reserved.
//

import UIKit

class ClockControl: UIControl {
    var time : NSTimeInterval = 0.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    private var savedAngle:CGFloat = 0.0
    private var angle : CGFloat {
        get {
            return CGFloat(time * M_PI / 21600.0)
        }
        set {
            time = 21600.0 * NSTimeInterval(newValue) / M_PI
        }
    }
    
    override func pointInside(inPoint: CGPoint, withEvent inEvent: UIEvent!) -> Bool {
        let theAngle = angleWithPoint(inPoint)
        let theDelta = CGFloat(fabsf(Float(theAngle - angle)))
        
        return theDelta < 4.0 * C_PI / 180.0
    }
    
    func updateAngleWithTouch(inTouch:UITouch!) {
        let thePoint = inTouch.locationInView(self)
        
        angle = angleWithPoint(thePoint)
        sendActionsForControlEvents(UIControlEvents.ValueChanged)
    }
    
    override func beginTrackingWithTouch(inTouch: UITouch, withEvent inEvent: UIEvent) -> Bool {
        savedAngle = angle
        updateAngleWithTouch(inTouch)
        return true
    }
    
    override func continueTrackingWithTouch(inTouch: UITouch, withEvent inEvent: UIEvent) -> Bool {
        updateAngleWithTouch(inTouch)
        return true
    }
    
    override func endTrackingWithTouch(inTouch: UITouch, withEvent inEvent: UIEvent) {
        updateAngleWithTouch(inTouch)
    }
    
    override func cancelTrackingWithEvent(inEvent: UIEvent!) {
        angle = savedAngle
    }
    
    override func drawRect(inRect: CGRect) {
        let theContext = UIGraphicsGetCurrentContext()
        let theBounds = bounds
        let theCenter = midPoint
        let theRadius = theBounds.width / 2.0
        let thePoint = pointWithRadius(0.7 * theRadius, angle:CGFloat(time) * C_PI / 21600)
        var theColor = tintColor
        
        if(tracking) {
            theColor = theColor.colorWithAlphaComponent(0.5)
        }
        CGContextSaveGState(theContext)
        CGContextSetStrokeColorWithColor(theContext, theColor.CGColor)
        CGContextSetLineWidth(theContext, 8.0)
        CGContextSetLineCap(theContext, kCGLineCapRound)
        CGContextMoveToPoint(theContext, theCenter.x, theCenter.y)
        CGContextAddLineToPoint(theContext, thePoint.x, thePoint.y)
        CGContextStrokePath(theContext)
        CGContextRestoreGState(theContext)
    }
}