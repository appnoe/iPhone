//
//  MovieCell.m
//  MoviePlayer
//
//  Created by Clemens Wagner on 09.06.13.
//  Copyright (c) 2013 Clemens Wagner. All rights reserved.
//

#import "MovieCell.h"
#import <QuartzCore/QuartzCore.h>

@interface MovieCell()

@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@end

@implementation MovieCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.borderColor = [self.tintColor CGColor];
    self.layer.borderWidth = 1.0;
}

- (UIImage *)image {
    return self.imageView.image;
}

- (void)setImage:(UIImage *)inImage {
    self.imageView.image = inImage;
    if(inImage == nil) {
        [self.activityIndicatorView startAnimating];
    }
    else {
        [self.activityIndicatorView stopAnimating];
    }
}

- (NSString *)text {
    return self.textLabel.text;
}

- (void)setText:(NSString *)inText {
    self.textLabel.text = inText;
}

@end
