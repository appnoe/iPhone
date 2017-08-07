//
//  Wookiee.h
//  Kapitel2
//
//  Created by Rodewig Klaus on 12.07.12.
//  Copyright (c) 2012 Klaus M. Rodewig. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Wookiee : NSObject

@property(copy) NSString *name;

-(id)initWithName:(NSString *)inName;
-(void)sayName;

@end