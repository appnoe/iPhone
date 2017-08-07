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

@synthesize window;
@synthesize viewController;
@synthesize soundId = _soundId;

- (void)dealloc {
    self.window = nil;
    self.viewController = nil;
    self.soundId = nil;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
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
