//
//  ViewController.h
//  MultipleAlertView
//
//  Created by Clemens Wagner on 28.09.13.
//  Copyright (c) 2013 Cocoaneheads. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

- (IBAction)chooseImage:(id)inSender;
- (IBAction)chooseTitle:(id)inSender;

@end
