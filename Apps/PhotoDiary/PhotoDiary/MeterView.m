#import "MeterView.h"
#import <QuartzCore/QuartzCore.h>

#define WIDTH 160.0

@implementation MeterView

@synthesize value;

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
}

- (void)setValue:(float)inValue {
    if(value != inValue) {
        value = inValue;
        [self setNeedsDisplay];
    }
}

- (void)clear {
    self.value = -WIDTH;
}

- (void)drawRect:(CGRect)inRect {
    CGRect theBounds = self.bounds;
    CGFloat theValue = theBounds.size.width * self.value / WIDTH;
    UIImage *theImage = [UIImage imageNamed:@"meter.png"];
    
    theBounds.size.width += theValue;
    [theImage drawAsPatternInRect:theBounds];
}

@end
