#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>


@interface GameViewController : UIViewController {
    @private
}

@property (nonatomic, retain) IBOutlet NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) IBOutlet UITabBarItem *highscoreItem;

- (NSString *)game;
- (void)saveScore:(NSUInteger)inScore;
- (void)setupBorderWithLayer:(CALayer *)inLayer;

@end
