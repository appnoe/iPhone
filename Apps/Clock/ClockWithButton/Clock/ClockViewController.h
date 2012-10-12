#import <UIKit/UIKit.h>

@class ClockView;

@interface ClockViewController : UIViewController {
	@private
}

@property(nonatomic, assign) IBOutlet ClockView *clockView;
@property(nonatomic, assign) IBOutlet UIButton *switchButton;

- (IBAction)switchAnimation:(UIButton *)inSender;

@end

