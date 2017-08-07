#import "PhotoDiaryViewController.h"
#import "AudioPlayerController.h"
#import "Medium.h"
#import "ItemViewController.h"
#import "DiaryEntry.h"
#import "DiaryEntryCell.h"
#import "SlideShowController.h"
#import "SubviewSegue.h"
#import "UIViewController+PhotoDiary.h"

@interface PhotoDiaryViewController()<NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, copy) NSArray *searchResult;
@property (nonatomic, strong) NSIndexPath *selectedIndex;

@end

@implementation PhotoDiaryViewController

@synthesize tableView;
@synthesize fetchedResultsController;
@synthesize searchDisplayController;
@synthesize searchResult;
@synthesize selectedIndex;

- (NSFetchRequest *)fetchRequest {
    NSFetchRequest *theFetch = [[NSFetchRequest alloc] init];
    NSEntityDescription *theType = [NSEntityDescription entityForName:@"DiaryEntry" 
                                               inManagedObjectContext:self.managedObjectContext];
    NSSortDescriptor *theDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"creationTime" ascending:NO];
    
    theFetch.entity = theType;
    theFetch.sortDescriptors = [NSArray arrayWithObject:theDescriptor];
    return theFetch;
}

- (UITableView *)searchResultsTableView {
    return self.searchDisplayController.searchResultsTableView;
}

- (UITableView *)currentTableView {
    return self.searchResult == nil ? self.tableView : self.searchResultsTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSNotificationCenter *theCenter = [NSNotificationCenter defaultCenter];
    NSFetchedResultsController *theController = [[NSFetchedResultsController alloc] initWithFetchRequest:self.fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Root"];
    NSError *theError = nil;
    
    theController.delegate = self;
    self.fetchedResultsController = theController;
    if(![self.fetchedResultsController performFetch:&theError]) {
        NSLog(@"viewDidLoad: %@", theError);
    }
    [theCenter addObserver:self 
                  selector:@selector(managedObjectContextDidSave:)
                      name:NSManagedObjectContextDidSaveNotification 
                    object:nil];
}

- (void)viewDidUnload {
    NSNotificationCenter *theCenter = [NSNotificationCenter defaultCenter];
    
    [theCenter removeObserver:self name:NSManagedObjectContextDidSaveNotification object:nil];
    self.fetchedResultsController = nil;
    self.tableView = nil;
    self.fetchedResultsController = nil;
    self.searchDisplayController = nil;
    [self.managedObjectContext reset];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)inInterfaceOrientation {
    return YES;
}

- (void)viewWillAppear:(BOOL)inAnimated {
    [super viewWillAppear:inAnimated];
    [self.navigationController setToolbarHidden:YES animated:YES];
}

- (IBAction)addItem {
    UINavigationController *theDetailController = self.splitViewController.viewControllers.lastObject;
    ItemViewController *theController = [theDetailController.viewControllers objectAtIndex:0];
    
    theController.diaryEntry = nil;
}

- (DiaryEntry *)entryForTableView:(UITableView *)inTableView atIndexPath:(NSIndexPath *)inIndexPath {
    if(inTableView == self.tableView) {
        return [self.fetchedResultsController objectAtIndexPath:inIndexPath];
    }
    else {
        return [self.searchResult objectAtIndex:inIndexPath.row];
    }
}

- (IBAction)playSound:(id)inSender {
    NSIndexPath *theIndexPath = [NSIndexPath indexPathForRow:[inSender tag] inSection:0];
    UITableView *theTableView = self.searchDisplayController.active ? self.searchResultsTableView : self.tableView;
    DiaryEntry *theItem = [self entryForTableView:theTableView atIndexPath:theIndexPath];
    Medium *theMedium = [theItem mediumForType:kMediumTypeAudio];
    
    if(theMedium != nil) {
        AudioPlayerController *thePlayer = [self.storyboard instantiateViewControllerWithIdentifier:@"audioPlayer"];
        SubviewSegue *theSegue = [[SubviewSegue alloc] initWithIdentifier:@"audioPlayer" 
                                                                   source:self 
                                                              destination:thePlayer];
        thePlayer.audioMedium = theMedium;
        [theSegue perform];
    }
}

- (void)applyDiaryEntry:(DiaryEntry *)inEntry toCell:(DiaryEntryCell *)inCell {
    UIImage *theImage = [UIImage imageWithData:inEntry.icon];
    
    [inCell setIcon:theImage];
    [inCell setText:inEntry.text];
    [inCell setDate:inEntry.creationTime];
}

- (void)managedObjectContextDidSave:(NSNotification *)inNotification {
    if(inNotification.object != self.managedObjectContext) {
        [self.managedObjectContext mergeChangesFromContextDidSaveNotification:inNotification];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)inSegue sender:(id)inSender {
    id theController = inSegue.destinationViewController;
    
    if([inSegue.identifier isEqualToString:@"existingItem"]) {
        id theEntry = [self entryForTableView:inSender atIndexPath:self.selectedIndex];
        
        [theController setIndexPath:self.selectedIndex];
        [theController setDiaryEntry:theEntry];
    }
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)inTableView {
    if(inTableView == self.tableView) {
        return [[self.fetchedResultsController sections] count];
    }
    else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)inTableView numberOfRowsInSection:(NSInteger)inSection {
    if(inTableView == self.tableView) {    
        id<NSFetchedResultsSectionInfo> theInfo = [[self.fetchedResultsController sections] objectAtIndex:inSection];
        
        return [theInfo numberOfObjects];
    }
    else {
        return self.searchResult.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)inTableView cellForRowAtIndexPath:(NSIndexPath *)inIndexPath {
    DiaryEntryCell *theCell = (DiaryEntryCell *)[self.tableView dequeueReusableCellWithIdentifier:@"dairyEntryCell"];
    DiaryEntry *theEntry = [self entryForTableView:inTableView atIndexPath:inIndexPath];

    theCell.imageControl.tag = inIndexPath.row;
    [self applyDiaryEntry:theEntry toCell:theCell];
    return theCell;
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)inTableView heightForRowAtIndexPath:(NSIndexPath *)inIndexPath {
    return 64.0;
}

- (void)tableView:(UITableView *)inTableView didSelectRowAtIndexPath:(NSIndexPath *)inIndexPath {
    if(self.splitViewController == nil) {
        self.selectedIndex = inIndexPath;
        [self performSegueWithIdentifier:@"existingItem" sender:inTableView];
    }
    else {
        UINavigationController *theDetailController = self.splitViewController.viewControllers.lastObject;
        ItemViewController *theController = [theDetailController.viewControllers objectAtIndex:0];
        
        theController.diaryEntry = [self entryForTableView:inTableView atIndexPath:inIndexPath];
    }
}

- (void)tableView:(UITableView *)inTableView commitEditingStyle:(UITableViewCellEditingStyle)inStyle forRowAtIndexPath:(NSIndexPath *)inIndexPath {
    if(inStyle == UITableViewCellEditingStyleDelete) {
        DiaryEntry *theItem = [self entryForTableView:inTableView atIndexPath:inIndexPath];
        NSError *theError = nil;

        [self.managedObjectContext rollback];
        [self.managedObjectContext deleteObject:theItem];
        if([self.managedObjectContext save:&theError]) {
            if(inTableView == self.searchResultsTableView) {
                NSMutableArray *theResult = [self.searchResult mutableCopy];
                
                [theResult removeObjectAtIndex:inIndexPath.row];
                self.searchResult = theResult;
                [inTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:inIndexPath] 
                                   withRowAnimation:UITableViewRowAnimationFade];
            }
        }
        else {
            NSLog(@"Unresolved error %@", theError);
        }
    }   
}

#pragma mark NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)inController {
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)inController 
   didChangeObject:(id)inObject 
       atIndexPath:(NSIndexPath *)inIndexPath 
     forChangeType:(NSFetchedResultsChangeType)inType 
      newIndexPath:(NSIndexPath *)inNewIndexPath {
    id theCell;
    
    switch(inType) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:inNewIndexPath] 
                                  withRowAnimation:UITableViewRowAnimationRight];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:inIndexPath] 
                                  withRowAnimation:UITableViewRowAnimationRight];
            break;
        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:inIndexPath] 
                                  withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:inNewIndexPath] 
                                  withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeUpdate:
            theCell = [self.tableView cellForRowAtIndexPath:inIndexPath];            
            [self applyDiaryEntry:inObject toCell:theCell];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)inController 
  didChangeSection:(id<NSFetchedResultsSectionInfo>)inSectionInfo 
           atIndex:(NSUInteger)inSectionIndex 
     forChangeType:(NSFetchedResultsChangeType)inType {
    
    switch(inType) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:inSectionIndex] 
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:inSectionIndex] 
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)inController {
    [self.tableView endUpdates];
}

#pragma mark UISearchDisplayDelegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)inController shouldReloadTableForSearchString:(NSString *)inSearchString {
    NSPredicate *thePredicate = [NSPredicate predicateWithFormat:@"text contains[cd] %@", inSearchString];
    NSArray *theObjects = self.fetchedResultsController.fetchedObjects;
    
    self.searchResult = [theObjects filteredArrayUsingPredicate:thePredicate];
    return YES;
}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)inController {
    self.searchResult = nil;
}

#pragma mark SubviewControllerDelegate

- (void)subviewControllerWillDisappear:(SubviewController *)inController {
    AudioPlayerController *thePlayer = (AudioPlayerController *)inController;
    Medium *theMedium = thePlayer.audioMedium;

    if(theMedium != nil) {
        DiaryEntry *theEntry = theMedium.diaryEntry;
        
        [self.managedObjectContext refreshObject:theMedium mergeChanges:NO];
        [self.managedObjectContext refreshObject:theEntry mergeChanges:NO];
        thePlayer.audioMedium = nil;
    }
}

@end
