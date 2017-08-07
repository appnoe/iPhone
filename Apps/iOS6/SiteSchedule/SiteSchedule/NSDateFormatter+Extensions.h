//
//  NSDateFormatter+Extensions.h
//  SiteSchedule
//
//  Created by Clemens Wagner on 01.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDateFormatter (Extensions)

+ (id)dateFormatterWithPattern:(NSString *)inPattern;
+ (id)dateFormatterWithPattern:(NSString *)inPattern locale:(NSLocale *)inLocale;
+ (NSDate *)dateForRFC1123String:(NSString *)inText;

@end
