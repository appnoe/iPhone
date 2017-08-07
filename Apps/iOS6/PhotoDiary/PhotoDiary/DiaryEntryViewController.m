//
//  DiaryEntryViewController.m
//  PhotoDiary
//
//  Created by Clemens Wagner on 10.09.13.
//  Copyright (c) 2013 Cocoaneheads. All rights reserved.
//

#import "DiaryEntryViewController.h"
#import "UIImage+ImageTools.h"
#import "UINavigationController+BarManagement.h"
#import "AudioPlayerController.h"
#import "AudioRecorderController.h"
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>
#import "DiaryEntryExportActvity.h"

@interface DiaryEntryViewController()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate, AudioRecorderDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (nonatomic, weak) IBOutlet UIBarButtonItem *cameraButton;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *photoLibraryButton;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *recordButton;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *playButton;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *shareButton;

@property (nonatomic, strong) UIImagePickerController *imagePicker;

- (IBAction)takePhoto:(id)inSender;
- (IBAction)takePhotoFromLibrary:(id)inSender;
- (IBAction)toggleBars:(id)sender;
- (IBAction)shareDiaryEntry:(id)sender;

@end

@implementation DiaryEntryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *theView = self.textView;
    CALayer *theLayer = theView.layer;
    UIColor *theColor = [theView respondsToSelector:@selector(tintColor)] ? theView.tintColor : [UIColor blueColor];

    theLayer.borderColor = [theColor CGColor];
    theLayer.borderWidth = 1.0;
    self.imagePicker = [[UIImagePickerController alloc] init];
    self.imagePicker.allowsEditing = YES;
    self.imagePicker.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    self.imagePicker.delegate = self;
    self.cameraButton.enabled = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    self.photoLibraryButton.enabled = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
    self.recordButton.enabled = [[AVAudioSession sharedInstance] inputIsAvailable];
    self.shareButton.enabled = NO;
}

- (void)viewWillAppear:(BOOL)inAnimated {
    [super viewWillAppear:inAnimated];

    self.navigationController.barsHidden = NO;
    [self applyDiaryEntry];
}

- (void)viewDidAppear:(BOOL)inAnimated {
    [super viewDidAppear:inAnimated];
    NSNotificationCenter *theCenter = [NSNotificationCenter defaultCenter];

    [theCenter addObserver:self
                  selector:@selector(keyboardWillAppear:)
                      name:UIKeyboardWillShowNotification
                    object:nil];
    [theCenter addObserver:self
                  selector:@selector(keyboardWillDisappear:)
                      name:UIKeyboardWillHideNotification
                    object:nil];
    [self.navigationController hideBarsWithDelay:2.0];
}

- (void)viewWillDisappear:(BOOL)inAnimated {
    NSNotificationCenter *theCenter = [NSNotificationCenter defaultCenter];

    [theCenter removeObserver:theCenter];
    self.imageView.image = nil;
    [self.navigationController setBarsHidden:NO animated:YES];
    [super viewWillDisappear:inAnimated];
}

- (CGRect)visibleBounds {
    CGRect theBounds = self.view.bounds;

    if([self respondsToSelector:@selector(topLayoutGuide)] &&
       [self respondsToSelector:@selector(bottomLayoutGuide)]) {
        theBounds.origin.y = [self.topLayoutGuide length];
        theBounds.size.height -= [self.topLayoutGuide length] + [self.bottomLayoutGuide length];
    }
    return theBounds;
}

- (void)applyDiaryEntry {
    CGFloat theScale = [[UIScreen mainScreen] scale];
    Medium *theMedium = [self.diaryEntry mediumForType:kMediumTypeImage];
    UIImage *theImage = [UIImage imageWithData:theMedium.data scale:theScale];

    self.textView.text = self.diaryEntry.text;
    self.imageView.image = theImage;
    self.playButton.enabled = [self.diaryEntry mediumForType:kMediumTypeAudio] != nil;
    self.shareButton.enabled = [self hasSharableContent];
}

- (void)showPickerWithSourceType:(UIImagePickerControllerSourceType)inSourceType {
    if([UIImagePickerController isSourceTypeAvailable:inSourceType]) {
        self.imagePicker.sourceType = inSourceType;
        [self presentViewController:self.imagePicker animated:YES completion:NULL];
    }
}

- (NSManagedObjectContext *)managedObjectContext {
    return self.diaryEntry.managedObjectContext;
}

- (void)updateMediumData:(NSData *)inData withMediumType:(NSString *)inType {
    if(inData.length == 0) {
        [self.diaryEntry removeMediumForType:inType];
    }
    else {
        Medium *theMedium = [NSEntityDescription insertNewObjectForEntityForName:@"Medium"
                                                          inManagedObjectContext:self.managedObjectContext];

        theMedium.type = inType;
        theMedium.data = inData;
        [self.diaryEntry addMedium:theMedium];
    }
    [self saveDiaryEntry];
}

- (BOOL)hasSharableContent {
    DiaryEntry *theEntry = self.diaryEntry;

    return theEntry.text.length > 0 || [theEntry mediumForType:kMediumTypeImage] != nil;
}

- (BOOL)saveDiaryEntry {
    BOOL theResult = NO;
    NSError *theError = nil;

    theResult = [self.managedObjectContext save:&theError];
    if(!theResult) {
        NSLog(@"saveItem: %@", theError);
    }
    self.shareButton.enabled = [self hasSharableContent];
    return theResult;
}

- (void)saveImage:(UIImage *)inImage {
    NSData *theData = UIImageJPEGRepresentation(inImage, 0.8);
    CGSize theIconSize = [inImage sizeToAspectFitInSize:CGSizeMake(60.0, 60.0)];
    UIImage *theImage = [inImage scaledImageWithSize:theIconSize];

    self.diaryEntry.icon = UIImageJPEGRepresentation(theImage, 0.8);
    [self updateMediumData:theData withMediumType:kMediumTypeImage];
}

- (NSArray *)activityItems {
    NSMutableArray *theItems = [NSMutableArray array];
    Medium *theMedium = [self.diaryEntry mediumForType:kMediumTypeImage];
    NSString *theText = self.diaryEntry.text;

    if(theMedium != nil) {
        CGFloat theScale = [[UIScreen mainScreen] scale];
        UIImage *theImage = [UIImage imageWithData:theMedium.data scale:theScale];

        [theItems addObject:theImage];
    }
    if([theText length] > 0) {
        [theItems addObject:theText];
    }
    [theItems addObject:self.diaryEntry];
    return [theItems copy];
}

- (IBAction)shareDiaryEntry:(id)inSender {
    DiaryEntryExportActvity *theActivity = [[DiaryEntryExportActvity alloc] init];
    NSArray *theItems = self.activityItems;
    UIActivityViewController *theController = [[UIActivityViewController alloc] initWithActivityItems:theItems applicationActivities:@[theActivity]];

    theActivity.storyboard = self.storyboard;
    [self presentViewController:theController animated:YES completion:NULL];
}

- (IBAction)takePhoto:(id)inSender {
    [self showPickerWithSourceType:UIImagePickerControllerSourceTypeCamera];
}

- (IBAction)takePhotoFromLibrary:(id)inSender {
    [self showPickerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (IBAction)toggleBars:(id)inSender {
    UINavigationController *theController = self.navigationController;
    BOOL theHiddenFlag = theController.barsHidden;

    [theController setBarsHidden:!theHiddenFlag animated:YES];
    if(theHiddenFlag) {
        [theController hideBarsWithDelay:2.0];
    }
}


- (IBAction)saveText:(id)inSender {
    [self.view endEditing:YES];
    self.diaryEntry.text = self.textView.text;
    [self saveDiaryEntry];
}

- (IBAction)revertText:(id)inSender {
    [self.view endEditing:YES];
    [self applyDiaryEntry];
}

- (void)prepareForSegue:(UIStoryboardSegue *)inSegue sender:(id)inSender {
    if([inSegue.identifier isEqualToString:@"player"]) {
        AudioPlayerController *thePlayer = inSegue.destinationViewController;

        thePlayer.audioMedium = [self.diaryEntry mediumForType:kMediumTypeAudio];
    }
    else if([inSegue.identifier isEqualToString:@"recorder"]) {
        AudioRecorderController *theRecorder = inSegue.destinationViewController;

        theRecorder.delegate = self;
    }
}

#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)inPicker
didFinishPickingMediaWithInfo:(NSDictionary *)inInfo {
    UIImage *theImage = [inInfo valueForKey:UIImagePickerControllerEditedImage];

    self.diaryEntry.icon = nil;
    self.imageView.image = theImage;
    [self saveImage:theImage];
    [inPicker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)inPicker {
    self.shareButton.enabled = [self hasSharableContent];
    [inPicker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark Keyboard notifications

- (void)keyboardWillAppear:(NSNotification *)inNotification {
    if([self.textView isFirstResponder]) {
        NSValue *theValue = inNotification.userInfo[UIKeyboardFrameEndUserInfoKey];
        NSNumber *theDuration = inNotification.userInfo[UIKeyboardAnimationDurationUserInfoKey];
        UIView *theView = self.view;
        CGRect theFrame = [theView.window convertRect:[theValue CGRectValue] toView:theView];
        CGFloat theY;

        [self.navigationController setBarsHidden:YES animated:YES];
        theY = CGRectGetMinY(self.visibleBounds);
        theFrame = CGRectMake(0.0, theY,
                              CGRectGetWidth(self.view.frame),
                              CGRectGetMinY(theFrame) - theY);
        theFrame = [theView convertRect:theFrame toView:self.textView.superview];
        [UIView animateWithDuration:[theDuration doubleValue] animations:^{
            self.textView.frame = theFrame;
        }];
    }
}

- (void)keyboardWillDisappear:(NSNotification *)inNotification {
    NSNumber *theDuration = inNotification.userInfo[UIKeyboardAnimationDurationUserInfoKey];

    [self.navigationController setBarsHidden:YES animated:YES];
    [UIView animateWithDuration:[theDuration doubleValue] animations:^{
        self.textView.frame = CGRectInset(self.textView.superview.bounds, 10.0, 10.0);
    }];
}

#pragma mark UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)inRecognizer {
    UIView *theView = self.textView;
    CGPoint thePoint = [inRecognizer locationInView:theView];

    return !CGRectContainsPoint(theView.bounds, thePoint);
}

#pragma mark AudioRecorderDelegate

-(void)audioRecorder:(AudioRecorderController *)inRecorder didRecordToData:(NSData *)inData {
    [self updateMediumData:inData withMediumType:kMediumTypeAudio];
    self.playButton.enabled = inData.length > 0;
}

-(void)audioRecorderDidCancel:(AudioRecorderController *)inRecorder {
}

@end
