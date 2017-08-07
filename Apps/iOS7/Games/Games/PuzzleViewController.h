#import "GameViewController.h"

@class Puzzle;
@class NumberView;

@interface PuzzleViewController : GameViewController

@property (nonatomic, strong) Puzzle *puzzle;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, weak) IBOutlet UIView *puzzleView;
@property (nonatomic, weak) IBOutlet NumberView *scoreView;

- (IBAction)shuffle;
- (IBAction)clear;
- (IBAction)undo;
- (IBAction)redo;

@end
