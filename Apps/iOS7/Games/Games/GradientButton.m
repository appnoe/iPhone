//
//  GradientButton.m
//  Games
//
//  Created by Clemens Wagner on 16.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GradientButton.h"
#import <QuartzCore/QuartzCore.h>

@interface GradientButton()

@property (nonatomic, strong) CAGradientLayer *backgroundLayer;
@property (nonatomic, strong, readonly) NSArray *normalColors;
@property (nonatomic, strong, readonly) NSArray *highligthedColors;

@end

@implementation GradientButton

- (void)awakeFromNib {
    [super awakeFromNib];
    CALayer *theLayer = self.layer;
    CAGradientLayer *theBackground = [CAGradientLayer layer];

    self.backgroundColor = [UIColor clearColor];
    theLayer.cornerRadius = 10.0;
    theLayer.masksToBounds = YES;
    theBackground.frame = theLayer.bounds;
    theBackground.startPoint = CGPointMake(0.5, 0.2);
    theBackground.endPoint = CGPointMake(0.5, 0.9);
    theBackground.colors = self.normalColors;
    theBackground.zPosition = -1;
    [theLayer addSublayer:theBackground];
    self.backgroundLayer = theBackground;
}

- (void)setHighlighted:(BOOL)inHighlighted {
    super.highlighted = inHighlighted;
    if(inHighlighted) {
        self.backgroundLayer.colors = self.highligthedColors;
    }
    else {
        self.backgroundLayer.colors = self.normalColors;
    }
}

- (NSArray *)normalColors {
    return @[(id)[UIColor colorWithRed:0.4 green:0.4 blue:1.0 alpha:1.0].CGColor,
            (id)[UIColor colorWithRed:0.0 green:0.0 blue:0.6 alpha:1.0].CGColor,
            (id)[UIColor colorWithRed:0.0 green:0.0 blue:0.8 alpha:1.0].CGColor];
}

- (NSArray *)highligthedColors {
    return @[(id)[UIColor colorWithRed:1.0 green:0.4 blue:0.4 alpha:1.0].CGColor,
            (id)[UIColor colorWithRed:0.6 green:0.0 blue:0.0 alpha:1.0].CGColor,
            (id)[UIColor colorWithRed:0.8 green:0.0 blue:0.0 alpha:1.0].CGColor];
}

@end
