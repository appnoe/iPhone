#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "SubviewController.h"

@class DiaryEntry;
@class ItemViewController;
@class DiaryEntryCell;
@class SlideShowController;
@class AudioPlayerController;

@interface PhotoDiaryViewController : UITableViewController<SubviewControllerDelegate, UISearchDisplayDelegate> 

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UISearchDisplayController *searchDisplayController;

- (IBAction)addItem;
- (IBAction)playSound:(id)inSender;
- (UITableView *)currentTableView;
- (DiaryEntry *)entryForTableView:(UITableView *)inTableView atIndexPath:(NSIndexPath *)inIndexPath;
@end
