//
//  ProtocolDroid.m
//  Kapitel2
//
//  Created by Rodewig Klaus on 09.06.12.
//  Copyright (c) 2012 Klaus M. Rodewig. All rights reserved.
//

#import "ProtocolDroid.h"
#import "NSString+ReverseString.h"

@implementation ProtocolDroid

- (NSString *)droidID {
    return [[super droidID] reversedString];
}

@end