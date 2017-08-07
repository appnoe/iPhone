//
//  CALayer+AnimationPausing.h
//  FlipBookAnimation
//
//  Created by Clemens Wagner on 02.09.12.
//  Copyright (c) 2012 Clemens Wagner. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CALayer (AnimationPausing)

- (void)pause;
- (void)resume;
- (BOOL)isPausing;

@end
