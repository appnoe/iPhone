//
//  YouTubeCell.m
//  YouTubePlayer
//
//  Created by Clemens Wagner on 04.05.13.
//  Copyright (c) 2013 Clemens Wagner. All rights reserved.
//

#import "YouTubeCell.h"

#import <QuartzCore/QuartzCore.h>

@interface YouTubeCell ()

@property (nonatomic, weak, readwrite) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak, readwrite) IBOutlet UILabel *textLabel;
@property (nonatomic, weak, readwrite) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@end

@implementation YouTubeCell

@synthesize titleLabel;
@synthesize imageView;

+(Class)layerClass {
    return [CAGradientLayer class];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    CAGradientLayer *theLayer = (CAGradientLayer *)self.layer;

    theLayer.cornerRadius = 8.0;
    theLayer.masksToBounds = YES;
    theLayer.colors = @[(id)[UIColor whiteColor].CGColor,
                        (id)self.backgroundColor.CGColor];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self stopLoadAnimation];
}

- (UIImage *)image {
    return self.imageView.image;
}

- (void)setImage:(UIImage *)inImage {
    self.imageView.image = inImage;
}

- (NSString *)text {
    return self.textLabel.text;
}

- (void)setText:(NSString *)inText {
    self.textLabel.text = inText;
}

- (void)startLoadAnimation {
    [self.activityIndicatorView startAnimating];
}

- (void)stopLoadAnimation {
    [self.activityIndicatorView stopAnimating];
}

@end
