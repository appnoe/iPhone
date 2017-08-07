//
//  ViewController.h
//  Kapitel2
//
//  Created by Clemens Wagner on 22.09.13.
//  Copyright (c) 2013 Cocoaneheads. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model.h"

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (strong) Model *model;

- (IBAction)updateCountOfDroids:(UIStepper *)inSender;

@end
