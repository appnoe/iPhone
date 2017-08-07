//
//  NSHTTPURLResponse+OfflineCache.m
//  YouTubePlayer
//
//  Created by Clemens Wagner on 21.05.13.
//  Copyright (c) 2013 Clemens Wagner. All rights reserved.
//

#import "NSHTTPURLResponse+TimestampHeaders.h"

@implementation NSHTTPURLResponse(TimestampHeaders)

+ (NSDateFormatter *)timestampFormatter {
    static NSDateFormatter *sFormatter = nil;

    if(sFormatter == nil) {
        NSDateFormatter *theFormatter = [NSDateFormatter new];
		NSLocale *theLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];

		[theFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss zzz"];
        [theFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
		[theFormatter setLocale:theLocale];
        sFormatter = theFormatter;
    }
    return sFormatter;
}

- (NSDate *)timestampHeaderForKey:(NSString *)inKey {
    NSString *theValue = self.allHeaderFields[inKey];
    NSDateFormatter *theFormatter = [[self class] timestampFormatter];

    return theValue == nil ? [NSDate date] : [theFormatter dateFromString:theValue];
}

- (NSDate *)dateOfExpiry {
    NSString *theValue = self.allHeaderFields[@"Cache-Control"];
    NSRange theRange = theValue == nil ? NSMakeRange(NSNotFound, 0) : [theValue rangeOfString:@"max-age="];

    if(theRange.location == NSNotFound) {
        return [self timestampHeaderForKey:@"Expires"];
    }
    else {
        NSInteger theStartIndex = theRange.location + theRange.length;
        NSString *theOffsetValue = [theValue substringFromIndex:theStartIndex];
        NSInteger theOffset = [theOffsetValue integerValue];
        NSDate *theDate = [self timestampHeaderForKey:@"Date"];

        return [theDate dateByAddingTimeInterval:theOffset];
    }
}

@end
