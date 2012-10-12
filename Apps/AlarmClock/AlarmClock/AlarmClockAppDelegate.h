#import <UIKit/UIKit.h>

@class AlarmClockViewController;

@interface AlarmClockAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) NSNumber *soundId;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet AlarmClockViewController *viewController;

@end

