#import <UIKit/UIKit.h>

typedef enum {
    DigitViewAnimationDirectionBackward = -1,
    DigitViewAnimationDirectionNone = 0,
    DigitViewAnimationDirectionForward = 1
} DigitViewAnimationDirection;

@interface DigitView : UIView {
    @private
}

@property (nonatomic, retain) UIFont *font;
@property (nonatomic) NSUInteger digit;

- (void)setDigit:(NSUInteger)inDigit direction:(DigitViewAnimationDirection)inDirection;
- (void)addOffset:(NSInteger)inOffset animated:(BOOL)inAnimated;

@end
