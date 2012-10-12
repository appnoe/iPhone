#import <UIKit/UIKit.h>
#import "DiaryEntry.h"
#import "AudioPlayerController.h"
#import "AudioRecorderController.h"

@protocol ItemViewControllerDelegate;

@interface ItemViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate, AudioRecorderDelegate> 

@property (nonatomic, assign) IBOutlet UIImageView *imageView;
@property (nonatomic, assign) IBOutlet UITextView *textView;
@property (nonatomic, assign) IBOutlet UIBarButtonItem *cameraButton;
@property (nonatomic, assign) IBOutlet UIBarButtonItem *photoLibraryButton;
@property (nonatomic, assign) IBOutlet UIBarButtonItem *recordButton;
@property (nonatomic, assign) IBOutlet UIBarButtonItem *playButton;

@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) IBOutlet UIImagePickerController *imagePicker;
@property (nonatomic, retain) IBOutlet AudioRecorderController *audioRecorder;
@property (nonatomic, retain) IBOutlet AudioPlayerController *audioPlayer;
@property (nonatomic, retain) NSIndexPath *indexPath;
@property (nonatomic, retain) DiaryEntry *diaryEntry;

- (IBAction)takePhoto:(id)inSender;
- (IBAction)takePhotoFromLibrary:(id)inSender;
- (IBAction)recordAudio:(id)inSender;
- (IBAction)playAudio:(id)inSender;

- (IBAction)saveText:(id)inSender;
- (IBAction)revertText:(id)inSender;

@end