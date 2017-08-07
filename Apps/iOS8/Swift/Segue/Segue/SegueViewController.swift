//
//  SegueViewController.swift
//  Segue
//
//  Created by Clemens Wagner on 23.06.14.
//  Copyright (c) 2014 Cocoaneheads. All rights reserved.
//

import UIKit

class SegueViewController: UIViewController {
    @IBOutlet var datePicker : UIDatePicker
    @IBOutlet var cube : Cube

    override func viewDidLoad() {
        super.viewDidLoad()
        NSLog("Cube: length = %.f, color = %@", self.cube.length, self.cube.color!)
    }
    
    override func prepareForSegue(inSegue: UIStoryboardSegue!, sender inSender: AnyObject!) {
        if(inSegue.identifier == "dialog") {
            let theController = inSegue.destinationViewController as ResultViewController
            
            theController.birthDate = self.datePicker.date
        }
    }
}
