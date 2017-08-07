//
//  ResultViewController.swift
//  Segue
//
//  Created by Clemens Wagner on 23.06.14.
//  Copyright (c) 2014 Cocoaneheads. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {
    var birthDate : NSDate?
    @IBOutlet var ageLabel : UILabel
    
    override func viewWillAppear(inAnimated: Bool) {
        super.viewWillAppear(inAnimated)
        let theCalendar = NSCalendar.currentCalendar()
        let theComponents = theCalendar.components(
            NSCalendarUnit.YearCalendarUnit | NSCalendarUnit.MonthCalendarUnit | NSCalendarUnit.DayCalendarUnit, fromDate:self.birthDate!, toDate: NSDate(), options: NSCalendarOptions.fromMask(0))
        
        self.ageLabel.text = NSString(format:"Sie sind %d Jahre, %d Monate und %d Tage alt.",
            theComponents.year, theComponents.month, theComponents.day)
    }
    
    @IBAction func dismiss() {
        dismissViewControllerAnimated(true, completion: nil)
    }

}
