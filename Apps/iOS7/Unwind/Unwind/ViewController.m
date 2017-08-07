//
//  ViewController.m
//  Unwind
//
//  Created by Clemens Wagner on 19.08.12.
//  Copyright (c) 2012 Clemens Wagner. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

static NSUInteger counter;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *theName = [self respondsToSelector:@selector(jumpBack:)] ?
    @"Unwind" : @"Controller";
    self.navigationItem.title = [NSString stringWithFormat:@"%@ %u",
                                 theName, counter++];
}

- (BOOL)canPerformUnwindSegueAction:(SEL)inAction
                 fromViewController:(UIViewController *)inFromViewController
                         withSender:(id)inSender {
    BOOL theFlag = [super canPerformUnwindSegueAction:inAction fromViewController:inFromViewController withSender:inSender];
    
    NSLog(@"%@(%d) canPerformUnwindSegueAction:%@ fromViewController:%@ withSender:%@",
          self.navigationItem.title, theFlag,
          NSStringFromSelector(inAction),
          inFromViewController.navigationItem.title,
          inSender);
    return theFlag;
}

@end
