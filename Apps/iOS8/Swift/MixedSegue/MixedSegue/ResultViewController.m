//
//  ResultViewController.m
//  Segue
//
//  Created by Clemens Wagner on 24.07.13.
//  Copyright (c) 2013 Cocoaneheads. All rights reserved.
//

#import "ResultViewController.h"

@interface ResultViewController ()

@property (weak, nonatomic) IBOutlet UILabel *ageLabel;

- (IBAction)dismiss;

@end

@implementation ResultViewController

- (void)viewWillAppear:(BOOL)inAnimated {
    [super viewWillAppear:inAnimated];
    NSCalendar *theCalendar = [NSCalendar currentCalendar];
    NSDateComponents *theComponents = [theCalendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                                                     fromDate:self.birthDate toDate:[NSDate date] options:0];

    self.ageLabel.text = [NSString stringWithFormat:@"Sie sind %d Jahre, %d Monate und %d Tage alt.",
                          theComponents.year, theComponents.month, theComponents.day];
}

- (IBAction)dismiss {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
