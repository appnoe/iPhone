//
//  NSBundle+DynamicLoading.m
//  SecondClock
//
//  Created by Clemens Wagner on 20.08.14.
//  Copyright (c) 2014 Clemens Wagner. All rights reserved.
//

#import "NSBundle+DynamicLoading.h"
#import <UIKit/UIKit.h>

@implementation NSBundle(DynamicLoading)

+ (BOOL)allowsLoadingOfEmbeddedFrameworks {
    return [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0f;
}

+ (NSBundle *)embeddedFrameworkWithName:(NSString *)inName {
    NSURL *theURL = [[NSBundle mainBundle] URLForResource:inName withExtension:@"framework" subdirectory:@"Frameworks"];
    NSBundle *theBundle = [NSBundle bundleWithURL:theURL];
    
    [theBundle load];
    return theBundle;
}

@end
