//
//  NSBundle+DynamicLoading.h
//  SecondClock
//
//  Created by Clemens Wagner on 20.08.14.
//  Copyright (c) 2014 Clemens Wagner. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSBundle(DynamicLoading)

+ (BOOL)allowsLoadingOfEmbeddedFrameworks;
+ (NSBundle *)embeddedFrameworkWithName:(NSString *)inName;

@end
