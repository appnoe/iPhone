//
//  BookmarksViewController.h
//  MoviePlayer
//
//  Created by Clemens Wagner on 09.06.13.
//  Copyright (c) 2013 Clemens Wagner. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BookmarksViewControllerDelegate;

@interface BookmarksViewController : UICollectionViewController

@property (nonatomic, weak) IBOutlet id<BookmarksViewControllerDelegate> delegate;

@end

@protocol BookmarksViewControllerDelegate<NSObject>

- (void)bookmarksViewController:(BookmarksViewController *)inController needsImageAtTime:(NSTimeInterval)inTime;
- (void)bookmarksViewController:(BookmarksViewController *)inController didUpdatePlaybackTime:(NSTimeInterval)inTime;

@end