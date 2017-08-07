//
//  FlipBookViewController.m
//  FlipBookAnimation
//
//  Created by Clemens Wagner on 28.08.12.
//  Copyright (c) 2012 Clemens Wagner. All rights reserved.
//

#import "FlipBookViewController.h"
#import "CALayer+AnimationPausing.h"
#import <ImageIO/ImageIO.h>
#import <QuartzCore/QuartzCore.h>

@interface FlipBookViewController ()

@property (weak, nonatomic) IBOutlet UIView *animationView;

@end

@implementation FlipBookViewController

- (void)viewDidAppear:(BOOL)inAnimated {
    [super viewDidAppear:inAnimated];
    NSArray *theImages = [self readAnimationImages];
    CALayer *theLayer = self.animationView.layer;
    CAKeyframeAnimation *theAnimation = [CAKeyframeAnimation animation];
    
    theAnimation.values = theImages;
    theAnimation.repeatCount = HUGE_VALF;
    theAnimation.duration = 1.0;
    // theAnimation.calculationMode = kCAAnimationDiscrete;
    theLayer.speed = 1.0;
    [theLayer addAnimation:theAnimation forKey:@"contents"];
}

- (void)viewWillDisappear:(BOOL)inAnimated {
    CALayer *theLayer = self.animationView.layer;

    [theLayer removeAllAnimations];
    [super viewWillDisappear:inAnimated];
}

- (NSArray *)readAnimationImages {
    NSBundle *theBundle = [NSBundle mainBundle];
    NSURL *theURL = [theBundle URLForResource:@"animated-image" withExtension:@"gif"];
    NSDictionary *theOptions = [NSDictionary dictionaryWithObjectsAndKeys:nil];
    CGImageSourceRef theSource = CGImageSourceCreateWithURL((__bridge CFURLRef) theURL,
                                                            (__bridge CFDictionaryRef)theOptions);
    size_t theCount = CGImageSourceGetCount(theSource);
    NSMutableArray *theResult = [NSMutableArray arrayWithCapacity:theCount];

    for(size_t i = 0; i < theCount; ++i) {
        CGImageRef theImage = CGImageSourceCreateImageAtIndex(theSource, i, (__bridge CFDictionaryRef)theOptions);
        
        [theResult addObject:(__bridge_transfer id)theImage];
    }
    CFRelease(theSource);
    return theResult;
}

- (IBAction)flipAnimation:(UIButton *)inButton {
    CALayer *theLayer = self.animationView.layer;
    
    theLayer.isPausing ? [theLayer resume] : [theLayer pause];
    inButton.selected = theLayer.isPausing;
}

@end
