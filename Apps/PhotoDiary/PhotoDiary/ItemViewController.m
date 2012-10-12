#import "ItemViewController.h"
#import "PhotoDiaryAppDelegate.h"
#import "AudioRecorderController.h"
#import "DiaryEntry.h"
#import "Medium.h"
#import "UIImage+ImageTools.h"
#import "AudioPlayerController.h"
#import "PhotoDiaryAppDelegate.h"
#import <AVFoundation/AVFoundation.h>

static const NSInteger kOverviewButtonTag = 123;

@interface ItemViewController()

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) UIPopoverController *popoverController;
@property (nonatomic, retain) DiaryEntry *item;

- (void)applyItem;
- (BOOL)saveItem;
- (UIViewController *)rootController;
- (void)updateOverviewButton;

@end

@implementation ItemViewController

@synthesize imageView;
@synthesize textView;

@synthesize cameraButton;
@synthesize photoLibraryButton;
@synthesize playButton;
@synthesize recordButton;

@synthesize toolbar;
@synthesize imagePicker;
@synthesize audioRecorder;
@synthesize audioPlayer;
@synthesize item;
@synthesize indexPath;
@synthesize managedObjectContext;
@synthesize popoverController;

- (void)dealloc {
    self.managedObjectContext = nil;
    self.toolbar = nil;
    self.cameraButton = nil;
    self.photoLibraryButton = nil;
    self.playButton = nil;
    self.recordButton = nil;
    self.imagePicker = nil;
    self.audioRecorder = nil;
    self.audioPlayer = nil;
    self.item = nil;
    self.indexPath = nil;
    self.imageView = nil;
    self.textView = nil;
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];    
    self.imagePicker = [[[UIImagePickerController alloc] init] autorelease];
    self.imagePicker.allowsEditing = YES;
    self.imagePicker.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    self.imagePicker.delegate = self;
    self.recordButton.enabled = [[AVAudioSession sharedInstance] inputIsAvailable];
    self.cameraButton.enabled = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    self.photoLibraryButton.enabled = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.popoverController = [[[UIPopoverController alloc] initWithContentViewController:self.imagePicker] autorelease];
    }
}

- (void)viewDidUnload {
    self.toolbar = nil;
    self.imagePicker = nil;
    self.cameraButton = nil;
    self.photoLibraryButton = nil;
    self.playButton = nil;
    self.recordButton = nil;
    self.audioRecorder = nil;
    self.audioPlayer = nil;
    self.popoverController = nil;
    self.imageView = nil;
    self.textView = nil;
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)inAnimated {
    [super viewWillAppear:inAnimated];
    id theController = self.rootController;

    [self.audioRecorder addViewToViewController:theController];
    [self.audioPlayer addViewToViewController:theController];
    [self applyItem];
}

- (void)viewDidAppear:(BOOL)inAnimated {
    [super viewDidAppear:inAnimated];
    NSNotificationCenter *theCenter = [NSNotificationCenter defaultCenter];
    
    [theCenter addObserver:self 
                  selector:@selector(managedObjectContextDidSave:) 
                      name:NSManagedObjectContextDidSaveNotification 
                    object:nil];
    [theCenter addObserver:self 
                  selector:@selector(keyboardWillAppear:) 
                      name:UIKeyboardWillShowNotification 
                    object:nil];
    [theCenter addObserver:self 
                  selector:@selector(keyboardWillDisappear:) 
                      name:UIKeyboardWillHideNotification 
                    object:nil];
    [self updateOverviewButton];
}

- (void)viewWillDisappear:(BOOL)inAnimated {
    NSNotificationCenter *theCenter = [NSNotificationCenter defaultCenter];
    
    [theCenter removeObserver:theCenter];
    self.imageView.image = nil;
    self.audioPlayer.visible = NO;
    self.audioRecorder.visible = NO;
    [self.audioPlayer removeView];
    [self.audioRecorder removeView];
    [super viewWillDisappear:inAnimated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)inOrientation {
    return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)inInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:inInterfaceOrientation];
    [self updateOverviewButton];
}

- (void)updateOverviewButton {
    PhotoDiaryAppDelegate *theDelegate = (PhotoDiaryAppDelegate *)[[UIApplication sharedApplication] delegate];
    UIBarButtonItem *theButton = theDelegate.overviewButton;
    NSMutableArray *theItems = [self.toolbar.items mutableCopy];
    id theItem = [theItems objectAtIndex:0];
    
    if(theButton == nil && [theItem tag] == kOverviewButtonTag) {
        [theItems removeObjectAtIndex:0];
    }
    else if(theButton != nil && [theItem tag] != kOverviewButtonTag) {
        theItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Overview", @"Overview button") 
                                                   style:UIBarButtonItemStyleDone 
                                                  target:self 
                                                  action:@selector(showOverview:)];
        [theItem setTag:kOverviewButtonTag];
        [theItems insertObject:theItem atIndex:0];
        [theItem release];
    }
    [self.toolbar setItems:theItems animated:YES];
}

- (void)keyboardWillAppear:(NSNotification *)inNotification {
    NSValue *theValue = [inNotification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
    UIView *theView = self.view;
    CGRect theFrame = [theView.window convertRect:[theValue CGRectValue] toView:theView];
    
    theFrame = CGRectMake(0.0, 0.0, 
                          CGRectGetWidth(self.view.frame),
                          CGRectGetMinY(theFrame));
    theFrame = [theView convertRect:theFrame toView:textView.superview];
    [UIView beginAnimations:nil context:nil];
    self.textView.frame = theFrame;
    [UIView commitAnimations];
}

- (void)keyboardWillDisappear:(NSNotification *)inNotification {
    [UIView beginAnimations:nil context:nil];
    self.textView.frame = CGRectInset(textView.superview.bounds, 10.0, 10.0);
    [UIView commitAnimations];
}

- (void)showPickerWithSourceType:(UIImagePickerControllerSourceType)inSourceType 
                   barButtonItem:(UIBarButtonItem *)inItem {
    if([UIImagePickerController isSourceTypeAvailable:inSourceType]) {
        self.imagePicker.sourceType = inSourceType;
        if(self.popoverController == nil) {
            [self presentModalViewController:self.imagePicker animated:YES];            
        }
        else if(!self.popoverController.popoverVisible) {
            [self.popoverController presentPopoverFromBarButtonItem:inItem 
                                           permittedArrowDirections:UIPopoverArrowDirectionAny 
                                                           animated:YES];
        }
    }
}

- (NSManagedObjectContext *)managedObjectContext {
    if(managedObjectContext == nil) {
        id theDelegate = [[UIApplication sharedApplication] delegate];
        
        self.managedObjectContext = [[[NSManagedObjectContext alloc] init] autorelease];
        self.managedObjectContext.persistentStoreCoordinator = [theDelegate storeCoordinator];
    }
    return managedObjectContext;
}

- (DiaryEntry *)diaryEntry {
    return self.item;
}

- (void)setDiaryEntry:(DiaryEntry *)inDiaryEntry {
    [self.managedObjectContext reset];
    if(inDiaryEntry == nil) {
        self.item = [NSEntityDescription insertNewObjectForEntityForName:@"DiaryEntry" 
                                                  inManagedObjectContext:self.managedObjectContext];
    }
    else {
        self.item = (DiaryEntry *)[self.managedObjectContext objectWithID:inDiaryEntry.objectID];
    }
    [self applyItem];
}

- (void)applyItem {
    Medium *theMedium;
    
    if(self.item == nil) {
        self.diaryEntry = nil;
    }
    self.textView.text = self.item.text;
    theMedium = [self.item mediumForType:kMediumTypeImage];
    self.imageView.image = [UIImage imageWithData:theMedium.data];
    self.playButton.enabled = [self.item mediumForType:kMediumTypeAudio] != nil;
}

- (BOOL)saveItem {
    BOOL theResult = NO;
    
    if(self.item.hasContent) {
        NSError *theError = nil;

        theResult = [self.managedObjectContext save:&theError];
        if(!theResult) {
            NSLog(@"saveItem: %@", theError);
        }
    }
    return theResult;
}

- (UIViewController *)rootController {
    UIViewController *theController = self;
    
    while(theController.parentViewController) {
        theController = theController.parentViewController;
    }
    return theController;
}

- (IBAction)takePhoto:(id)inSender {
    [self showPickerWithSourceType:UIImagePickerControllerSourceTypeCamera barButtonItem:inSender];
}

- (IBAction)takePhotoFromLibrary:(id)inSender {
    [self showPickerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary barButtonItem:inSender];
}

- (IBAction)recordAudio:(id)inSender {
    [self.audioRecorder setVisible:YES animated:YES];
}

- (IBAction)playAudio:(id)inSender {
    Medium *theAudio = [self.item mediumForType:kMediumTypeAudio];
    
    self.audioPlayer.audioMedium = theAudio;
    [self.audioPlayer setVisible:YES animated:YES];
}

- (IBAction)saveText:(id)inSender {
    [self.view endEditing:YES];
    self.item.text = self.textView.text;
    [self saveItem];
}

- (IBAction)revertText:(id)inSender {
    [self.view endEditing:YES];
    [self applyItem];
}

- (void)updateMediumData:(NSData *)inData withMediumType:(NSString *)inType {
    if(inData.length == 0) {
        [self.item removeMediumForType:inType];
    }
    else {
        Medium *theMedium = [NSEntityDescription insertNewObjectForEntityForName:@"Medium" 
                                                          inManagedObjectContext:self.managedObjectContext];
        
        theMedium.type = inType;
        theMedium.data = inData;
        [self.item addMedium:theMedium];
    }
    [self saveItem];
}

- (void)saveImage:(UIImage *)inImage {
    NSData *theData = UIImageJPEGRepresentation(inImage, 0.8);
    CGSize theIconSize = [inImage sizeToAspectFitInSize:CGSizeMake(60.0, 60.0)];
    UIImage *theImage = [inImage scaledImageWithSize:theIconSize];

    self.item.icon = UIImageJPEGRepresentation(theImage, 0.8);
    [self updateMediumData:theData withMediumType:kMediumTypeImage];
}

- (void)dismissImagePickerController:(UIImagePickerController *)inPicker {
    if(self.popoverController == nil) {
        [inPicker dismissModalViewControllerAnimated:YES];
    }    
}

- (void)managedObjectContextDidSave:(NSNotification *)inNotification {
    NSDictionary *theInfo = inNotification.userInfo;
    NSArray *theIds = [[theInfo objectForKey:NSDeletedObjectsKey] valueForKey:@"objectID"];
    
    if([theIds containsObject:self.item.objectID]) {
        [self.managedObjectContext rollback];
        self.diaryEntry = nil;
    }
    else {
        [self.managedObjectContext rollback];
        self.diaryEntry = self.item;
    }
}

- (IBAction)showOverview:(id)inButton {
    PhotoDiaryAppDelegate *theDelegate = (PhotoDiaryAppDelegate *)[[UIApplication sharedApplication] delegate];
    UIPopoverController *theController = theDelegate.popoverController;
    
    [theController presentPopoverFromBarButtonItem:inButton 
                          permittedArrowDirections:UIPopoverArrowDirectionAny 
                                          animated:YES];
}

#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)inPicker 
didFinishPickingMediaWithInfo:(NSDictionary *)inInfo {
    UIImage *theImage = [inInfo valueForKey:UIImagePickerControllerEditedImage];
    
    [self dismissImagePickerController:inPicker];
    self.item.icon = nil;
    self.imageView.image = theImage;
    [self saveImage:theImage];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)inPicker {
    [self dismissImagePickerController:inPicker];
}

#pragma mark AudioRecorderDelegate

-(void)audioRecorder:(AudioRecorderController *)inRecorder didRecordToData:(NSData *)inData {
    [self updateMediumData:inData withMediumType:kMediumTypeAudio];
    self.playButton.enabled = inData.length > 0;
}

-(void)audioRecorderDidCancel:(AudioRecorderController *)inRecorder {
}

#pragma mark SubviewControllerDelegate

- (void)subviewControllerWillAppear:(SubviewController *)inController {
    // [self.navigationController setToolbarHidden:YES animated:NO]; 
}

- (void)subviewControllerWillDisappear:(SubviewController *)inController {
    // [self.navigationController setToolbarHidden:NO animated:NO]; 
}

@end
