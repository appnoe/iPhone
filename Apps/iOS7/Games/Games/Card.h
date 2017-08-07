//
//  Card.h
//  Games
//
//  Created by Clemens Wagner on 24.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kCardDidFlippedNotification;
extern NSString * const kCardDidSolvedNotification;

@interface Card : NSObject

@property (nonatomic, readonly) NSUInteger type;
@property (nonatomic) BOOL showsFrontSide;
@property (nonatomic) BOOL solved;
@property (nonatomic) NSUInteger index;

+ (id)cardWithType:(NSUInteger)inType;
- (id)initWithType:(NSUInteger)inType;
- (void)reset;

@end
