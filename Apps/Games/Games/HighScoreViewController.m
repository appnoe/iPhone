#import "HighScoreViewController.h"
#import "Score.h"
#import "GamesAppDelegate.h"

static NSString * const kScoreFilters[] = {
    nil, @"puzzle", @"memory"
};

@interface HighScoreViewController()<NSFetchedResultsControllerDelegate>

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSData *cellData;
@property (nonatomic, retain) NSDateFormatter *dateFormatter;

@end

@implementation HighScoreViewController

@synthesize filterControl;
@synthesize managedObjectContext;
@synthesize fetchedResultsController;
@synthesize cellData;
@synthesize dateFormatter;

- (void)dealloc {
    self.filterControl = nil;
    self.managedObjectContext = nil;
    self.fetchedResultsController = nil;
    self.cellData = nil;
    self.dateFormatter = nil;
    [super dealloc];
}

- (NSManagedObjectContext *)managedObjectContext {
    if(managedObjectContext == nil) {
        NSManagedObjectContext *theContext = [[NSManagedObjectContext alloc] init];
        GamesAppDelegate *theDelegate = (id)[[UIApplication sharedApplication] delegate];
        
        theContext.persistentStoreCoordinator = theDelegate.storeCoordinator;
        self.managedObjectContext = theContext;
        [theContext release];
    }
    return managedObjectContext;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSNotificationCenter *theCenter = [NSNotificationCenter defaultCenter];
    NSDateFormatter *theFormatter = [[NSDateFormatter alloc] init];

    theFormatter.locale = [NSLocale currentLocale];
    theFormatter.dateFormat = @"d. MMM yyyy HH:mm:ss";
    self.dateFormatter = theFormatter;
    [theFormatter release];
    self.tableView.allowsSelection = NO;
    [theCenter addObserver:self 
                  selector:@selector(managedObjectContextDidSave:)
                      name:NSManagedObjectContextDidSaveNotification 
                    object:nil];
    [self filterChanged];
}

- (void)viewWillDisappear:(BOOL)inAnimated {
    self.navigationController.tabBarItem.badgeValue = nil;
    [super viewWillDisappear:inAnimated];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.fetchedResultsController = nil;
    self.cellData = nil;
    self.dateFormatter = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)inOrientation {
    return inOrientation == UIInterfaceOrientationPortrait;
}

- (void)managedObjectContextDidSave:(NSNotification *)inNotification {
    if(inNotification.object != self.managedObjectContext) {
        [self.managedObjectContext mergeChangesFromContextDidSaveNotification:inNotification];
    }
}

- (void)applyScore:(Score *)inScore toCell:(UITableViewCell *)inCell {
    UIImage *theImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", inScore.game]];
    
    inCell.imageView.image = theImage;
    inCell.textLabel.text = [NSString stringWithFormat:@"%@", inScore.score];
    inCell.detailTextLabel.text = [self.dateFormatter stringFromDate:inScore.creationTime];
}

- (NSFetchRequest *)fetchRequestWithFilterIndex:(NSUInteger)inIndex {
    NSFetchRequest *theFetch = [[NSFetchRequest alloc] init];
    NSString *theFilter = kScoreFilters[inIndex];
    NSEntityDescription *theEntity = [NSEntityDescription entityForName:@"Score" 
                                                 inManagedObjectContext:self.managedObjectContext];
    NSSortDescriptor *theDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"score" ascending:YES];
    
    theFetch.entity = theEntity;
    theFetch.sortDescriptors = [NSArray arrayWithObject:theDescriptor];
    if(theFilter) {
        theFetch.predicate = [NSPredicate predicateWithFormat:@"game = %@", theFilter];
    }
    return [theFetch autorelease];
}

- (IBAction)filterChanged {
    NSInteger theIndex = self.filterControl.selectedSegmentIndex;
    
    if(theIndex >= 0) {
        NSFetchRequest *theRequest = [self fetchRequestWithFilterIndex:theIndex];
        NSError *theError = nil;
        NSFetchedResultsController *theController = [[NSFetchedResultsController alloc] initWithFetchRequest:theRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
        
        theController.delegate = self;
        self.fetchedResultsController = theController;
        [theController release];
        if(![self.fetchedResultsController performFetch:&theError]) {
            NSLog(@"filterChanged %@", theError);
        }
        [self.tableView reloadData];
    }
}

- (IBAction)clear {
    [self.fetchedResultsController.fetchedObjects enumerateObjectsUsingBlock:^(id inObject, NSUInteger inIndex, BOOL *outStop) {
        [self.managedObjectContext deleteObject:inObject];
    }];
    [self.managedObjectContext save:NULL];
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)inTableView {
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)inTableView numberOfRowsInSection:(NSInteger)inSection {
    id<NSFetchedResultsSectionInfo> theInfo = [[self.fetchedResultsController sections] objectAtIndex:inSection];
    
    return [theInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)inTableView cellForRowAtIndexPath:(NSIndexPath *)inIndexPath {
    NSString *theIdentifier = @"Cell";
    UITableViewCell *theCell = [inTableView dequeueReusableCellWithIdentifier:theIdentifier];
    Score *theScore = [self.fetchedResultsController.fetchedObjects objectAtIndex:inIndexPath.row];
    
    if(theCell == nil) {
        theCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:theIdentifier];
        [theCell autorelease];
    }
    [self applyScore:theScore toCell:theCell];
    return theCell;
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
            [self applyScore:inObject toCell:theCell];
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

@end
