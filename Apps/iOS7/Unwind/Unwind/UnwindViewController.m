//
//  UnwindViewController.m
//  Unwind
//
//  Created by Clemens Wagner on 19.08.12.
//  Copyright (c) 2012 Clemens Wagner. All rights reserved.
//

#import "UnwindViewController.h"

@interface UnwindViewController()

@end

@implementation UnwindViewController

- (BOOL)canPerformUnwindSegueAction:(SEL)inAction
                 fromViewController:(UIViewController *)inFromViewController
                         withSender:(id)inSender {
    BOOL theFlag = [super canPerformUnwindSegueAction:inAction fromViewController:inFromViewController withSender:inSender];
    
    NSLog(@"%@(%d) canPerformUnwindSegueAction:%@ fromViewController:%@ withSender:%@",
          self.navigationItem.title, theFlag,
          NSStringFromSelector(inAction),
          inFromViewController.navigationItem.title,
          inSender);
    return theFlag && self.unwindSwitch.on;
}

- (IBAction)jumpBack:(UIStoryboardSegue *)inSegue {
    NSLog(@"%@: jumped from %@ to %@", self.navigationItem.title,
          [[inSegue.sourceViewController navigationItem] title],
          [[inSegue.destinationViewController navigationItem] title]);
}

@end
