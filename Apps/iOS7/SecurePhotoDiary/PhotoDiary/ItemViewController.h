#import <UIKit/UIKit.h>
#import "DiaryEntry.h"
#import "AudioRecorderController.h"
#import <Twitter/Twitter.h>

@protocol ItemViewControllerDelegate;

@interface ItemViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate, AudioRecorderDelegate> 

@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UITextView *textView;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *cameraButton;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *photoLibraryButton;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *recordButton;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *playButton;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *tweetButton;

@property (nonatomic, strong) IBOutlet UIToolbar *toolbar;
@property (nonatomic, strong) IBOutlet UIImagePickerController *imagePicker;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) DiaryEntry *diaryEntry;

- (IBAction)takePhoto:(id)inSender;
- (IBAction)takePhotoFromLibrary:(id)inSender;
- (IBAction)composeTweet:(id)sender;

- (IBAction)saveText:(id)inSender;
- (IBAction)revertText:(id)inSender;

@end