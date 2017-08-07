#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "UIViewController+Games.h"

@interface GameViewController : UIViewController

- (NSString *)game;
- (void)saveScore:(NSUInteger)inScore;
- (void)setupBorderWithLayer:(CALayer *)inLayer;

@end
