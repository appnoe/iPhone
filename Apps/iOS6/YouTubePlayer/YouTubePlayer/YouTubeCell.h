//
//  YouTubeCell.h
//  YouTubePlayer
//
//  Created by Clemens Wagner on 04.05.13.
//  Copyright (c) 2013 Clemens Wagner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YouTubeCell : UICollectionViewCell

@property (nonatomic, weak, readonly) UILabel *titleLabel;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) NSString *text;

- (void)startLoadAnimation;
- (void)stopLoadAnimation;

@end
