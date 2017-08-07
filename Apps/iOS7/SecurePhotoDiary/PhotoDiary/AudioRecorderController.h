#import "SubviewController.h"

@class MeterView;
@class AudioRecorderController;

@protocol AudioRecorderDelegate<SubviewControllerDelegate>

@optional
-(void)audioRecorder:(AudioRecorderController *)inRecorder didRecordToData:(NSData *)inData;
-(void)audioRecorderDidCancel:(AudioRecorderController *)inRecorder;

@end

@interface AudioRecorderController : SubviewController

@property(nonatomic, weak) IBOutlet UIBarButtonItem *recordButton;
@property(nonatomic, weak) IBOutlet UIProgressView *progressView;
@property(nonatomic, weak) IBOutlet MeterView *meterView;
@property(nonatomic, weak) IBOutlet UILabel *timeLabel;
@property(nonatomic, weak) IBOutlet UIToolbar *toolbar;
@property(nonatomic, weak) IBOutlet UIActivityIndicatorView *activityIndicator;

@property(nonatomic, weak) IBOutlet id<AudioRecorderDelegate> delegate;
@property(nonatomic, readonly) BOOL recording;
@property(nonatomic, readonly) BOOL pausing;
@property (nonatomic, readonly) NSData *data;

- (IBAction)save:(id)inSender;
- (IBAction)cancel:(id)sender;
- (IBAction)flipRecording:(id)inSender;

@end