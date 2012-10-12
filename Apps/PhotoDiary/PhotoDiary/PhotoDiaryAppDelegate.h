#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class PhotoDiaryViewController;

@interface PhotoDiaryAppDelegate : NSObject <UIApplicationDelegate, UISplitViewControllerDelegate> 

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *overviewButton;
@property (nonatomic, retain) IBOutlet UIViewController *viewController;
@property (nonatomic, retain) IBOutlet NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) UIPopoverController *popoverController;

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *storeCoordinator;

@end
