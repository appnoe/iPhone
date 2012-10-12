#import "GameViewController.h"
#import "Memory.h"
#import "NumberView.h"

@interface MemoryViewController : GameViewController {
    @private
}

@property (nonatomic, retain, readonly) Memory *memory;
@property (nonatomic, retain) IBOutlet UIView *memoryView;
@property (nonatomic, retain) IBOutlet NumberView *scoreView;

- (IBAction)clear;
- (IBAction)help;

@end
