#import "GameViewController.h"
#import "Score.h"
#import <QuartzCore/QuartzCore.h>

@implementation GameViewController

- (NSString *)game {
    return nil;
}

- (void)saveScore:(NSUInteger)inScore {
    if(inScore > 0) {
        Score *theScore = [NSEntityDescription insertNewObjectForEntityForName:@"Score"
                                                        inManagedObjectContext:self.managedObjectContext];


        theScore.score = @(inScore);
        theScore.game = self.game;
        [self.managedObjectContext save:NULL];
    }
}

- (void)setupBorderWithLayer:(CALayer *)inLayer {
    inLayer.cornerRadius = 10.0;
    inLayer.masksToBounds = YES;
    inLayer.borderColor = [UIColor grayColor].CGColor;
    inLayer.borderWidth = 1.0;
}

@end
