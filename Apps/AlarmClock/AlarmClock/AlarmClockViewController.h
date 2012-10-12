#import <UIKit/UIKit.h>

@class ClockView;
@class ClockControl;

@interface AlarmClockViewController : UIViewController

@property(nonatomic, assign) IBOutlet ClockView *clockView;
@property(nonatomic, assign) IBOutlet ClockControl *clockControl;
@property(nonatomic, assign) IBOutlet UISwitch *alarmSwitch;
@property(nonatomic, assign) IBOutlet UILabel *timeLabel;

- (IBAction)updateAlarm;
- (IBAction)updateTimeLabel;

@end

