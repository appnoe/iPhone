//
//  CardView.h
//  Games
//
//  Created by Clemens Wagner on 23.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CardView : UIControl {
    @private
}

@property (nonatomic) NSUInteger type;
@property (nonatomic) BOOL showsFrontSide;

- (void)showFrontSide:(BOOL)inShow withAnimationCompletion:(void (^)(BOOL inFinished))inCompletion;

@end