//
//  SecondClockViewController.m
//  SecondClock
//
//  Created by Clemens Wagner on 06.09.13.
//  Copyright (c) 2013 Cocoaneheads. All rights reserved.
//

#import "SecondClockViewController.h"
#import <ClockLibrary/ClockView.h>

#ifdef ORANGE_CLOCK
#import <QuartzCore/QuartzCore.h>
#endif

@interface SecondClockViewController ()

@property (weak, nonatomic) IBOutlet ClockView *clockView;

@end

@implementation SecondClockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
#ifdef ORANGE_CLOCK
    CALayer *theLayer = self.clockView.layer;

    theLayer.cornerRadius = 20.0;
    theLayer.masksToBounds = YES;
#endif
}

- (void)viewDidAppear:(BOOL)inAnimated {
    [super viewDidAppear:inAnimated];
    [self.clockView startAnimation];
}

- (void)viewWillDisappear:(BOOL)inAnimated {
    [self.clockView stopAnimation];
    [super viewWillDisappear:inAnimated];
}

@end
