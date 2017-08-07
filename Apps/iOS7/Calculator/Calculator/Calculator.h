//
//  Calculator.h
//  Calculator
//
//  Created by Clemens Wagner on 25.03.14.
//  Copyright (c) 2014 Clemens Wagner. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Calculator : NSObject

@property (nonatomic, readonly) NSInteger errorPosition;
@property (nonatomic, copy) NSDictionary *values;

- (double)calculateWithString:(NSString *)inString;

@end
