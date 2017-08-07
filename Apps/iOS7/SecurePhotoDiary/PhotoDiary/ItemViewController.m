#import "ItemViewController.h"
#import "SecurePhotoDiaryAppDelegate.h"
#import "AudioRecorderController.h"
#import "DiaryEntry.h"
#import "Medium.h"
#import "UIImage+ImageTools.h"
#import "AudioPlayerController.h"
#import "SecurePhotoDiaryAppDelegate.h"
#import <AVFoundation/AVFoundation.h>

static const NSInteger kOverviewButtonTag = 123;

@interface ItemViewController()<UISplitViewControllerDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) UIPopoverController *popoverController;
@property (nonatomic, strong) UIPopoverController *masterPopoverController;
@property (nonatomic, strong) DiaryEntry *item;

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
@synthesize tweetButton;
@synthesize recordButton;

@synthesize toolbar;
@synthesize imagePicker;
@synthesize item;
@synthesize indexPath;
@synthesize managedObjectContext;
@synthesize popoverController;
@synthesize masterPopoverController;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imagePicker = [[UIImagePickerController alloc] init];
    self.imagePicker.allowsEditing = YES;
    self.imagePicker.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    self.imagePicker.delegate = self;
    self.cameraButton.enabled = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    self.photoLibraryButton.enabled = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.popoverController = [[UIPopoverController alloc] initWithContentViewController:self.imagePicker];
    }   
    self.recordButton.enabled = [[AVAudioSession sharedInstance] inputIsAvailable];
}

- (void)viewDidUnload {
    self.toolbar = nil;
    self.imagePicker = nil;
    self.cameraButton = nil;
    self.photoLibraryButton = nil;
    self.playButton = nil;
    self.recordButton = nil;
    self.popoverController = nil;
    self.imageView = nil;
    self.textView = nil;
    self.tweetButton = nil;
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)inAnimated {
    [super viewWillAppear:inAnimated];
    if(self.item == nil) {
        self.diaryEntry = nil;
    }
    else {
        [self applyItem];
    }
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
    SecurePhotoDiaryAppDelegate *theDelegate = (SecurePhotoDiaryAppDelegate *)[[UIApplication sharedApplication] delegate];
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
        
        self.managedObjectContext = [[NSManagedObjectContext alloc] init];
        self.managedObjectContext.persistentStoreCoordinator = [theDelegate storeCoordinator];
    }
    return managedObjectContext;
}

- (DiaryEntry *)diaryEntry {
    return self.item;
}

- (void)setDiaryEntry:(DiaryEntry *)inDiaryEntry {
    NSManagedObjectContext *theContext = self.managedObjectContext;
    
    [theContext reset];
    if(inDiaryEntry == nil) {
        self.item = [NSEntityDescription insertNewObjectForEntityForName:@"DiaryEntry" 
                                                  inManagedObjectContext:theContext];
    }
    else {
        self.item = (DiaryEntry *)[theContext objectWithID:inDiaryEntry.objectID];
    }
    [self applyItem];
}

- (void)applyItem {
    Medium *theMedium;
    
    self.textView.text = self.item.text;
    theMedium = [self.item mediumForType:kMediumTypeImage];
    self.imageView.image = [UIImage imageWithData:theMedium.data];
    self.playButton.enabled = [self.item mediumForType:kMediumTypeAudio] != nil;
    if(self.item.text) {
        [self.tweetButton setEnabled:YES];
    }
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

- (IBAction)composeTweet:(id)sender {
    if([TWTweetComposeViewController canSendTweet]){
        Medium *theMedium;
        
        theMedium = [self.item mediumForType:kMediumTypeImage];

        TWTweetComposeViewController *tweet = [[TWTweetComposeViewController alloc] init];

        if(theMedium.data)
            [tweet addImage:[UIImage imageWithData:theMedium.data]];
        
        [tweet setInitialText:[textView text]];        
        [self presentModalViewController:tweet animated:YES];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Obacht!"
                                                        message:@"Bitte Twitter-Account in den Systemeinstellungen einrichten."
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)saveText:(id)inSender {
    if(![tweetButton isEnabled]){
        [tweetButton setEnabled:YES];
    }
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

- (void)prepareForSegue:(UIStoryboardSegue *)inSegue sender:(id)inSender {
    id theController = inSegue.destinationViewController;
    
    if([theController respondsToSelector:@selector(setAudioMedium:)]) {
        [theController setAudioMedium:[self.diaryEntry mediumForType:kMediumTypeAudio]];
    }
    if([theController respondsToSelector:@selector(setDelegate:)]) {
        [theController setDelegate:self];
    }
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

#pragma mark UISplitViewControllerDelegate

- (void)splitViewController:(UISplitViewController *)inSplitViewController 
          popoverController:(UIPopoverController *)inPopoverController 
  willPresentViewController:(UIViewController *)inViewController {
    self.masterPopoverController = inPopoverController;
}

- (void)splitViewController:(UISplitViewController *)inSplitViewController 
     willHideViewController:(UIViewController *)inViewController 
          withBarButtonItem:(UIBarButtonItem *)inBarButtonItem 
       forPopoverController:(UIPopoverController *)inPopoverController {
    inBarButtonItem.title = NSLocalizedString(@"Overview", @"");
    self.navigationItem.leftBarButtonItem = inBarButtonItem;
    self.masterPopoverController = inPopoverController;
}

- (void)splitViewController:(UISplitViewController *)inSplitViewController 
     willShowViewController:(UIViewController *)inViewController 
  invalidatingBarButtonItem:(UIBarButtonItem *)inBarButtonItem {
    inViewController.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    self.navigationItem.leftBarButtonItem = nil;
    self.masterPopoverController = nil;
}

@end
