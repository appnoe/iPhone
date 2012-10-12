#import "SubviewController.h"

@class MeterView;
@class AudioRecorderController;

@protocol AudioRecorderDelegate<SubviewControllerDelegate>

@optional
-(void)audioRecorder:(AudioRecorderController *)inRecorder didRecordToData:(NSData *)inData;
-(void)audioRecorderDidCancel:(AudioRecorderController *)inRecorder;

@end

@interface AudioRecorderController : SubviewController

@property(nonatomic, assign) IBOutlet UIBarButtonItem *recordButton;
@property(nonatomic, assign) IBOutlet UIProgressView *progressView;
@property(nonatomic, assign) IBOutlet MeterView *meterView;
@property(nonatomic, assign) IBOutlet UILabel *timeLabel;
@property(nonatomic, assign) IBOutlet UIToolbar *toolbar;
@property(nonatomic, assign) IBOutlet UIActivityIndicatorView *activityIndicator;

@property(nonatomic, assign) IBOutlet id<AudioRecorderDelegate> delegate;
@property(nonatomic, readonly) BOOL recording;
@property(nonatomic, readonly) BOOL pausing;
@property (nonatomic, retain, readonly) NSData *data;

- (IBAction)save:(id)inSender;
- (IBAction)cancel:(id)sender;
- (IBAction)flipRecording:(id)inSender;

@end