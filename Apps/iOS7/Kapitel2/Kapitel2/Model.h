//
//  Model.h
//  Kapitel2
//
//  Created by Rodewig Klaus on 11.05.12.
//  Copyright (c) 2012 Klaus M. Rodewig. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Model : NSObject

@property(copy) NSString *status;
@property(strong) NSDate *creation;
@property(copy, readonly) NSString *name;

-(instancetype)initWithName:(NSString *)inName;

- (int)countOfObjects;

-(void)listDroids;
-(void)updateDroids:(int)inValue;

@end
