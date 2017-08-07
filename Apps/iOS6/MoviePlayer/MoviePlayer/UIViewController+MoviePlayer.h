//
//  UIViewController+MoviePlayer.h
//  MoviePlayer
//
//  Created by Clemens Wagner on 09.06.13.
//  Copyright (c) 2013 Clemens Wagner. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const kBookmarks;

@interface UIViewController (MoviePlayer)

- (NSArray *)bookmarks;
- (void)setBookmarks:(NSArray *)inBookmarks;
- (void)addBookmarkWithTime:(NSTimeInterval)inTime;

@end
