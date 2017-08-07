//
//  AlarmClockAppDelegate.m
//  AlarmClock
//
//  Created by Clemens Wagner on 17.07.13.
//  Copyright (c) 2013 Cocoaneheads. All rights reserved.
//

#import "AlarmClockAppDelegate.h"
#import <AudioToolbox/AudioToolbox.h>
#import "ClockView.h"

@interface AlarmClockAppDelegate()

@property (nonatomic, strong) NSNumber *soundId;

@end

@implementation AlarmClockAppDelegate

@synthesize soundId = _soundId;

- (void)dealloc {
    self.soundId = nil;
}

- (BOOL)application:(UIApplication *)inApplication didFinishLaunchingWithOptions:(NSDictionary *)inOptions {
    NSUserDefaults *theDefaults = [NSUserDefaults standardUserDefaults];
    id theRootViewController = self.window.rootViewController;

    if([theRootViewController isKindOfClass:[UISplitViewController class]]) {
        id theViewController = [[theRootViewController viewControllers][1] topViewController];

        [theRootViewController setDelegate:theViewController];
    }
    [theDefaults registerDefaults:@{ @"showDigits": @YES,
                                     @"partitionOfDial" : @(PartitionOfDialMinutes),
                                     @"playSound": @YES }];

    // Alle Labels haben eine graue Schriftfarbe
    [[UILabel appearance] setTextColor:[UIColor darkGrayColor]];
    // Die Buttons in einer Navigationsleiste sind rot.
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTintColor:[UIColor redColor]];
    // Die Labels in einem Tableview sind blau, sofern sie nicht
    // in einer Zelle liegen.
    [[UILabel appearanceWhenContainedIn:[UITableView class], nil] setTextColor:[UIColor blueColor]];
    [[UILabel appearanceWhenContainedIn:[UITableViewCell class], [UITableView class], nil] setTextColor:[UIColor darkGrayColor]];
    [[ClockView appearance] setDialColor:[UIColor whiteColor]];
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
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"playSound"]) {
        NSNumber *theId = self.soundId;

        if(theId) {
            AudioServicesPlaySystemSound([theId unsignedIntValue]);
        }
    }
}

@end
