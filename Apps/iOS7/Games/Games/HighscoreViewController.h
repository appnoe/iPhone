#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface HighscoreViewController : UITableViewController

@property (nonatomic, strong) IBOutlet NSManagedObjectContext *managedObjectContext;
@property (nonatomic, weak) IBOutlet UISegmentedControl *filterControl;

- (IBAction)filterChanged;
- (IBAction)clear;

@end
