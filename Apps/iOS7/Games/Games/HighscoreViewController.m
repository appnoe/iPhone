#import "HighscoreViewController.h"
#import "Score.h"
#import "GamesAppDelegate.h"

static NSString * const kScoreFilters[] = {
    nil, @"puzzle", @"memory", @"breakout"
};

@interface HighscoreViewController()<NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation HighscoreViewController

@synthesize filterControl;
@synthesize managedObjectContext;
@synthesize fetchedResultsController;
@synthesize dateFormatter;

- (void)awakeFromNib {
    [super awakeFromNib];
    NSNotificationCenter *theCenter = [NSNotificationCenter defaultCenter];

    [theCenter addObserver:self
                  selector:@selector(managedObjectContextDidSave:)
                      name:NSManagedObjectContextDidSaveNotification
                    object:nil];
}

- (NSManagedObjectContext *)managedObjectContext {
    if(managedObjectContext == nil) {
        NSManagedObjectContext *theContext = [[NSManagedObjectContext alloc] init];
        GamesAppDelegate *theDelegate = (id)[[UIApplication sharedApplication] delegate];
        
        theContext.persistentStoreCoordinator = theDelegate.storeCoordinator;
        self.managedObjectContext = theContext;
    }
    return managedObjectContext;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDateFormatter *theFormatter = [[NSDateFormatter alloc] init];

    theFormatter.locale = [NSLocale currentLocale];
    theFormatter.dateFormat = @"d. MMM yyyy HH:mm:ss";
    self.dateFormatter = theFormatter;
    self.tableView.allowsSelection = NO;
    [self filterChanged];
}

- (void)viewWillDisappear:(BOOL)inAnimated {
    self.navigationController.tabBarItem.badgeValue = nil;
    [super viewWillDisappear:inAnimated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    self.fetchedResultsController = nil;
    self.dateFormatter = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)inOrientation {
    return inOrientation == UIInterfaceOrientationPortrait;
}

- (void)managedObjectContextDidSave:(NSNotification *)inNotification {
    if(inNotification.object != self.managedObjectContext) {
        NSInteger theCount = [inNotification.userInfo[NSInsertedObjectsKey] count];

        [self.managedObjectContext mergeChangesFromContextDidSaveNotification:inNotification];
        [self updateBadgeWithCount:theCount];
    }
}

- (void)updateBadgeWithCount:(NSInteger)inCount {
    UITabBarItem *theItem = self.navigationController.tabBarItem;
    NSInteger theCount = [theItem.badgeValue intValue] + inCount;

    if(theCount > 0) {
        NSString *theValue = [NSString stringWithFormat:@"%d", (int)theCount];

        theItem.badgeValue = theValue;
    }
    else {
        theItem.badgeValue = nil;
    }
}

- (void)applyScore:(Score *)inScore toCell:(UITableViewCell *)inCell {
    UIImage *theImage = [UIImage imageNamed:inScore.game];
    
    inCell.imageView.image = theImage;
    inCell.textLabel.text = [NSString stringWithFormat:@"%@", inScore.score];
    inCell.detailTextLabel.text = [self.dateFormatter stringFromDate:inScore.creationTime];
}

- (NSFetchRequest *)fetchRequestWithFilterIndex:(NSUInteger)inIndex {
    NSFetchRequest *theFetch = [[NSFetchRequest alloc] init];
    NSString *theFilter = kScoreFilters[inIndex];
    NSEntityDescription *theEntity = [NSEntityDescription entityForName:@"Score" 
                                                 inManagedObjectContext:self.managedObjectContext];
    NSSortDescriptor *theDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"score" ascending:NO];
    
    theFetch.entity = theEntity;
    theFetch.sortDescriptors = @[theDescriptor];
    if(theFilter) {
        theFetch.predicate = [NSPredicate predicateWithFormat:@"game = %@", theFilter];
    }
    return theFetch;
}

- (IBAction)filterChanged {
    NSInteger theIndex = self.filterControl.selectedSegmentIndex;
    
    if(theIndex >= 0) {
        NSFetchRequest *theRequest = [self fetchRequestWithFilterIndex:theIndex];
        NSError *theError = nil;
        NSFetchedResultsController *theController = [[NSFetchedResultsController alloc] initWithFetchRequest:theRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
        
        theController.delegate = self;
        self.fetchedResultsController = theController;
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
    id<NSFetchedResultsSectionInfo> theInfo = [self.fetchedResultsController sections][inSection];
    
    return [theInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)inTableView cellForRowAtIndexPath:(NSIndexPath *)inIndexPath {
    UITableViewCell *theCell = [inTableView dequeueReusableCellWithIdentifier:@"score"];
    Score *theScore = (self.fetchedResultsController.fetchedObjects)[inIndexPath.row];
    
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
        default:
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)inController {
    [self.tableView endUpdates];
}

@end
