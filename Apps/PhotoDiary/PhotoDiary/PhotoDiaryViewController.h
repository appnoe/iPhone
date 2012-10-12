#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "SubviewController.h"

@class DiaryEntry;
@class ItemViewController;
@class DiaryEntryCell;
@class SlideShowController;
@class AudioPlayerController;

@interface PhotoDiaryViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, SubviewControllerDelegate, UISearchDisplayDelegate> 

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet ItemViewController *itemViewController;
@property (nonatomic, retain) IBOutlet NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) IBOutlet DiaryEntryCell *cellPrototype;
@property (nonatomic, retain) IBOutlet SlideShowController *slideShowController;
@property (nonatomic, retain) IBOutlet AudioPlayerController *audioPlayer;
@property (nonatomic, retain) IBOutlet UISearchDisplayController *searchDisplayController;

- (IBAction)showSlideShow;
- (IBAction)addItem;
- (IBAction)playSound:(id)inSender;
- (UITableView *)currentTableView;
- (DiaryEntry *)entryForTableView:(UITableView *)inTableView atIndexPath:(NSIndexPath *)inIndexPath;

@end
