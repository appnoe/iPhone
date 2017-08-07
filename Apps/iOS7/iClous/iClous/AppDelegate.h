//
//  AppDelegate.h
//  iClous
//
//  Created by Klaus Rodewig on 11.10.13.
//  Copyright (c) 2013 KMR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property BOOL theCloud;
@property (strong) NSURL *iCloudPath;

@end
