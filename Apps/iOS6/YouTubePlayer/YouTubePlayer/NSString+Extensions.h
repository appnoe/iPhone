//
//  NSString+Extensions.h
//  YouTube
//
//  Created by Clemens Wagner on 10.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extensions)

- (NSString *)encodedStringForURLWithEncoding:(NSStringEncoding)inEncoding;
- (NSString *)trim;
- (NSString *)sha256;

@end
