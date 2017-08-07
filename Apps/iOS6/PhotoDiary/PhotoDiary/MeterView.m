#import "MeterView.h"
#import <QuartzCore/QuartzCore.h>

@implementation MeterView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;
}

- (void)setValue:(float)inValue {
    if(self.value != inValue) {
        _value = fmin(fmax(inValue, 0.0), 1.0);
        [self setNeedsDisplay];
    }
}

- (void)clear {
    self.value = 0.0;
}

- (void)drawRect:(CGRect)inRect {
    CGRect theBounds = self.bounds;
    UIImage *theImage = [UIImage imageNamed:@"meter.png"];
    
    theBounds.size.width *= self.value;
    [theImage drawAsPatternInRect:theBounds];
}

@end
