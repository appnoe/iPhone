#import <UIKit/UIKit.h>

@class InstrumentsViewController;

@interface InstrumentsAppDelegate : NSObject <UIApplicationDelegate> {
    @private
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet InstrumentsViewController *viewController;

@end
