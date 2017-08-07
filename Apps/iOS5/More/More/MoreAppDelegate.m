#import "MoreAppDelegate.h"

@implementation MoreAppDelegate

- (BOOL)application:(UIApplication *)inApplication didFinishLaunchingWithOptions:(NSDictionary *)inLaunchOptions {
    NSArray *theControllers;
    NSUInteger theIndex = 0;
    
    self.tabBarController = (UITabBarController *) self.window.rootViewController;
    self.tabBarController.delegate = self;
    theControllers = self.tabBarController.viewControllers;
    for(UIViewController *theController in theControllers) {
        theController.tabBarItem.tag = theIndex++;
    }
    [self restoreTabBar];
    return YES;
}

- (void)restoreTabBar {
    NSUserDefaults *theDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *theIndexes = [theDefaults arrayForKey:@"tabBarItems"];
    NSArray *theViewControllers = self.tabBarController.viewControllers;

    if(theIndexes.count == theViewControllers.count) {
        NSMutableArray *theControllers = [NSMutableArray arrayWithCapacity:theIndexes.count];

        for(NSNumber *theIndex in theIndexes) {
            NSUInteger theValue = theIndex.unsignedIntValue;
            [theControllers addObject:[theViewControllers objectAtIndex:theValue]];
        }
        self.tabBarController.viewControllers = theControllers;
    }
}

# pragma mark UITabBarControllerDelegate

- (void)tabBarController:(UITabBarController *)inController willEndCustomizingViewControllers:(NSArray *)inControllers changed:(BOOL)inChanged {
    if(inChanged) {
        NSArray *theIndexes = [inControllers valueForKeyPath:@"tabBarItem.tag"];
        NSUserDefaults *theDefaults = [NSUserDefaults standardUserDefaults];
        
        [theDefaults setObject:theIndexes forKey:@"tabBarItems"];
        [theDefaults synchronize];
    }
}

@end
