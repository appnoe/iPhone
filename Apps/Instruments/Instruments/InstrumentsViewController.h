#import <UIKit/UIKit.h>

@interface InstrumentsViewController : UIViewController {
    @private
}

@property (nonatomic, retain) IBOutlet UILabel *sumLabel;

- (IBAction)makeZombie;
- (IBAction)makeLeak;
- (IBAction)makeAttributeLeak;
- (IBAction)makeAttributeZombie;
- (IBAction)computeSum;

@end
