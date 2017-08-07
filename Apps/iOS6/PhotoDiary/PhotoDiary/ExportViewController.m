//
//  ExportViewController.m
//  PhotoDiary
//
//  Created by Clemens Wagner on 16.09.13.
//  Copyright (c) 2013 Cocoaneheads. All rights reserved.
//

#import "ExportViewController.h"
#import "NSFileManager+StandardDirectories.h"
#import "AudioPlayerController.h"

@interface ExportViewController()<UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UITextField *nameField;

@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UITextView *textView;

@property (nonatomic, weak) IBOutlet UISwitch *imageSwitch;
@property (nonatomic, weak) IBOutlet UISwitch *textSwitch;
@property (nonatomic, weak) IBOutlet UISwitch *soundSwitch;
@property (weak, nonatomic) IBOutlet UIButton *playSoundButton;

- (IBAction)updateSaveButton;
- (IBAction)cancel:(id)inSender;
- (IBAction)save:(id)inSender;

@end

@implementation ExportViewController

- (void)viewWillAppear:(BOOL)inAnimated {
    [super viewWillAppear:inAnimated];
    DiaryEntry *theEntry = self.diaryEntry;
    NSString *theText = theEntry.text;
    NSData *theImage = [[theEntry mediumForType:kMediumTypeImage] data];
    BOOL theSoundFlag = [theEntry mediumForType:kMediumTypeAudio] != nil;

    if(theImage.length > 0) {
        CGFloat theScale = [[UIScreen mainScreen] scale];
        self.imageView.image = [UIImage imageWithData:theImage scale:theScale];
        self.imageSwitch.on = YES;
        self.imageSwitch.enabled = YES;
    }
    else {
        self.imageSwitch.on = NO;
        self.imageSwitch.enabled = NO;
    }
    self.textView.text = theText;
    self.textSwitch.on = theText.length > 0;
    self.textSwitch.enabled = theText.length > 0;
    self.soundSwitch.enabled = theSoundFlag;
    self.soundSwitch.on = theSoundFlag;
    self.playSoundButton.enabled = theSoundFlag;
    self.navigationItem.leftBarButtonItem.enabled = NO;
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (IBAction)updateSaveButton {
    self.navigationItem.leftBarButtonItem.enabled = self.nameField.text.length > 0 &&
    (self.imageSwitch.on || self.textSwitch.on || self.soundSwitch.on);
}

- (IBAction)save:(id)inSender {
    NSFileManager *theManager = [NSFileManager defaultManager];
    NSString *thePath = [theManager applicationDocumentsDirectory];
    NSError *theError = nil;

    thePath = [thePath stringByAppendingPathComponent:self.nameField.text];
    if([theManager createDirectoryAtPath:thePath withIntermediateDirectories:YES attributes:nil error:&theError]) {
        DiaryEntry *theEntry = self.diaryEntry;

        if(self.imageSwitch.on) {
            NSData *theImage = [[theEntry mediumForType:kMediumTypeImage] data];
            NSString *theFile = [thePath stringByAppendingPathComponent:@"image.jpg"];

            [theImage writeToFile:theFile atomically:YES];
        }
        if(self.textSwitch.on) {
            NSString *theFile = [thePath stringByAppendingPathComponent:@"text.txt"];

            [theEntry.text writeToFile:theFile atomically:YES encoding:NSUTF8StringEncoding error:NULL];
        }
        if(self.soundSwitch.on) {
            NSData *theAudio = [[theEntry mediumForType:kMediumTypeAudio] data];
            NSString *theFile = [thePath stringByAppendingPathComponent:@"sound.caf"];

            [theAudio writeToFile:theFile atomically:YES];
        }
        [self.activity activityDidFinish:YES];
    }
    else {
        NSLog(@"save: error=%@", theError);
        [self.activity activityDidFinish:NO];
    }
}

- (IBAction)cancel:(id)inSender {
    [self.activity activityDidFinish:NO];
}

- (void)prepareForSegue:(UIStoryboardSegue *)inSegue sender:(id)inSender {
    if([inSegue.identifier isEqualToString:@"player"]) {
        AudioPlayerController *theController = inSegue.destinationViewController;

        theController.audioMedium = [self.diaryEntry mediumForType:kMediumTypeAudio];
    }
}

#pragma mark UITextFieldDelegate

- (IBAction)didEndOnExit {
    [self updateSaveButton];
    [self.view endEditing:YES];
}

@end
