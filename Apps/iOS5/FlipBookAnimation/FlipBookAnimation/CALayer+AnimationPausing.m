//
//  CALayer+AnimationPausing.m
//  FlipBookAnimation
//
//  Created by Clemens Wagner on 02.09.12.
//  Copyright (c) 2012 Clemens Wagner. All rights reserved.
//

#import "CALayer+AnimationPausing.h"

@implementation CALayer (AnimationPausing)

-(void)pause {
    CFTimeInterval theCurrentTime = CACurrentMediaTime();
    CFTimeInterval theTime = [self convertTime:theCurrentTime fromLayer:nil];
    
    self.speed = 0.0;
    self.timeOffset = theTime;
}

-(void)resume {
    CFTimeInterval theTime = self.timeOffset;
    
    self.speed = 1.0;
    self.timeOffset = 0.0;
    self.beginTime = 0.0;
    theTime = [self convertTime:CACurrentMediaTime() fromLayer:nil] - theTime;
    self.beginTime = theTime;
}

- (BOOL)isPausing {
    return self.speed == 0;
}

@end
