#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface SlideShowController : UIViewController

@property (nonatomic, strong) IBOutletCollection(UIImageView) NSArray *imageViews;
@property (nonatomic, weak) IBOutlet UILabel *textLabel;

@end
