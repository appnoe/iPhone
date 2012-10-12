#import "PieViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation PieViewController

@synthesize pieView;
@synthesize valueLabel;
@synthesize animationSwitch;

- (void)dealloc {
    self.pieView = nil;
    self.animationSwitch = nil;
    self.valueLabel = nil;
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *theRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    CATransform3D theTransform = CATransform3DIdentity;
    
    theTransform.m34 = 0.0005;
    self.view.layer.sublayerTransform = theTransform;
    [self.pieView addGestureRecognizer:theRecognizer];
    [theRecognizer release];
}

- (void)viewDidUnload {
    self.pieView = nil;
    self.animationSwitch = nil;
    self.valueLabel = nil;
    [super viewDidUnload];
}

- (IBAction)sliderValueChanged:(id)inSender {
    float theValue = [(UISlider *)inSender value];
    
    self.valueLabel.text = [NSString stringWithFormat:@"%.1f%%", theValue * 100.0];
    if(!animationSwitch.on) {
        self.pieView.part = [(UISlider *)inSender value];                
    }
}

- (IBAction)sliderDidFinish:(id)inSender {
    if(animationSwitch.on) {
        void (^theAnimation)(void) = ^{
            self.pieView.part = [(UISlider *)inSender value];
        };

        [UIView animateWithDuration:3 animations:theAnimation];
    }
}

- (void)handleTap:(UIGestureRecognizer *)inRecognizer {
    CALayer *theLayer = self.pieView.layer;
    CABasicAnimation *theAnimation = [CABasicAnimation animation];
    
    theAnimation.toValue = [NSNumber numberWithFloat:2 * M_PI];
    theAnimation.duration = 3.0;
    [theLayer addAnimation:theAnimation forKey:@"transform.rotation.x"];
    /*
    CABasicAnimation *theAnimation = [CABasicAnimation animation];
    
    theAnimation.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 200, 200)];
    theAnimation.duration = 3.0;
    [theLayer addAnimation:theAnimation forKey:@"bounds"];
     */
    /*
    CABasicAnimation *theAnimation = [CABasicAnimation animation];
    
    theAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, 1.0, 1.0, 0.0)];
    theAnimation.duration = 3.0;
    [theLayer addAnimation:theAnimation forKey:@"transform"];
     */
    /*
    CAKeyframeAnimation *theAnimation = [CAKeyframeAnimation animation];
    
    theAnimation.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0],
                           [NSNumber numberWithFloat:-M_PI / 3.0], 
                           [NSNumber numberWithFloat:M_PI / 3.0], 
                           [NSNumber numberWithFloat:0.0], nil];
    theAnimation.duration = 3.0;
    theAnimation.calculationMode = kCAAnimationPaced;
    [theLayer addAnimation:theAnimation forKey:@"transform.rotation.y"];
     */
    /*
    CAKeyframeAnimation *theAnimation = [CAKeyframeAnimation animation];
    
    theAnimation.values = [NSArray arrayWithObjects:
                           [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, 1.0, 1.0, 0.0)], 
                           [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, 0.0, 1.0, 1.0)], 
                           [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, 1.0, 0.0, 1.0)], 
                           [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, 1.0, 1.0, 1.0)], 
                           nil];
    theAnimation.duration = 3.0;
    theAnimation.calculationMode = kCAAnimationPaced;
    [theLayer addAnimation:theAnimation forKey:@"transform"];
     */
    /*
    CAKeyframeAnimation *theAnimation = [CAKeyframeAnimation animation];
    CGMutablePathRef thePath = CGPathCreateMutable();
    
    CGPathAddEllipseInRect(thePath, NULL, CGRectMake(140.0, 150.0, 20.0, 20.0));
    theAnimation.path = thePath;
    theAnimation.repeatCount = 3;
    theAnimation.autoreverses = YES;
    theAnimation.duration = 0.5;
    [theLayer addAnimation:theAnimation forKey:@"position"];
    CGPathRelease(thePath);
     */
    /*
    CABasicAnimation *theAnimation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    CAAnimationGroup *theGroup = [CAAnimationGroup animation];
     
    theAnimation.toValue = [NSNumber numberWithFloat:160.0];
    theAnimation.duration = 4.0;
    theGroup.duration = 1.0;
    theGroup.animations = [NSArray arrayWithObject:theAnimation];
    theGroup.repeatCount = 3.0;
    [theLayer addAnimation:theGroup forKey:@"group"];
     */
}

@end
