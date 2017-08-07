//
//  RootViewController.m
//  Modal
//
//  Created by Clemens Wagner on 12.08.13.
//  Copyright (c) 2013 Cocoaneheads. All rights reserved.
//

#import "RootViewController.h"
#import "ModalViewController.h"

@interface RootViewController()<ModalViewControllerDelegate>

@property (nonatomic) NSUInteger viewCounter;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) UIPopoverController *popover;

- (IBAction)showModalDialog;
- (IBAction)showPopoverDialog:(id)inSender;
- (IBAction)triggerDialogSegue:(id)inSender;

@end

@implementation RootViewController

- (IBAction)showModalDialog {
    ModalViewController *theController = [self.storyboard instantiateViewControllerWithIdentifier:@"modal"];

    theController.counter = ++self.viewCounter;
    theController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    theController.delegate = self;
    [self presentViewController:theController animated:YES completion:^{
        NSLog(@"finished");
    }];
}

- (IBAction)showPopoverDialog:(id)inSender {
    ModalViewController *theController = [self.storyboard instantiateViewControllerWithIdentifier:@"modal"];

    self.popover = [[UIPopoverController alloc] initWithContentViewController:theController];
    theController.counter = ++self.viewCounter;
    theController.delegate = self;
    [self.popover presentPopoverFromRect:[inSender bounds] inView:inSender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (IBAction)triggerDialogSegue:(id)inSender {
    [self performSegueWithIdentifier:@"dialog" sender:inSender];
}

#pragma mark ModalViewControllerDelegate

- (void)modalViewController:(ModalViewController *)inController didUpdateValue:(CGFloat)inValue {
    self.label.text = [NSString stringWithFormat:@"%.1f", inValue];
}

@end
