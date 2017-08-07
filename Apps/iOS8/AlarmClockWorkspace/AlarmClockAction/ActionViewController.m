//
//  ActionViewController.m
//  AlarmClockAction
//
//  Created by Clemens Wagner on 17.08.14.
//  Copyright (c) 2014 Cocoaneheads. All rights reserved.
//

#import "ActionViewController.h"
#import <AlarmClockFramework/AlarmClockFramework.h>

@interface ActionViewController ()

@property(strong,nonatomic) IBOutlet ClockView *clockView;

@end

@implementation ActionViewController

- (void)viewWillAppear:(BOOL)inAnimated {
    [super viewWillAppear:inAnimated];
    [self.clockView startAnimation];
}

- (IBAction)done {
    [self.extensionContext completeRequestReturningItems:self.extensionContext.inputItems completionHandler:nil];
}

@end
