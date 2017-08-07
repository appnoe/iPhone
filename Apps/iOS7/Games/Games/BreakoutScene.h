//
//  BreakoutMyScene.h
//  Breakout
//

//  Copyright (c) 2014 Clemens Wagner. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface BreakoutScene : SKScene

@property (nonatomic, readonly) BOOL isRunning;
@property (nonatomic, readonly) NSUInteger score;

@end