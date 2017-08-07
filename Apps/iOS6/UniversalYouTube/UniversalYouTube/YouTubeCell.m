//
//  YouTubeCell.m
//  UniversalYouTube
//
//  Created by Clemens Wagner on 18.07.12.
//  Copyright (c) 2012 Clemens Wagner. All rights reserved.
//

#import "YouTubeCell.h"
#import <QuartzCore/QuartzCore.h>

@interface YouTubeCell()

@property(nonatomic, weak) IBOutlet UILabel *titleLabel;
@property(nonatomic, weak) IBOutlet UITextView *textView;

@end

@implementation YouTubeCell

static const CGFloat kCellTitleHeight = 24.0;

+ (Class)layerClass {
    return [CAGradientLayer class];
}

- (void)setUpLayer {
    CAGradientLayer *theLayer = (CAGradientLayer *)self.layer;
    
    theLayer.cornerRadius = 8.0;
    theLayer.masksToBounds = YES;
    theLayer.colors = @[(id)[UIColor whiteColor].CGColor,
                       (id)[UIColor colorWithWhite:0.75 alpha:1.0].CGColor];
}

- (id)initWithFrame:(CGRect)inFrame {
    self = [super initWithFrame:inFrame];
    
    if(self) {
        CGFloat theWidth = CGRectGetWidth(inFrame);
        CGFloat theHeight = CGRectGetHeight(inFrame);
        UILabel *theLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, theWidth, kCellTitleHeight)];
        UITextView *theTextView = [[UITextView alloc] initWithFrame:CGRectMake(0.0, kCellTitleHeight,
                                                                               theWidth, theHeight - kCellTitleHeight)];

        theLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        theLabel.textAlignment = NSTextAlignmentCenter;
        theLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0];
        theLabel.backgroundColor = [UIColor redColor];
        theTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        theTextView.textAlignment = NSTextAlignmentLeft;
        theTextView.font = [UIFont fontWithName:@"Helvetica" size:11.0];
        theTextView.editable = NO;
        theTextView.backgroundColor = [UIColor clearColor];
        theTextView.userInteractionEnabled = NO;
        [self addSubview:theLabel];
        [self addSubview:theTextView];
        self.titleLabel = theLabel;
        self.textView = theTextView;        
        [self setUpLayer];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setUpLayer];
}

- (NSString *)title {
    return self.titleLabel.text;
}

- (void)setTitle:(NSString *)inTitle {
    self.titleLabel.text = inTitle;
}

- (NSString *)text {
    return self.textView.text;
}

- (void)setText:(NSString *)inText {
    self.textView.text = inText;
}

- (UIColor *)titleColor {
    return self.titleLabel.backgroundColor;
}

- (void)setTitleColor:(UIColor *)inTintColor {
    CGFloat theColors[4];
    float theBrightness = 0.0;
    
    self.titleLabel.backgroundColor = inTintColor;
    if([inTintColor getRed:theColors green:theColors + 1 blue:theColors + 2 alpha:theColors +3]) {
        theBrightness = (theColors[0] + theColors[1] + theColors[2]) / 3.0;
    }
    else if([inTintColor getHue:theColors saturation:theColors + 1 brightness:theColors + 2 alpha:theColors + 3]) {
        theBrightness = theColors[1];
    }
    self.titleLabel.textColor = [UIColor colorWithWhite:theBrightness < 0.5 alpha:1.0];
}

- (CGSize)sizeThatFits:(CGSize)inSize {
    CGSize theSize = inSize;
    
    theSize.height -= kCellTitleHeight;
    theSize = [self.textView sizeThatFits:theSize];
    theSize.height += kCellTitleHeight;
    return theSize;
}

@end
