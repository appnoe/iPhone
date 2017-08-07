//
//  PreferencesViewController.m
//  AlarmClock
//
//  Created by Clemens Wagner on 16.08.13.
//  Copyright (c) 2013 Cocoaneheads. All rights reserved.
//

#import "PreferencesViewController.h"

@interface PreferencesViewController ()

@property (weak, nonatomic) IBOutlet UISwitch *digitsSwitch;
@property (weak, nonatomic) IBOutlet UISegmentedControl *partitionControl;
@property (weak, nonatomic) IBOutlet UISwitch *soundSwitch;

- (IBAction)savePreferences;

@end

@implementation PreferencesViewController

- (IBAction)savePreferences {
    NSUserDefaults *theDefaults = [NSUserDefaults standardUserDefaults];

    [theDefaults setBool:self.digitsSwitch.on forKey:@"showDigits"];
    [theDefaults setInteger:self.partitionControl.selectedSegmentIndex forKey:@"partitionOfDial"];
    [theDefaults setBool:self.soundSwitch.on forKey:@"playSound"];
    [theDefaults synchronize];
}

- (void)restorePreferences {
    NSUserDefaults *theDefaults = [NSUserDefaults standardUserDefaults];

    [theDefaults synchronize];
    self.digitsSwitch.on = [theDefaults boolForKey:@"showDigits"];
    self.partitionControl.selectedSegmentIndex = [theDefaults integerForKey:@"partitionOfDial"];
    self.soundSwitch.on = [theDefaults boolForKey:@"playSound"];
}

- (void)viewWillAppear:(BOOL)inAnimated {
    [super viewWillAppear:inAnimated];
    [self restorePreferences];
}

- (void)viewWillDisappear:(BOOL)inAnimated {
    [self savePreferences];
    [super viewWillDisappear:inAnimated];
}

@end
