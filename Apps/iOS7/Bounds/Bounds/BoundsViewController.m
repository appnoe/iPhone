//
//  BoundsViewController.m
//  Bounds
//
//  Created by Clemens Wagner on 22.06.14.
//  Copyright (c) 2014 Clemens Wagner. All rights reserved.
//

#import "BoundsViewController.h"

@interface BoundsViewController()

@property (nonatomic, weak) IBOutlet UIView *boundsView;

@property (nonatomic, weak) IBOutlet UISlider *xSlider;
@property (nonatomic, weak) IBOutlet UISlider *ySlider;

@property (nonatomic, weak) IBOutlet UILabel *xLabel;
@property (nonatomic, weak) IBOutlet UILabel *yLabel;

@end

@implementation BoundsViewController

- (void)viewWillAppear:(BOOL)inAnimated {
    [super viewWillAppear:inAnimated];
    [self updateX];
    [self updateY];
}

- (IBAction)updateX {
    UIView *theView = self.boundsView;
    CGRect theFrame = theView.frame;
    CGRect theBounds = theView.bounds;
    CGFloat theWidth = CGRectGetWidth(theFrame);
    
    theBounds.origin.x = self.xSlider.value * theWidth;
    theView.bounds = theBounds;
    theView.frame = theFrame;
    self.xLabel.text = [NSString stringWithFormat:@"%.f", CGRectGetMinX(theBounds)];
    NSLog(@"frame: %@", NSStringFromCGRect(theView.frame));
}

- (IBAction)updateY {
    UIView *theView = self.boundsView;
    CGRect theFrame = theView.frame;
    CGRect theBounds = theView.bounds;
    CGFloat theHeight = CGRectGetHeight(theFrame);
    
    theBounds.origin.y = self.ySlider.value * theHeight;
    theView.bounds = theBounds;
    theView.frame = theFrame;
    self.yLabel.text = [NSString stringWithFormat:@"%.f", CGRectGetMinY(theBounds)];
    NSLog(@"frame: %@", NSStringFromCGRect(theView.frame));
}

@end
