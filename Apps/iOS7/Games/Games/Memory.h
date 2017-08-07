//
//  Memory.h
//  Games
//
//  Created by Clemens Wagner on 24.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kMemoryDidClearedNotification;
extern NSString * const kMemoryCardsDidSolvedNotification;

extern NSString * const kMemoryUserInfoCardsKey;

@interface Memory : NSObject

@property (nonatomic, readonly) NSUInteger countOfCards;
@property (nonatomic, copy, readonly) NSArray *cards;
@property (copy, readonly) NSArray *flippedCards;
@property (nonatomic, readonly) NSUInteger flipCount;
@property (nonatomic, readonly) NSUInteger cardCount;
@property (nonatomic, readonly) BOOL solved;

+ (id)memoryWithCountOfCards:(NSUInteger)inSize;
- (id)initWithCountOfCards:(NSUInteger)inSize;
- (void)clear;
- (void)checkFlippedCards;
- (void)addPenalty:(NSUInteger)inPenalty;

@end
