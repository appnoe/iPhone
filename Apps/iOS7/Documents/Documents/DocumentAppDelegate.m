//
//  DocumentAppDelegate.m
//  Documents
//
//  Created by Clemens Wagner on 13.10.13.
//  Copyright (c) 2013 Clemens Wagner. All rights reserved.
//

#import "DocumentAppDelegate.h"

@interface DocumentAppDelegate()

@property (nonatomic, strong) UIStoryboard *storyboard;
@property (nonatomic) NSInteger currentPageIndex;
@property (nonatomic, strong) NSArray *documentURLs;

@end

@implementation DocumentAppDelegate

- (BOOL)application:(UIApplication *)inApplication didFinishLaunchingWithOptions:(NSDictionary *)inLaunchOptions {
    return YES;
}

@end
