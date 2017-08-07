//
//  UIView+AlarmClock.swift
//  AlarmClock
//
//  Created by Clemens Wagner on 08.07.14.
//  Copyright (c) 2014 Clemens Wagner. All rights reserved.
//

import UIKit

var C_PI: CGFloat { return CGFloat(M_PI) }

public extension UIView {
    var midPoint: CGPoint {
        let theBounds = self.bounds;
        
        return CGPoint(x:theBounds.midX, y:theBounds.midY)
    }
    
    func pointWithRadius(inRadius:CGFloat, angle inAngle:CGFloat)->CGPoint {
        let theCenter = self.midPoint
        
        return CGPoint(x:theCenter.x + inRadius * CGFloat(sin(inAngle)), y:theCenter.y - inRadius * CGFloat(cos(inAngle)))
    }
    
    func angleWithPoint(inPoint: CGPoint) -> CGFloat {
        let theCenter = self.midPoint
        let theX = Float(inPoint.x - theCenter.x)
        let theY = Float(inPoint.y - theCenter.y)
        let theAngle = CGFloat(atan2f(theX, -theY))
        
        return theAngle < 0.0 ? theAngle + 2.0 * C_PI : theAngle
    }
}