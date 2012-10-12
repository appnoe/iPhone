#import <UIKit/UIKit.h>

@interface AnimationViewController : UIViewController {
    @private
    UISegmentedControl *curveSegment;
}

@property (nonatomic, retain) IBOutlet UIView *squareView;
@property (nonatomic, retain) IBOutlet UISegmentedControl *curveSegment;

- (IBAction)flipAnimation:(id)inSender;

@end
