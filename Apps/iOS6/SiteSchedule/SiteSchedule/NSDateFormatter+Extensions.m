//
//  NSDateFormatter+Extensions.m
//  SiteSchedule
//
//  Created by Clemens Wagner on 01.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSDateFormatter+Extensions.h"

NSString * const kRFC1123NumericTimeZoneTimestampFormat = @"EEE, dd MMM yyyy HH:mm:ss ZZZ";
NSString * const kRFC1123TimestampFormat = @"EEE, dd MMM yyyy HH:mm:ss zzz";

@implementation NSDateFormatter(Extensions)

+ (id)dateFormatterWithPattern:(NSString *)inPattern {
    return [self dateFormatterWithPattern:inPattern locale:[NSLocale currentLocale]];
}

+ (id)dateFormatterWithPattern:(NSString *)inPattern locale:(NSLocale *)inLocale {
    NSDateFormatter *theFormatter = [[NSDateFormatter alloc] init];
    
    theFormatter.dateFormat = inPattern;
    theFormatter.locale = inLocale;
    return theFormatter;
}

+ (NSDate *)dateForRFC1123String:(NSString *)inText {
    NSLocale *theLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    NSDateFormatter *theFormatter = [NSDateFormatter dateFormatterWithPattern:kRFC1123TimestampFormat locale:theLocale];
    
    return [theFormatter dateFromString:inText];
}

@end
