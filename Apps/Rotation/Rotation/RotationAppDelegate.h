#import <UIKit/UIKit.h>

@class RotationViewController;

@interface RotationAppDelegate : NSObject <UIApplicationDelegate> {
    @private
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet RotationViewController *viewController;

@end
