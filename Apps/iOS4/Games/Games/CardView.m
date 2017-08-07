//
//  CardView.m
//  Games
//
//  Created by Clemens Wagner on 23.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CardView.h"
#import "FrontView.h"
#import <QuartzCore/QuartzCore.h>

@interface CardView()

- (void)setupView;

@end

@implementation CardView

- (id)initWithFrame:(CGRect)inFrame {
    self = [super initWithFrame:inFrame];
    if(self) {
        [self setupView];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupView];
}


- (void)applyBorder:(UIView *)inView {
    CALayer *theLayer = inView.layer;
    
    theLayer.masksToBounds = YES;
    theLayer.cornerRadius = 6;
    theLayer.borderWidth = 2.0;
    theLayer.borderColor = [UIColor whiteColor].CGColor;
}

- (void)setupView {
    UIImage *theImage = [UIImage imageNamed:@"back.png"];
    UIImageView *theBackView = [[UIImageView alloc] initWithImage:theImage];
    FrontView *theFrontView = [[FrontView alloc] initWithFrame:self.bounds];
    
    theBackView.hidden = NO;
    theBackView.userInteractionEnabled = NO;
    theBackView.frame = self.bounds;
    [self applyBorder:theBackView];
    [self addSubview:theBackView];
    theFrontView.hidden = YES;
    theFrontView.userInteractionEnabled = NO;
    theFrontView.backgroundColor = [UIColor whiteColor];
    [self applyBorder:theFrontView];
    [self addSubview:theFrontView];
}

- (FrontView *)frontView {
    return self.subviews.lastObject;
}

- (NSUInteger)type {
    return self.frontView.type;
}

- (void)setType:(NSUInteger)inType {
    self.frontView.type = inType;
}

- (BOOL)showsFrontSide {
    return !self.frontView.hidden;
}

- (void)setShowsFrontSide:(BOOL)inShowingFront {
    [[self.subviews objectAtIndex:0] setHidden:inShowingFront];
    self.frontView.hidden = !inShowingFront;
}

- (void)showFrontSide:(BOOL)inShow withAnimationCompletion:(void (^)(BOOL inFinished))inCompletion {
    UIViewAnimationOptions theTransition = inShow ? UIViewAnimationOptionTransitionFlipFromLeft : UIViewAnimationOptionTransitionFlipFromRight;
    [UIView transitionWithView:self duration:0.75 
                       options:theTransition | UIViewAnimationOptionAllowUserInteraction
                    animations:^{
                        self.showsFrontSide = inShow;
                    } 
                    completion:inCompletion];
}

@end
