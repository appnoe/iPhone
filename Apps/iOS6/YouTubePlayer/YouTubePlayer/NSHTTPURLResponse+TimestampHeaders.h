//
//  NSHTTPURLResponse+TimestampHeaders.h
//  YouTubePlayer
//
//  Created by Clemens Wagner on 21.05.13.
//  Copyright (c) 2013 Clemens Wagner. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSHTTPURLResponse (TimestampHeaders)

+ (NSDateFormatter *)timestampFormatter;
- (NSDate *)timestampHeaderForKey:(NSString *)inKey;
- (NSDate *)dateOfExpiry;

@end
