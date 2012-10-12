#import "PieLayer.h"

NSString * const kPartKey = @"part";

@implementation PieLayer

@dynamic part;

+ (id)defaultValueForKey:(NSString *)inKey {
    return [kPartKey isEqualToString:inKey] ? 
        [NSNumber numberWithFloat:0.0] : [super defaultValueForKey:inKey];
}

- (void)drawInContext:(CGContextRef)inContext {
    CGRect theBounds = self.bounds;
    CGSize theSize = theBounds.size;
    CGFloat thePart = self.part;
    CGPoint theCenter = CGPointMake(CGRectGetMidX(theBounds), CGRectGetMidY(theBounds));
    CGFloat theRadius = fminf(theSize.width, theSize.height) / 2.0 - 5.0;
    CGFloat theAngle = 2 * (thePart - 0.25) * M_PI;
    
    CGContextSaveGState(inContext);
    CGContextSetFillColorWithColor(inContext, [UIColor redColor].CGColor);
    CGContextMoveToPoint(inContext, theCenter.x, theCenter.y);
    CGContextAddArc(inContext, theCenter.x, theCenter.y, theRadius, -M_PI / 2.0, theAngle, NO);
    CGContextAddLineToPoint(inContext, theCenter.x, theCenter.y);
    CGContextFillPath(inContext);
    CGContextRestoreGState(inContext);
}

+ (BOOL)needsDisplayForKey:(NSString *)inKey {
    return [kPartKey isEqualToString:inKey] || [super needsDisplayForKey:inKey];
}

@end