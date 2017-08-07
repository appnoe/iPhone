#import "SubviewController.h"

@class MeterView;
@class Medium;

@interface AudioPlayerController : SubviewController 

@property (nonatomic, weak) IBOutlet UIBarButtonItem *playButton;
@property (nonatomic, weak) IBOutlet UISlider *slider;
@property (nonatomic, weak) IBOutlet MeterView *meterView;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *activityIndicator;

@property(nonatomic) Medium *audioMedium;
@property(nonatomic) NSTimeInterval time;

- (IBAction)stop;
- (IBAction)flipPlayback;
- (IBAction)startSearching;
- (IBAction)updatePosition;

- (IBAction)updateTimeLabel;

@end
