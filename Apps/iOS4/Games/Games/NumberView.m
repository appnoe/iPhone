//
//  NumberView.m
//  Games
//
//  Created by Clemens Wagner on 18.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NumberView.h"
#import "DigitView.h"
#import "UIView+MirrorImage.h"
#import <QuartzCore/QuartzCore.h>

@implementation NumberView

@synthesize value;


- (void)awakeFromNib {
    [super awakeFromNib];
    CALayer *theLayer = self.layer;
    
    theLayer.cornerRadius = 4;
    theLayer.masksToBounds = YES;
}

- (void)setValue:(NSUInteger)inValue animated:(BOOL)inAnimated {
    if(inAnimated) {
        [UIView animateWithDuration:0.75 animations:^{
            self.value = inValue;            
        }];
    }
    else {
        self.value = inValue;
    }
}

- (void)setValue:(NSUInteger)inValue {
    NSUInteger theValue = inValue;
    
    for(DigitView *theView in self.subviews) {
        theView.digit = theValue % 10;
        theValue /= 10;
    }
    value = inValue;
}

- (void)drawRect:(CGRect)inRect {
    for(UIView *theView in self.subviews) {
        [theView drawMirrorWithScale:0.6];
    }
}

@end