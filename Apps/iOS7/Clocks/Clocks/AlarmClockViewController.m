//
//  AlarmClockViewController.m
//  Clocks
//
//  Created by Clemens Wagner on 21.07.13.
//  Copyright (c) 2013 Cocoaneheads. All rights reserved.
//

#import "AlarmClockViewController.h"
#import "ClockView.h"

#define USE_OUTLET_COLLECTION 0
#define USE_CONTAINER_VIEW 1

@interface AlarmClockViewController ()

@property (strong, nonatomic) IBOutletCollection(ClockView) NSArray *clockViews;
@property (weak, nonatomic) IBOutlet UISwitch *animationSwitch;
@property (weak, nonatomic) IBOutlet UIButton *animationButton;

- (IBAction)switchAnimation:(UISwitch *)inSender;
- (IBAction)toggleAnimation:(UIButton *)sender;

@end

@implementation AlarmClockViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *theTitle = [self.animationButton titleForState:UIControlStateHighlighted];
    [self.animationButton setTitle:theTitle forState:UIControlStateSelected | UIControlStateHighlighted];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)startAnimations {
#if USE_OUTLET_COLLECTION
    for(ClockView *theView in self.clockViews) {
        [theView startAnimation];
    }
#elif USE_CONTAINER_VIEW
    for(ClockView *theView in self.view.subviews) { // Variante mit Containerview ohne Outlet-Collections
        if([theView respondsToSelector:@selector(startAnimation)]) {
            [theView startAnimation];
        }
    }
#else
    [self.clockViews makeObjectsPerformSelector:@selector(startAnimation)];
#endif
}

- (void)viewDidAppear:(BOOL)inAnimated {
    [super viewDidAppear:inAnimated];
    [self switchAnimation:self.animationSwitch];
}

- (void)stopAnimations {
#if USE_OUTLET_COLLECTION
    for(ClockView *theView in self.clockViews) {
        [theView stopAnimation];
    }
#elif USE_CONTAINER_VIEW
    for(ClockView *theView in self.view.subviews) { // Variante mit Containerview ohne Outlet-Collections
        if([theView respondsToSelector:@selector(stopAnimation)]) {
            [theView stopAnimation];
        }
    }
#else
    [self.clockViews makeObjectsPerformSelector:@selector(stopAnimation)];
#endif
}

- (void)viewWillDisappear:(BOOL)inAnimated {
    [self stopAnimations];
    [super viewWillDisappear:inAnimated];
}

- (IBAction)switchAnimation:(UISwitch *)inSender {
    if(inSender.on) {
        [self startAnimations];
    }
    else {
        [self stopAnimations];
    }
    self.animationButton.selected = inSender.on;
}

- (IBAction)toggleAnimation:(UIButton *)inSender {
    inSender.selected = !inSender.selected;
    if(inSender.selected) {
        [self startAnimations];
    }
    else {
        [self stopAnimations];
    }
    self.animationSwitch.on = inSender.selected;
}

@end
