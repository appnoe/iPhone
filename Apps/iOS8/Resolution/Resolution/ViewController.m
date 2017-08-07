//
//  ViewController.m
//  Resolution
//
//  Created by Clemens Wagner on 13.09.14.
//  Copyright (c) 2014 Clemens Wagner. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *displayLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIScreen *theScreen = [UIScreen mainScreen];
    
    self.displayLabel.text = [NSString stringWithFormat:@"scale = %.1f", theScreen.scale];
}

@end
