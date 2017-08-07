//
//  AnimationViewController.m
//  Animation3D
//
//  Created by Clemens Wagner on 24.08.13.
//  Copyright (c) 2013 Cocoaneheads. All rights reserved.
//

#import "AnimationViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface AnimationViewController ()

@property (weak, nonatomic) IBOutlet UIView *layerView;
@property (weak, nonatomic) IBOutlet UISlider *zPositionSlider;
@property (weak, nonatomic) IBOutlet UISlider *anchorPointZSlider;
@property (weak, nonatomic) CALayer *staticLayer;
@property (weak, nonatomic) CALayer *mobileLayer;


- (IBAction)rotate;
- (IBAction)reset;
- (IBAction)zPositionUpdated:(UISlider *)inSlider;
- (IBAction)anchorPointZUpdated:(UISlider *)inSlider;
- (IBAction)switchPerspective:(UISwitch *)inSwitch;

@end

@implementation AnimationViewController

- (void)viewDidAppear:(BOOL)inAnimated {
    [super viewDidAppear:inAnimated];
    [self createLayers];
}

- (CALayer *)parentLayer {
    return self.layerView.layer;
}

- (void)createLayers {
    if(self.staticLayer == nil && self.mobileLayer == nil) {
        CALayer *theParentLayer = self.parentLayer;
        CGRect theBounds = self.layerView.bounds;
        CALayer *theLayer = [CALayer layer];
        CGPoint theCenter = CGPointMake(CGRectGetMidX(theBounds), CGRectGetMidX(theBounds));

        theLayer.frame = CGRectMake(0.0, 0.0, CGRectGetWidth(theBounds) / 4.0, CGRectGetHeight(theBounds) / 4.0);
        theLayer.position = theCenter;
        theLayer.backgroundColor = [UIColor redColor].CGColor;
        [theParentLayer addSublayer:theLayer];
        self.staticLayer = theLayer;
        theLayer = [CALayer layer];
        theLayer.frame = CGRectMake(0.0, 0.0, CGRectGetWidth(theBounds) / 4.0, CGRectGetHeight(theBounds) / 4.0);
        theLayer.position = CGPointMake(1.25 * theCenter.x, 1.25 * theCenter.y);
        theLayer.backgroundColor = [UIColor greenColor].CGColor;
        [theParentLayer addSublayer:theLayer];
        self.mobileLayer = theLayer;
    }
}

- (IBAction)rotate {
    CABasicAnimation *theAnimation = [CABasicAnimation animation];

    theAnimation.toValue = @(2 * M_PI);
    theAnimation.repeatCount = 1;
    theAnimation.duration = 4.0;
    [self.staticLayer addAnimation:theAnimation forKey:@"transform.rotation.x"];
    [self.mobileLayer addAnimation:theAnimation forKey:@"transform.rotation.x"];
}

- (IBAction)reset {
    self.zPositionSlider.value = 0.0;
    self.anchorPointZSlider.value = 0.0;
    self.mobileLayer.zPosition = 0.0;
    self.mobileLayer.anchorPointZ = 0.0;
}

- (IBAction)zPositionUpdated:(UISlider *)inSlider {
    self.mobileLayer.zPosition = inSlider.value;
}

- (IBAction)anchorPointZUpdated:(UISlider *)inSlider {
    self.mobileLayer.anchorPointZ = inSlider.value;
}

- (IBAction)switchPerspective:(UISwitch *)inSwitch {
    CALayer *theParentLayer = self.parentLayer;
    CATransform3D theTransform = CATransform3DIdentity;

    if(inSwitch.on) {
        theTransform.m34 = -0.005;
    }
    theParentLayer.sublayerTransform = theTransform;
}

@end
