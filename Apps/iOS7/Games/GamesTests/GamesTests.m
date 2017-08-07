//
//  GamesTests.m
//  GamesTests
//
//  Created by Clemens Wagner on 19.08.13.
//  Copyright (c) 2013 Cocoaneheads. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Puzzle.h"

@interface GamesTests : XCTestCase

@property (nonatomic, strong) Puzzle *puzzle;
@property (nonatomic, strong) NSNotification *notification;

@end

@implementation GamesTests

- (void)setUp {
    [super setUp];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(puzzleDidTilt:) name:kPuzzleDidTiltNotification object:nil];
    self.puzzle = [Puzzle puzzleWithLength:4];
    self.notification = nil;
}

- (void)tearDown {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.notification = nil;
    self.puzzle = nil;
    [super tearDown];
}

- (void)puzzleDidTilt:(NSNotification *)inNotification {
    self.notification = inNotification;
}

- (void)checkNotificationWithName:(NSString *)inName fromIndex:(NSUInteger)inFromIndex toIndex:(NSUInteger)inToIndex {
    NSDictionary *theUserInfo = self.notification.userInfo;
    NSUInteger theFromIndex = [[theUserInfo valueForKey:kPuzzleFromIndexKey] unsignedIntValue];
    NSUInteger theToIndex = [[theUserInfo valueForKey:kPuzzleToIndexKey] unsignedIntValue];

    XCTAssertNotNil(self.notification, @"notification is nil");
    XCTAssertNotNil(theUserInfo, @"userInfo is nil");
    XCTAssertTrue(self.puzzle == self.notification.object, @"invalid puzzle");
    XCTAssertEqual(inName, self.notification.name, @"invalid name %@ != %@", inName, self.notification.name);
    XCTAssertTrue(inFromIndex == theFromIndex, @"invalid from index: %u != %u", inFromIndex, theFromIndex);
    XCTAssertTrue(inToIndex == theToIndex, @"invalid from index: %u != %u", inToIndex, theToIndex);
    self.notification = nil;
}


- (void)testCreation {
    XCTAssertTrue(self.puzzle.length == 4, @"invalid length = %d", self.puzzle.length);
    XCTAssertTrue(self.puzzle.size == 16, @"invalid size = %d", self.puzzle.size);
    for(NSUInteger i = 0; i < self.puzzle.size; ++i) {
        NSUInteger theValue = [self.puzzle valueAtIndex:i];

        XCTAssertEqual(theValue, i, @"invalid value %d at index %d", theValue, i);
    }
}

- (void)testComplexMove {
    static NSUInteger theValues[] = {
        0, 1, 2, 3, 4, 15, 6, 7, 8, 5, 9, 11, 12, 13, 10, 14
    };

    XCTAssertTrue([self.puzzle tiltToDirection:PuzzleDirectionRight], @"Can't tilt right.");
    XCTAssertTrue([self.puzzle tiltToDirection:PuzzleDirectionDown], @"Can't tilt down.");
    XCTAssertTrue([self.puzzle tiltToDirection:PuzzleDirectionRight], @"Can't tilt right.");
    XCTAssertTrue([self.puzzle tiltToDirection:PuzzleDirectionDown], @"Can't tilt down.");
    XCTAssertTrue(self.puzzle.freeIndex == 5, @"invalid free index: %u", self.puzzle.freeIndex);
    for(NSUInteger i = 0; i < self.puzzle.size; ++i) {
        NSUInteger theValue = [self.puzzle valueAtIndex:i];

        XCTAssertTrue(theValue == theValues[i], @"invalid value %d (%d) at index %d", theValue, theValues[i], i);
    }
}

- (void)testInvalidMoves {
    XCTAssertFalse([self.puzzle tiltToDirection:PuzzleDirectionLeft], @"tilt left.");
    XCTAssertNil(self.notification, @"notification sent");
    XCTAssertTrue(self.puzzle.solved, @"puzzle not solved");
    XCTAssertFalse([self.puzzle tiltToDirection:PuzzleDirectionUp], @"tilt up.");
    XCTAssertNil(self.notification, @"notification sent");
    XCTAssertTrue(self.puzzle.solved, @"puzzle not solved");
}


@end
