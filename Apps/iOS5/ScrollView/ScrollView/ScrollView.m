//
//  ScrollView.m
//  ScrollView
//
//  Created by Clemens Wagner on 25.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ScrollView.h"
#import "LineView.h"

@implementation UIView(ScrollView)

- (BOOL)shouldCancelContentTouches {
    return YES;
}

@end

@implementation ScrollView

- (BOOL)touchesShouldCancelInContentView:(UIView *)inView {
    return [inView shouldCancelContentTouches] && 
        [super touchesShouldCancelInContentView:inView];
}

@end
