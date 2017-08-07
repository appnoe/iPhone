#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class PhotoDiaryViewController;

@interface SecurePhotoDiaryAppDelegate : NSObject <UIApplicationDelegate, UISplitViewControllerDelegate> 

@property (nonatomic, strong) IBOutlet UIWindow *window;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *overviewButton;
@property (nonatomic, strong) IBOutlet UIViewController *viewController;
@property (nonatomic, strong) IBOutlet NSManagedObjectContext *managedObjectContext;

@property (nonatomic, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, readonly) NSPersistentStoreCoordinator *storeCoordinator;

@end
