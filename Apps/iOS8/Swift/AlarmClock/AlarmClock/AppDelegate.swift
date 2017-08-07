//
//  AppDelegate.swift
//  AlarmClock
//
//  Created by Clemens Wagner on 21.06.14.
//  Copyright (c) 2014 Clemens Wagner. All rights reserved.
//

import UIKit
import AudioToolbox

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UIAlertViewDelegate {
    var window: UIWindow?
    private var _soundId: SystemSoundID?
    var soundId: SystemSoundID {
    get {
        if _soundId != nil {
            let theURL = NSBundle.mainBundle().URLForResource("ringtone", withExtension:"caf")
            var theId: SystemSoundID = 0
            
            AudioServicesCreateSystemSoundID(theURL, &theId)
            _soundId = theId
        }
        return _soundId!
    }
    set {
        if _soundId != newValue && _soundId != nil {
            AudioServicesDisposeSystemSoundID(_soundId!)
        }
    }
    }

    func application(inApplication: UIApplication, didFinishLaunchingWithOptions inLaunchOptions: NSDictionary?) -> Bool {
        let theSettings = UIUserNotificationSettings(forTypes: UIUserNotificationType.Alert | UIUserNotificationType.Sound, categories: nil)
        
        inApplication.registerUserNotificationSettings(theSettings)
        return true
    }
    
    func application(inApplication: UIApplication!, didRegisterUserNotificationSettings inSettings: UIUserNotificationSettings!) {
        if inSettings.types & UIUserNotificationType.Alert != UIUserNotificationType.allZeros {
            NSLog("Alerts allowed")
        }
        if inSettings.types & UIUserNotificationType.Sound != UIUserNotificationType.allZeros {
            NSLog("Sounds allowed")
        }
    }

    func application(inApplication: UIApplication!, didReceiveLocalNotification inNotification: UILocalNotification!) {
        if(inApplication.applicationState == UIApplicationState.Active) {
            let theController = UIAlertController(title:"Alarm", message:inNotification.alertBody, preferredStyle:UIAlertControllerStyle.Alert)
            let theHandler = { (inAlert:UIAlertAction!) -> Void in
                NSLog("Alert cancelled")
                }
            let theAction = UIAlertAction(title:"OK", style:UIAlertActionStyle.Cancel, handler:dismissAlert)

            theController.addAction(theAction)
            window?.rootViewController?.presentViewController(theController, animated: true, completion: nil)
            playSound()
        }
    }
    
    func dismissAlert(inAlert:UIAlertAction!) -> Void {
        NSLog("Alert cancelled")
    }

    func playSound() {
        AudioServicesPlaySystemSound(soundId)
    }
}

