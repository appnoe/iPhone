//
//  SitesViewController.m
//  SiteSchedule
//
//  Created by Clemens Wagner on 14.07.12.
//
//

#import "SitesViewController.h"
#import "Model.h"
#import "ActivitiesViewController.h"
#import "UIViewController+SiteSchedule.h"

@interface SitesViewController()

@property (strong, nonatomic) NSManagedObjectContext *objectContext;
@property (strong, nonatomic) NSFetchedResultsController *resultsController;

@end

@implementation SitesViewController

@synthesize objectContext;
@synthesize resultsController;

- (NSFetchedResultsController *)createFetchedResultsController {
    NSFetchRequest *theRequest = [NSFetchRequest fetchRequestWithEntityName:@"Site"];
    NSArray *theDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"city" ascending:YES],
                               [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    NSFetchedResultsController *theController;

    theRequest.sortDescriptors = theDescriptors;
    theController = [[NSFetchedResultsController alloc] initWithFetchRequest:theRequest
                                                        managedObjectContext:self.objectContext
                                                          sectionNameKeyPath:@"city" 
                                                                   cacheName:@"Sites"];
    return theController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSNotificationCenter *theCenter = [NSNotificationCenter defaultCenter];
    
    self.objectContext = [self newManagedObjectContext];
    [theCenter addObserver:self
                  selector:@selector(managedObjectContextDidSave:)
                      name:NSManagedObjectContextDidSaveNotification
                    object:nil];
}

- (void)viewWillAppear:(BOOL)inAnimated {
    [super viewWillAppear:inAnimated];
    NSError *theError = nil;
    
    self.resultsController = [self createFetchedResultsController];
    if(![self.resultsController performFetch:&theError]) {
        NSLog(@"viewWillAppear: error=%@", theError);
    }
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)inAnimated {
    self.resultsController = nil;
    [super viewWillDisappear:inAnimated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)inInterfaceOrientation {
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)inSegue sender:(id)inSender {
    if([inSegue.identifier isEqualToString:@"Activity"]) {
        NSIndexPath *theIndexPath = [self.tableView indexPathForSelectedRow];
        Site *theSite = [self.resultsController objectAtIndexPath:theIndexPath];
        ActivitiesViewController *theController = inSegue.destinationViewController;
        
        [theController setUnorderedActivities:theSite.activities];
    }
}

- (IBAction)overview:(UIStoryboardSegue *)inSegue {
}

- (void)managedObjectContextDidSave:(NSNotification *)inNotification {
    if(self.resultsController) {
        NSError *theError = nil;
        
        if([self.resultsController performFetch:&theError]) {
            [self.tableView reloadData];
        }
        else {
            NSLog(@"viewDidLoad: error=%@", theError);
        }   
    }
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)inTableView {
    return [[self.resultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)inTableView numberOfRowsInSection:(NSInteger)inSection {
    id<NSFetchedResultsSectionInfo> theInfo = [self.resultsController sections][inSection];
    
    return [theInfo numberOfObjects];
}

- (NSString *)tableView:(UITableView *)inTableView titleForHeaderInSection:(NSInteger)inSection {
    id<NSFetchedResultsSectionInfo> theInfo = [self.resultsController sections][inSection];
    
    return [theInfo name];
}

- (UITableViewCell *)tableView:(UITableView *)inTableView cellForRowAtIndexPath:(NSIndexPath *)inIndexPath {
    UITableViewCell *theCell = [inTableView dequeueReusableCellWithIdentifier:@"Site"];
    Site *theSite = [self.resultsController objectAtIndexPath:inIndexPath];
    
    theCell.textLabel.text = theSite.name;
    theCell.detailTextLabel.text = theSite.street;
    return theCell;
}

@end
