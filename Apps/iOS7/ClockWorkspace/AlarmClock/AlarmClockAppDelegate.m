//
//  AlarmClockAppDelegate.m
//  AlarmClock
//
//  Created by Clemens Wagner on 17.07.13.
//  Copyright (c) 2013 Cocoaneheads. All rights reserved.
//

#import "AlarmClockAppDelegate.h"
#import <AudioToolbox/AudioToolbox.h>

@interface AlarmClockAppDelegate()

@property (nonatomic, strong) NSNumber *soundId;

@end

@implementation AlarmClockAppDelegate

@synthesize soundId = _soundId;

- (void)dealloc {
    self.soundId = nil;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)inApplication didReceiveLocalNotification:(UILocalNotification *)inNotification {
    if(inApplication.applicationState == UIApplicationStateActive) {
        UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:nil
                                                           message:inNotification.alertBody
                                                          delegate:nil
                                                 cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                                 otherButtonTitles:nil];
        [theAlert show];
        [self playSound];
    }
}

- (NSNumber *)soundId {
    if(_soundId == nil) {
        NSURL *theURL = [[NSBundle mainBundle] URLForResource:@"ringtone" withExtension:@"caf"];
        SystemSoundID theId;

        if(AudioServicesCreateSystemSoundID((__bridge CFURLRef)theURL, &theId) == kAudioServicesNoError) {
            self.soundId = @(theId);
        }
    }
    return _soundId;
}

- (void)setSoundId:(NSNumber *)inSoundId {
    if(_soundId != inSoundId) {
        if(_soundId != nil) {
            AudioServicesDisposeSystemSoundID([_soundId unsignedIntValue]);
        }
        _soundId = inSoundId;
    }
}

- (void)playSound {
    NSNumber *theId = self.soundId;

    if(theId) {
        AudioServicesPlaySystemSound([theId unsignedIntValue]);
    }
}

@end
