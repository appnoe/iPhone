#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface GamesAppDelegate : NSObject<UIApplicationDelegate>

@property (nonatomic, strong) IBOutlet UIWindow *window;
@property (nonatomic, strong) IBOutlet UITabBarController *viewController;
@property (nonatomic, strong) IBOutlet NSManagedObjectContext *managedObjectContext;

@property (nonatomic, strong, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *storeCoordinator;

@end
