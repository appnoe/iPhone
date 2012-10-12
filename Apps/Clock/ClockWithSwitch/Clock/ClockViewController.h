#import <UIKit/UIKit.h>

@class ClockView;

@interface ClockViewController : UIViewController {
	@private
}

@property(nonatomic, assign) IBOutlet ClockView *clockView;
@property(nonatomic, assign) IBOutlet UISwitch *clockSwitch;

- (IBAction)switchAnimation:(UISwitch *)inSender;

@end

