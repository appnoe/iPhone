//
//  Puzzle.h
//  Games
//
//  Created by Clemens Wagner on 11.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    PuzzleDirectionUp = 0,
    PuzzleDirectionRight,
    PuzzleDirectionDown,
    PuzzleDirectionLeft,
    PuzzleNoDirection
} PuzzleDirection;

extern PuzzleDirection PuzzleDirectionRevert(PuzzleDirection inDerection);

extern NSString * const kPuzzleDidTiltNotification;
extern NSString * const kPuzzleDidMoveNotification;
extern NSString * const kPuzzleDirectionKey;
extern NSString * const kPuzzleFromIndexKey;
extern NSString * const kPuzzleToIndexKey;

@interface Puzzle : NSObject {
    @private
    NSInteger offsets[4];
}

@property (nonatomic, readonly) NSUInteger length;
@property (nonatomic, readonly) NSUInteger size;
@property (nonatomic, readonly) NSUInteger freeIndex;
@property (nonatomic, readonly) BOOL solved;
@property (nonatomic, readonly) NSUInteger moveCount;
@property (nonatomic, assign) NSUndoManager *undoManager;

+ (id)puzzleWithLength:(NSUInteger)inLength;
- (id)initWithLength:(NSUInteger)inLength;
- (void)shuffle;
- (BOOL)tiltToDirection:(PuzzleDirection)inDirection;
- (BOOL)moveItemAtIndex:(NSUInteger)inIndex toDirection:(PuzzleDirection)inDirection;
- (NSUInteger)valueAtIndex:(NSUInteger)inIndex;
- (PuzzleDirection)bestDirectionForIndex:(NSUInteger)inIndex;

@end
