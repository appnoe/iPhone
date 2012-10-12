#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface SlideShowController : UIViewController

@property (nonatomic, retain) IBOutletCollection(UIImageView) NSArray *imageViews;
@property (nonatomic, retain) IBOutlet UILabel *textLabel;
@property (nonatomic, retain) IBOutlet NSManagedObjectContext *managedObjectContext;

@end
