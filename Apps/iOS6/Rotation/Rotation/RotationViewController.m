//
//  RotationViewController.m
//  Rotation
//
//  Created by Clemens Wagner on 09.09.13.
//  Copyright (c) 2013 Cocoaneheads. All rights reserved.
//

#import "RotationViewController.h"

@interface RotationViewController ()

@property (weak, nonatomic) IBOutlet UISwitch *autorotationSwitch;
@property (strong, nonatomic) IBOutletCollection(UISwitch) NSArray *orientationSwitches;

@end

@implementation RotationViewController

- (BOOL)shouldAutorotate {
    NSLog(@"shouldAutorotate -> %d", self.autorotationSwitch.on);
    return self.autorotationSwitch.on;
}

- (NSUInteger)supportedInterfaceOrientations {
    NSUInteger theMask = 0;

    for(UISwitch *theSwitch in self.orientationSwitches) {
        if(theSwitch.on) {
            theMask |= theSwitch.tag;
        }
    }
    NSLog(@"supportedInterfaceOrientations -> %d", theMask);
    return theMask;
}

@end
