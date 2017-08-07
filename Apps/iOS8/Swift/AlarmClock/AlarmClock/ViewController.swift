//
//  ViewController.swift
//  AlarmClock
//
//  Created by Clemens Wagner on 21.06.14.
//  Copyright (c) 2014 Clemens Wagner. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let kSecondsOfDay:NSTimeInterval = 60.0 * 60.0 * 24.0
    
    @IBOutlet weak var clockView: ClockView!
    @IBOutlet weak var clockControl: ClockControl!
    @IBOutlet weak var timeLabel: UILabel!
    
    var alarmHidden: Bool {
    get {
        return clockControl.hidden
    }
    set {
        clockControl.hidden = newValue
        timeLabel.hidden = newValue
    }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(inAnimated: Bool) {
        super.viewWillAppear(inAnimated)
        updateViews()
    }
    
    override func viewDidAppear(inAnimated: Bool) {
        super.viewDidAppear(inAnimated)
        clockView.startAnimation()
    }
    
    override func viewWillDisappear(inAnimated: Bool) {
        clockView.stopAnimation()
        super.viewWillDisappear(inAnimated)
    }
    
    func updateViews() {
        let theApplication = UIApplication.sharedApplication()
        let theNotifications = theApplication.scheduledLocalNotifications
        let theNotification : UILocalNotification? = theNotifications.last as? UILocalNotification
        
        if(theNotification == nil) {
            alarmHidden = true;
        }
        else {
            var theTime = theNotification!.fireDate!.timeIntervalSinceReferenceDate - startTimeOfCurrentDay()
            
            theTime = theTime % (kSecondsOfDay / 2.0)
            clockControl.time = theTime < 0 ? theTime + kSecondsOfDay / 2.0 : theTime;
            alarmHidden = false
        }
        updateTimeLabel()
    }
    
    @IBAction func updateTimeLabel() {
        let theTime = UInt(round(clockControl.time / 60.0))
        let theMinutes = theTime % 60
        let theHours = theTime / 60
        
        timeLabel.text = NSString(format:"%d:%02d", theHours, theMinutes)
    }
    
    @IBAction func switchAlarm(inRecognizer:UILongPressGestureRecognizer!) {
        if(inRecognizer.state == UIGestureRecognizerState.Ended) {
            if(alarmHidden) {
                let thePoint = inRecognizer.locationInView(clockView)
                let theAngle = Double(clockView.angleWithPoint(thePoint))
                let theTime = 21600.0 * theAngle / M_PI
                
                alarmHidden = false
                clockControl.time = theTime
                updateTimeLabel()
            }
            else {
                alarmHidden = true
            }
            updateAlarm()
        }
    }
    
    @IBAction func updateAlarm() {
        if(alarmHidden) {
            let theApplication = UIApplication.sharedApplication()
            
            theApplication.cancelAllLocalNotifications()
        }
        else {
            createAlarm()
        }
    }
    
    func alarmDate() -> NSDate {
        var theTime:NSTimeInterval = startTimeOfCurrentDay() + clockControl.time;
        
        while(theTime < NSDate.timeIntervalSinceReferenceDate()) {
            theTime += kSecondsOfDay / 2.0;
        }
        return NSDate(timeIntervalSinceReferenceDate:theTime)
    }
    
    func createAlarm() {
        let theApplication = UIApplication.sharedApplication()
        let theNotification = UILocalNotification()
        
        theApplication.cancelAllLocalNotifications()
        theNotification.fireDate = alarmDate()
        theNotification.timeZone = NSTimeZone.defaultTimeZone()
        theNotification.alertBody = NSLocalizedString("Wake up", comment:"Alarm message")
        theNotification.soundName = "ringtone.caf"
        theApplication.scheduleLocalNotification(theNotification)
    }
    
    func startTimeOfCurrentDay() -> NSTimeInterval {
        let theCalendar = NSCalendar.currentCalendar()
        let theComponents = theCalendar.components(NSCalendarUnit.YearCalendarUnit | NSCalendarUnit.MonthCalendarUnit | NSCalendarUnit.DayCalendarUnit, fromDate: NSDate())
        let theDate = theCalendar.dateFromComponents(theComponents)
        
        return theDate!.timeIntervalSinceReferenceDate
    }
    
    func description() -> NSString {
        return NSString(format:"alarm: %@ (%@)", timeLabel.text!, alarmHidden ? "off" : "on")
    }
    
    func debugDescription() -> NSString {
        return NSString(format:"debug alarm: %@ (%.3fs, %@)", timeLabel.text!, clockControl.time, alarmHidden ? "off" : "on")
    }
}

