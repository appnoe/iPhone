#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>


@interface GameViewController : UIViewController

@property (nonatomic, strong) IBOutlet NSManagedObjectContext *managedObjectContext;
@property (nonatomic, weak) IBOutlet UITabBarItem *highscoreItem;

- (NSString *)game;
- (void)saveScore:(NSUInteger)inScore;
- (void)setupBorderWithLayer:(CALayer *)inLayer;

@end
