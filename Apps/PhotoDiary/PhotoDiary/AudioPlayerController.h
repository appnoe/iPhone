#import "SubviewController.h"

@class MeterView;
@class Medium;

@interface AudioPlayerController : SubviewController 

@property (nonatomic, assign) IBOutlet UIBarButtonItem *playButton;
@property (nonatomic, assign) IBOutlet UISlider *slider;
@property (nonatomic, assign) IBOutlet MeterView *meterView;
@property (nonatomic, assign) IBOutlet UILabel *timeLabel;
@property (nonatomic, assign) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, assign) IBOutlet UIToolbar *toolbar;

@property(nonatomic, retain) Medium *audioMedium;
@property(nonatomic) NSTimeInterval time;

- (IBAction)stop;
- (IBAction)flipPlayback;
- (IBAction)startSearching;
- (IBAction)updatePosition;

- (IBAction)updateTimeLabel;

@end
