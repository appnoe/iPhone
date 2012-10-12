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

@property (nonatomic, retain) CAGradientLayer *backgroundLayer;
@property (nonatomic, retain, readonly) NSArray *normalColors;
@property (nonatomic, retain, readonly) NSArray *highligthedColors;

@end

@implementation GradientButton

@synthesize backgroundLayer;

- (void)dealloc {
    self.backgroundLayer = nil;
    [super dealloc];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    CALayer *theLayer = self.layer;
    CAGradientLayer *theBackground = [CAGradientLayer layer];

    self.backgroundColor = [UIColor clearColor];
    theLayer.cornerRadius = 10.0;
    theLayer.masksToBounds = YES;
    theBackground.frame = theLayer.bounds;
    theBackground.startPoint = CGPointMake(0.5, 0.2);
    theBackground.endPoint = CGPointMake(0.5, 0.4);
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
    return [NSArray arrayWithObjects:
            (id)[UIColor colorWithRed:0.0 green:0.0 blue:0.9 alpha:1.0].CGColor,
            [UIColor colorWithRed:0.0 green:0.0 blue:0.6 alpha:1.0].CGColor, nil];
}

- (NSArray *)highligthedColors {
    return [NSArray arrayWithObjects:
            (id)[UIColor colorWithRed:0.9 green:0.0 blue:0.0 alpha:1.0].CGColor,
            [UIColor colorWithRed:0.6 green:0.0 blue:0.0 alpha:1.0].CGColor, nil];
}

@end
