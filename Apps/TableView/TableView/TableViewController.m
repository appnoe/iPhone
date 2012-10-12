#import "TableViewController.h"

static NSInteger cellCounter = 0;

@interface TableViewController()<UIAlertViewDelegate>

@property (nonatomic, retain) NSArray *cellIdentifiers;

@end

@implementation TableViewController

@synthesize cellIdentifiers;

- (void)dealloc {
    self.cellIdentifiers = nil;
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cellIdentifiers = [NSArray arrayWithObjects:@"black", @"red", @"green", @"blue", @"yellow", nil];
}

#pragma mark - UITabbleViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)inTableView {
    return 15;
}

- (NSInteger)tableView:(UITableView *)inTableView numberOfRowsInSection:(NSInteger)inSection {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)inTableView cellForRowAtIndexPath:(NSIndexPath *)inIndexPath {
    NSUInteger theIndex = inIndexPath.section % self.cellIdentifiers.count;
    NSString *theIdentifier = [self.cellIdentifiers objectAtIndex:theIndex];
    UITableViewCell *theCell = [inTableView dequeueReusableCellWithIdentifier:theIdentifier];
    
    if (theCell == nil) {
        SEL theSelector = NSSelectorFromString([NSString stringWithFormat:@"%@Color", theIdentifier]);
        
        theCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:theIdentifier] autorelease];
        theCell.textLabel.textColor = [UIColor performSelector:theSelector];
        theCell.detailTextLabel.text = [NSString stringWithFormat:@"%d", cellCounter++];
    }
    theCell.textLabel.text = [NSString stringWithFormat:@"section=%d, row=%d", inIndexPath.section, inIndexPath.row];
    return theCell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)inTableView didSelectRowAtIndexPath:(NSIndexPath *)inIndexPath {
    UIAlertView *theView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Info", @"") 
                                                      message:[NSString stringWithFormat:@"section=%d, row=%d", inIndexPath.section, inIndexPath.row] 
                                                     delegate:self 
                                            cancelButtonTitle:NSLocalizedString(@"OK", @"") 
                                            otherButtonTitles:NSLocalizedString(@"Reset", @""), nil];
    
    [theView show];
    [theView release];
}

#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)inAlertView clickedButtonAtIndex:(NSInteger)inButtonIndex {
    if(inButtonIndex > 0) {
        [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
    }
}

@end
