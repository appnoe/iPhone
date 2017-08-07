//
//  ViewController.h
//  HelloiPhone
//
//  Created by Clemens Wagner on 12.07.13.
//  Copyright (c) 2013 Cocoaneheads. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *label;

- (IBAction)go:(id)sender;

@end