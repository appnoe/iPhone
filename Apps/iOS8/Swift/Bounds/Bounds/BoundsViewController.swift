//
//  BoundsViewController.swift
//  Bounds
//
//  Created by Clemens Wagner on 22.06.14.
//  Copyright (c) 2014 Clemens Wagner. All rights reserved.
//

import UIKit

class BoundsViewController: UIViewController {
    @IBOutlet var boundsView: UIView
    @IBOutlet var xSlider: UISlider
    @IBOutlet var ySlider: UISlider
    
    @IBOutlet var xLabel: UILabel
    @IBOutlet var yLabel: UILabel

    override func viewWillAppear(inAnimated: Bool) {
        super.viewWillAppear(inAnimated)
        updateX()
        updateY()
    }
    
    func updateX() {
        let theView = self.boundsView
        let theFrame = theView.frame
        let theWidth = theFrame.width
        var theBounds = theView.bounds
        
        theBounds = CGRect(x: self.xSlider.value * theWidth, y: theBounds.minY, width: theBounds.width, height: theBounds.height)
        theView.bounds = theBounds
        theView.frame = theFrame
        self.xLabel.text = NSString(format:"%.f", theBounds.minX)
    }
    
    func updateY() {
        let theView = self.boundsView
        let theFrame = theView.frame
        let theHeight = CGRectGetHeight(theFrame)
        var theBounds = theView.bounds
        
        theBounds = CGRect(x: theBounds.minX, y: self.ySlider.value * theHeight, width: theBounds.width, height: theBounds.height)
        theView.bounds = theBounds
        theView.frame = theFrame
        self.yLabel.text = NSString(format:"%.f", theBounds.minY)
    }
}
