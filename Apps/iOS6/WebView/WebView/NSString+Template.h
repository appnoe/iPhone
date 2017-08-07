//
//  NSString+Template.h
//  WebView
//
//  Created by Clemens Wagner on 27.04.13.
//  Copyright (c) 2013 Clemens Wagner. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(Template)

- (NSString *)stringWithValuesOfObject:(id)inObject;
- (NSString *)stringByEscapingSpecialXMLCharacters;

@end
