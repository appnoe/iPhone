//
//  SecondClockViewController.m
//  SecondClock
//
//  Created by Clemens Wagner on 10.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SecondClockViewController.h"

#if BLACK_CLOCK
#import <QuartzCore/QuartzCore.h>
#endif

@implementation SecondClockViewController

@synthesize clockView;

- (void)viewDidLoad {
    [super viewDidLoad];
#if BLACK_CLOCK
    CALayer *theLayer = self.clockView.layer;
    
    theLayer.cornerRadius = 10.0;
    theLayer.masksToBounds = YES;
#endif
}

- (void)viewDidUnload {
    [self setClockView:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)inAnimated {
    [super viewWillAppear:inAnimated];
}

- (void)viewDidAppear:(BOOL)inAnimated {
    [super viewDidAppear:inAnimated];
    [self.clockView startAnimation];
}

- (void)viewWillDisappear:(BOOL)inAnimated {
    [self.clockView stopAnimation];
	[super viewWillDisappear:inAnimated];
}

- (void)viewDidDisappear:(BOOL)inAnimated {
	[super viewDidDisappear:inAnimated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)inInterfaceOrientation {
    return YES;
}

@end
