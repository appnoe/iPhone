#import "SlideShowController.h"
#import "SecurePhotoDiaryAppDelegate.h"
#import "DiaryEntry.h"
#import "Medium.h"

static const NSUInteger kCacheSize = 10;

@interface SlideShowController()

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSFetchRequest *fetchRequest;
@property (nonatomic, strong) NSArray *entries;
@property (nonatomic) NSUInteger entryIndex;

- (DiaryEntry *)diaryEntryAtIndex:(NSUInteger)inIndex;
- (void)showNextDiaryEntry;

@end

@implementation SlideShowController

@synthesize imageViews;
@synthesize textLabel;
@synthesize managedObjectContext;
@synthesize fetchRequest;
@synthesize entries;
@synthesize entryIndex;


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)inInterfaceOrientation {
    return YES;
}

- (NSFetchRequest *)makeFetchRequest {
    NSFetchRequest *theRequest = [[NSFetchRequest alloc] init];
    NSSortDescriptor *theSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"creationTime" ascending:YES];
    
    theRequest.entity = [NSEntityDescription entityForName:@"DiaryEntry" 
                                    inManagedObjectContext:self.managedObjectContext];
    theRequest.fetchLimit = kCacheSize;
    theRequest.sortDescriptors = [NSArray arrayWithObject:theSortDescriptor];
    theRequest.relationshipKeyPathsForPrefetching = [NSArray arrayWithObject:@"media"];
    return theRequest;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    id theDelegate = [[UIApplication sharedApplication] delegate];
    
    self.managedObjectContext = [[NSManagedObjectContext alloc] init];
    self.managedObjectContext.persistentStoreCoordinator = [theDelegate storeCoordinator];
    self.fetchRequest = [self makeFetchRequest];
}

- (void)viewDidUnload {
    self.imageViews = nil;
    self.textLabel = nil;
    self.managedObjectContext = nil;
    self.fetchRequest = nil;
    self.entries = nil;
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)inAnimated {
    [super viewWillAppear:inAnimated];
    for(UIImageView *theView in self.imageViews) {
        theView.image = nil;
    }
    self.entryIndex = 0;
    self.entries = nil;
    self.textLabel.text = @"";
    [self showNextDiaryEntry];
}

- (void)viewDidAppear:(BOOL)inAnimated {
    [super viewDidAppear:inAnimated];
}

- (void)viewWillDisappear:(BOOL)inAnimated {
    [super viewWillDisappear:inAnimated];
    self.entries = nil;
    [self.managedObjectContext reset];
}

- (void)prepareImageView:(UIImageView *)inImageView withDiaryEntry:(DiaryEntry *)inEntry {
    Medium *theMedium = [inEntry mediumForType:kMediumTypeImage];
    UIImage *theImage = [UIImage imageWithData:theMedium.data];
    
    inImageView.image = theImage;
}

- (void)showTextWithDiaryEntry:(DiaryEntry *)inEntry {
    UILabel *theLabel = self.textLabel;
    CGRect theFrame = theLabel.frame;
    CGSize theSize = CGSizeMake(CGRectGetWidth(theFrame), MAXFLOAT);
    
    theFrame.origin.y = CGRectGetMaxY(self.view.bounds);
    theLabel.text = inEntry.text;
    theSize = [theLabel sizeThatFits:theSize];
    theFrame.size.height = theSize.height;
    theLabel.frame = theFrame;
    [UIView animateWithDuration:theSize.height / 10.0 delay:1.0 
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         CGRect theFrame = theLabel.frame;

                         theFrame.origin.y = -theSize.height;
                         theLabel.frame = theFrame;                         
                     }
                     completion:^(BOOL inFinished) {
                         [self showNextDiaryEntry];
                     }];
}

- (void)showNextDiaryEntry {
    DiaryEntry *theEntry = [self diaryEntryAtIndex:self.entryIndex++];
    
    if(theEntry != nil) {
        for(UIImageView *theView in self.imageViews) {
            if(CGRectGetMinX(theView.frame) < 0.0) {
                CGRect theFrame = theView.frame;
                
                theFrame.origin.x = CGRectGetWidth(self.view.frame);
                [self prepareImageView:theView withDiaryEntry:theEntry];
                theView.frame = theFrame;
                break;
            }
        }                             
        [UIView animateWithDuration:1.5 delay:1.0 options:UIViewAnimationOptionCurveEaseInOut 
                         animations:^{
                             for(UIImageView *theView in self.imageViews) {
                                 CGRect theFrame = theView.frame;

                                 if(CGRectGetMinX(theView.frame) == 0.0) {
                                     theFrame.origin.x = -CGRectGetWidth(self.view.frame);
                                 }
                                 else {
                                     theFrame.origin.x = 0.0;
                                 }
                                 theView.frame = theFrame;
                             }                             
                         }
                         completion:^(BOOL inFinished) {
                             [self showTextWithDiaryEntry:theEntry];                             
                         }];
    }
}

- (DiaryEntry *)diaryEntryAtIndex:(NSUInteger)inIndex {
    NSFetchRequest *theRequest = self.fetchRequest;
    NSUInteger theOffset = theRequest.fetchOffset;
    NSUInteger theIndex = inIndex % kCacheSize;
    
    if(self.entries == nil || inIndex < theOffset || inIndex >= theOffset + kCacheSize) {
        NSError *theError = nil;
        
        theOffset = (inIndex / kCacheSize) * kCacheSize;
        [self.managedObjectContext reset];
        theRequest.fetchOffset = theOffset;
        self.entries = [self.managedObjectContext executeFetchRequest:theRequest error:&theError];
        if(theError != nil) {
            NSLog(@"diaryEntryAtIndex:%u, %@", inIndex, theError);
        }
    }
    return theIndex < self.entries.count ? [self.entries objectAtIndex:theIndex] : nil;
}

@end
