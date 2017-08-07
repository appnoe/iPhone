//
//  Wookiee.m
//  Kapitel2
//
//  Created by Rodewig Klaus on 12.07.12.
//  Copyright (c) 2012 Klaus M. Rodewig. All rights reserved.
//

#import "Wookiee.h"

@implementation Wookiee

- (id)initWithName:(NSString *)inName {
    self = [super init];
    if(self != nil){
        self.name = inName;
    }
    NSLog(@"[+] %@.%@", self, NSStringFromSelector(_cmd));
    return self;
}

-(void)sayName{
    NSLog(@"[+] %@.%@: %@", self, NSStringFromSelector(_cmd), self.name);
}

@end