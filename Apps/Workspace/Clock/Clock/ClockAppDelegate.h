#import <UIKit/UIKit.h>

@class ClockViewController;

@interface ClockAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    ClockViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet ClockViewController *viewController;

@end

