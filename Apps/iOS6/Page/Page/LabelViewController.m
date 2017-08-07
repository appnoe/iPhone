//
//  PageViewController.m
//  Page
//
//  Created by Clemens Wagner on 30.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LabelViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation LabelViewController

@synthesize pageNumber;
@synthesize label;

- (void)viewDidLoad {
    [super viewDidLoad];
    CALayer *theLayer = self.view.layer;
    
    self.label.text = [NSString stringWithFormat:@"%d", self.pageNumber];
    theLayer.borderColor = [UIColor darkGrayColor].CGColor;
    theLayer.borderWidth = 1.0;
    theLayer.cornerRadius = 10.0;
    theLayer.masksToBounds = YES;
}
- (void)viewDidUnload {
    self.label = nil;
    [super viewDidUnload];
}

- (void)viewDidDisappear:(BOOL)inAnimated {
    [super viewDidDisappear:inAnimated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)inInterfaceOrientation {
    return YES;
}

- (IBAction)done {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)reset {
    id theRootViewController = self.view.window.rootViewController;
    
    [theRootViewController reset];
}

@end
