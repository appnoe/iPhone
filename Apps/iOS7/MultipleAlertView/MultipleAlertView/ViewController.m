//
//  ViewController.m
//  MultipleAlertView
//
//  Created by Clemens Wagner on 28.09.13.
//  Copyright (c) 2013 Cocoaneheads. All rights reserved.
//

#import "ViewController.h"

typedef void (^AlertViewCallback)(UIAlertView *inAlertView, NSUInteger inButton);

@interface ViewController()<UIAlertViewDelegate>

@property (nonatomic, copy) AlertViewCallback alertViewCallback;

@end

@implementation ViewController
@synthesize imageView;
@synthesize titleLabel;

@synthesize alertViewCallback;

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidUnload {
    [self setImageView:nil];
    [self setTitleLabel:nil];
    [super viewDidUnload];
}

- (IBAction)chooseImage:(id)inSender {
    UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Choose Image", @"")
                                                       message:NSLocalizedString(@"Please choose an image.", @"")
                                                      delegate:self
                                             cancelButtonTitle:NSLocalizedString(@"Cancel", @"")
                                             otherButtonTitles:NSLocalizedString(@"Dragonfly", @""), NSLocalizedString(@"Flower", @""), nil];
    UIImageView *theImageView = self.imageView;

    self.alertViewCallback = ^(UIAlertView *inAlertView, NSUInteger inButton) {
        if(inButton > 0) {
            NSString *theName = inButton == 1 ? @"dragonfly.jpg" : @"flower.jpg";

            theImageView.image = [UIImage imageNamed:theName];
        }
    };
    [theAlert show];
}

- (IBAction)chooseTitle:(id)inSender {
    UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Choose Title", @"")
                                                       message:NSLocalizedString(@"Please choose a title.", @"")
                                                      delegate:self
                                             cancelButtonTitle:NSLocalizedString(@"Cancel", @"")
                                             otherButtonTitles:NSLocalizedString(@"Dragonfly", @""), NSLocalizedString(@"Flower", @""), nil];
    UILabel *theLabel = self.titleLabel;

    self.alertViewCallback = ^(UIAlertView *inAlertView, NSUInteger inButton) {
        if(inButton > 0) {
            theLabel.text = inButton == 1 ? NSLocalizedString(@"Dragonfly", @"") : NSLocalizedString(@"Flower", @"");
        }
    };
    [theAlert show];
}

#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)inAlertView clickedButtonAtIndex:(NSInteger)inButton {
    AlertViewCallback theCallback = self.alertViewCallback;

    self.alertViewCallback = nil;
    theCallback(inAlertView, inButton);
}

@end
