//
//  UIViewController+MoviePlayer.m
//  MoviePlayer
//
//  Created by Clemens Wagner on 09.06.13.
//  Copyright (c) 2013 Clemens Wagner. All rights reserved.
//

#import "UIViewController+MoviePlayer.h"

NSString * const kBookmarks = @"bookmarks";

@implementation UIViewController(MoviePlayer)

- (NSArray *)bookmarks {
    return [[NSUserDefaults standardUserDefaults] valueForKey:kBookmarks];
}

- (void)setBookmarks:(NSArray *)inBookmarks {
    NSUserDefaults *theDefaults = [NSUserDefaults standardUserDefaults];
    
    [theDefaults setValue:inBookmarks forKey:kBookmarks];
    [theDefaults synchronize];
}

- (void)addBookmarkWithTime:(NSTimeInterval)inTime {
    NSArray *theBookmarks = [self bookmarks];

    theBookmarks = [theBookmarks arrayByAddingObject:@(inTime)];
    self.bookmarks = theBookmarks;
}

@end
