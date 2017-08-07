//
//  PhotoDiaryViewController.h
//  PhotoDiary
//
//  Created by Clemens Wagner on 10.09.13.
//  Copyright (c) 2013 Cocoaneheads. All rights reserved.
//

#import "PhotoDiaryViewController.h"
#import "DiaryEntryViewController.h"
#import "DiaryEntryCell.h"
#import "AudioPlayerController.h"

@interface PhotoDiaryViewController()<NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, copy) NSArray *searchResult;
@property (nonatomic, strong) NSIndexPath *selectedIndex;

@end

@implementation PhotoDiaryViewController

- (NSFetchRequest *)fetchRequest {
    NSFetchRequest *theFetch = [[NSFetchRequest alloc] init];
    NSEntityDescription *theType = [NSEntityDescription entityForName:@"DiaryEntry"
                                               inManagedObjectContext:self.managedObjectContext];
    NSSortDescriptor *theDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"creationTime" ascending:NO];

    theFetch.entity = theType;
    theFetch.sortDescriptors = @[theDescriptor];
    return theFetch;
}

- (UITableView *)searchResultsTableView {
    return self.searchDisplayController.searchResultsTableView;
}

- (UITableView *)currentTableView {
    return self.searchDisplayController.isActive ? self.searchResultsTableView : self.tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSNotificationCenter *theCenter = [NSNotificationCenter defaultCenter];
    NSFetchRequest *theRequest = self.fetchRequest;
    NSFetchedResultsController *theController = [[NSFetchedResultsController alloc] initWithFetchRequest:theRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Root"];
    NSError *theError = nil;

    theController.delegate = self;
    if([theController performFetch:&theError]) {
        self.fetchedResultsController = theController;
    }
    else {
        NSLog(@"viewDidLoad: %@", theError);
    }
    [theCenter addObserver:self
                  selector:@selector(managedObjectContextDidSave:)
                      name:NSManagedObjectContextDidSaveNotification
                    object:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)inSegue sender:(id)inSender {
    id theController = inSegue.destinationViewController;

    if([inSegue.identifier isEqualToString:@"insert"]) {
        id theEntry = [NSEntityDescription insertNewObjectForEntityForName:@"DiaryEntry" inManagedObjectContext:self.managedObjectContext];

        [theController setDiaryEntry:theEntry];
    }
    else if([inSegue.identifier isEqualToString:@"update"]) {
        UITableView *theView = self.tableView;
        NSIndexPath *theIndexPath = [theView indexPathForSelectedRow];
        id theEntry = [self entryAtIndexPath:theIndexPath];

        [theController setDiaryEntry:theEntry];
    }
}

- (void)viewWillAppear:(BOOL)inAnimated {
    [super viewWillAppear:inAnimated];
    [self.navigationController setToolbarHidden:YES animated:YES];
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

- (void)applyDiaryEntry:(DiaryEntry *)inEntry toCell:(DiaryEntryCell *)inCell {
    UIImage *theImage = [UIImage imageWithData:inEntry.icon];

    [inCell setIcon:theImage];
    [inCell setText:inEntry.text];
    [inCell setDate:inEntry.creationTime];
}

- (DiaryEntry *)entryAtIndexPath:(NSIndexPath *)inIndexPath {
    if(self.searchDisplayController.isActive) {
        return self.searchResult[inIndexPath.row];
    }
    else {
        return [self.fetchedResultsController objectAtIndexPath:inIndexPath];
    }
}

- (IBAction)playSound:(id)inSender {
    NSIndexPath *theIndexPath = [NSIndexPath indexPathForRow:[inSender tag] inSection:0];
    DiaryEntry *theItem = [self entryAtIndexPath:theIndexPath];
    Medium *theMedium = [theItem mediumForType:kMediumTypeAudio];

    if(theMedium != nil) {
        AudioPlayerController *thePlayer = [self.storyboard instantiateViewControllerWithIdentifier:@"audioPlayer"];

        thePlayer.audioMedium = theMedium;
        [thePlayer presentFromViewController:self animated:YES];
    }
}

- (void)managedObjectContextDidSave:(NSNotification *)inNotification {
    if(inNotification.object != self.managedObjectContext) {
        [self.managedObjectContext mergeChangesFromContextDidSaveNotification:inNotification];
    }
}

#pragma mark NSFetchedResultsControllerDelegate

- (void)controller:(NSFetchedResultsController *)inController
   didChangeObject:(id)inObject
       atIndexPath:(NSIndexPath *)inIndexPath
     forChangeType:(NSFetchedResultsChangeType)inType
      newIndexPath:(NSIndexPath *)inNewIndexPath {
    id theCell;

    switch(inType) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:@[inNewIndexPath]
                                  withRowAnimation:UITableViewRowAnimationRight];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:@[inIndexPath]
                                  withRowAnimation:UITableViewRowAnimationRight];
            break;
        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:@[inIndexPath]
                                  withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:@[inNewIndexPath]
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
        id<NSFetchedResultsSectionInfo> theInfo = [self.fetchedResultsController sections][inSection];

        return [theInfo numberOfObjects];
    }
    else {
        return self.searchResult.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)inTableView cellForRowAtIndexPath:(NSIndexPath *)inIndexPath {
    DiaryEntryCell *theCell = (DiaryEntryCell *)[self.tableView dequeueReusableCellWithIdentifier:@"dairyEntryCell" forIndexPath:inIndexPath];
    DiaryEntry *theEntry = [self entryAtIndexPath:inIndexPath];

    theCell.imageControl.tag = inIndexPath.row;
    [self applyDiaryEntry:theEntry toCell:theCell];
    return theCell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)inTableView commitEditingStyle:(UITableViewCellEditingStyle)inStyle forRowAtIndexPath:(NSIndexPath *)inIndexPath {
    if(inStyle == UITableViewCellEditingStyleDelete) {
        DiaryEntry *theItem = [self entryAtIndexPath:inIndexPath];
        NSError *theError = nil;

        [self.managedObjectContext deleteObject:theItem];
        if([self.managedObjectContext save:&theError]) {
            if(inTableView == self.searchResultsTableView) {
                NSMutableArray *theResult = [self.searchResult mutableCopy];

                [theResult removeObjectAtIndex:inIndexPath.row];
                self.searchResult = theResult;
                [inTableView deleteRowsAtIndexPaths:@[inIndexPath]
                                   withRowAnimation:UITableViewRowAnimationFade];
            }
        }
        else {
            NSLog(@"Unresolved error %@", theError);
        }
    }   
}

#pragma mark UISearchDisplayDelegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)inController shouldReloadTableForSearchString:(NSString *)inValue {
    NSFetchRequest *theRequest = self.fetchRequest;
    NSPredicate *thePredicate = [NSPredicate predicateWithFormat:@"text contains[cd] %@", inValue];

    theRequest.predicate = thePredicate;
    theRequest.fetchLimit = 30;
    self.searchResult = [self.managedObjectContext executeFetchRequest:theRequest error:NULL];
    return YES;
}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)inController {
    self.searchResult = nil;
}

@end
