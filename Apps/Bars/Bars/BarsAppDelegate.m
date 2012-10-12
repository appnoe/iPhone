#import "BarsAppDelegate.h"

@implementation BarsAppDelegate

@synthesize window;
@synthesize viewController;

- (BOOL)application:(UIApplication *)inApplication didFinishLaunchingWithOptions:(NSDictionary *)inOptions {
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)dealloc {
    self.viewController = nil;
    self.window = nil;
    [super dealloc];
}

@end
