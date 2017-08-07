#import "GameViewController.h"
#import "Memory.h"
#import "NumberView.h"

@interface MemoryViewController : GameViewController {
    @private
}

@property (nonatomic, strong, readonly) Memory *memory;
@property (nonatomic, weak) IBOutlet UIView *memoryView;
@property (nonatomic, weak) IBOutlet NumberView *scoreView;

- (IBAction)clear;
- (IBAction)help;

@end
