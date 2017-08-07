//
//  YouTubeCell.h
//  UniversalYouTube
//
//  Created by Clemens Wagner on 18.07.12.
//  Copyright (c) 2012 Clemens Wagner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YouTubeCell : UICollectionViewCell

@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *text;
@property(nonatomic, strong) UIColor *titleColor;

@end
