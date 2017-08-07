//
//  NSString+Extensions.m
//  YouTube
//
//  Created by Clemens Wagner on 10.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSString+Extensions.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString(Extensions)

- (NSString *)encodedStringForURLWithEncoding:(NSStringEncoding)inEncoding {
    CFStringEncoding theEncoding = CFStringConvertNSStringEncodingToEncoding(inEncoding);
    CFStringRef theResult = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                    (__bridge CFStringRef) self, 
                                                                    NULL, 
                                                                    (CFStringRef)@"!*'();:@&=+$,/?%#[]", 
                                                                    theEncoding);
    
    return (__bridge_transfer NSString *)theResult;
}

- (NSString *)trim {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)sha256 {
    unsigned char theBuffer[CC_SHA256_DIGEST_LENGTH];
    NSMutableString *theResult = [NSMutableString stringWithCapacity:2 * CC_SHA256_DIGEST_LENGTH];
    
    CC_SHA256([self UTF8String], (CC_LONG)[self lengthOfBytesUsingEncoding:NSUTF8StringEncoding], theBuffer);
    for(int i = 0; i < CC_SHA256_DIGEST_LENGTH; ++i) {
        [theResult appendFormat:@"%02d", theBuffer[i]];
    }
    return [theResult copy];
}

@end
