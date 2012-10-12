#import "PieView.h"
#import "PieLayer.h"

@implementation PieView

+ (Class)layerClass {
    return [PieLayer class];
}

- (void)setupLayer {
    CALayer *theLayer = self.layer;
    
    theLayer.cornerRadius = 10.0;
    theLayer.borderColor = [UIColor blueColor].CGColor;
    theLayer.borderWidth = 2.0;
    
    theLayer.shadowColor = [UIColor blackColor].CGColor;
    theLayer.shadowOffset = CGSizeMake(5.0, 5.0);
    theLayer.shadowOpacity = 0.5;
}

- (id)initWithFrame:(CGRect)inFrame {
    self = [super initWithFrame:inFrame];
    if (self) {
        [self setupLayer];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupLayer];
}

- (CGFloat)part {
    return [(PieLayer *)self.layer part];
}

- (void)setPart:(CGFloat)inPart {
    [(PieLayer *)self.layer setPart:inPart];
}

- (id<CAAction>)actionForLayer:(CALayer *)inLayer forKey:(NSString *)inKey {
    if([kPartKey isEqualToString:inKey]) {
        CABasicAnimation *theAnimation = (id)[inLayer actionForKey:@"opacity"];
        
        theAnimation.keyPath = inKey;
        theAnimation.fromValue = [inLayer valueForKey:kPartKey];
        theAnimation.toValue = nil;
        theAnimation.byValue = nil;
        return theAnimation;
    }
    else {
        return [super actionForLayer:inLayer forKey:inKey];
    }
}

@end
