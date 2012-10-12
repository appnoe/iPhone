//
//  NumberView.h
//  Games
//
//  Created by Clemens Wagner on 18.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NumberView : UIView {
    @private
}

@property (nonatomic) NSUInteger value;

- (void)setValue:(NSUInteger)inValue animated:(BOOL)inAnimated;

@end
