#import <Foundation/Foundation.h>

@interface UIView(MirrorImage)

- (UIImage *)mirroredImageWithScale:(CGFloat)inScale;
- (void)drawMirrorWithScale:(CGFloat)inScale;

@end
