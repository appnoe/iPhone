//
//  ModalViewController.m
//  Modal
//
//  Created by Clemens Wagner on 12.08.13.
//  Copyright (c) 2013 Cocoaneheads. All rights reserved.
//

#import "ModalViewController.h"

@interface ModalViewController ()

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UISlider *slider;

- (IBAction)done:(id)inSender;

@end

@implementation ModalViewController

- (void)viewWillAppear:(BOOL)inAnimated {
    [super viewWillAppear:inAnimated];
    self.label.text = [NSString stringWithFormat:@"%d", self.counter];
}

- (void)viewWillDisappear:(BOOL)inAnimated {
    if([self.delegate respondsToSelector:@selector(modalViewController:didUpdateValue:)]) {
        [self.delegate modalViewController:self didUpdateValue:self.slider.value];
    }
    [super viewWillDisappear:inAnimated];
}

- (IBAction)done:(id)inSender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
