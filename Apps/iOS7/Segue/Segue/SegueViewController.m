//
//  SegueViewController.m
//  Segue
//
//  Created by Clemens Wagner on 24.07.13.
//  Copyright (c) 2013 Cocoaneheads. All rights reserved.
//

#import "SegueViewController.h"
#import "ResultViewController.h"
#import "Cube.h"

@interface SegueViewController ()

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet Cube *cube;

@end

@implementation SegueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"Cube: length = %.f, color = %@", self.cube.length, self.cube.color);
}

- (void)prepareForSegue:(UIStoryboardSegue *)inSegue sender:(id)inSender {
    if([inSegue.identifier isEqualToString:@"dialog"]) {
        ResultViewController *theController = inSegue.destinationViewController;

        theController.birthDate = self.datePicker.date;
    }
}

@end
