#import <UIKit/UIKit.h>
#import "PieView.h"

@interface PieViewController : UIViewController {
    @private
}

@property (nonatomic, retain) IBOutlet PieView *pieView;
@property (nonatomic, retain) IBOutlet UILabel *valueLabel;
@property (nonatomic, retain) IBOutlet UISwitch *animationSwitch;

- (IBAction)sliderValueChanged:(id)inSender;
- (IBAction)sliderDidFinish:(id)inSender;

@end
