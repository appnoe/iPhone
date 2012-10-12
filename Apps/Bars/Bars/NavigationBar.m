#import "NavigationBar.h"

@implementation NavigationBar

- (void)drawRect:(CGRect)inRect {
    UIImage *theImage = [UIImage imageNamed:@"background.png"];
    
    [theImage drawAsPatternInRect:self.bounds];
}

@end