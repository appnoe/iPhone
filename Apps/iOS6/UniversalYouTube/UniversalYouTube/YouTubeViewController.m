//
//  YouTubeViewController.m
//  YouTube
//
//  Created by Clemens Wagner on 07.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "YouTubeViewController.h"
#import "NSString+URLTools.h"

@interface YouTubeViewController ()

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (copy, nonatomic) NSArray *items;

- (NSURL *)createURL;
- (void)updateItems;

@end

@implementation YouTubeViewController

@synthesize searchBar;
@synthesize items;

- (void)viewDidLoad {
    [super viewDidLoad];
    UIRefreshControl *theControl = self.refreshControl;
    
    if([theControl actionsForTarget:self forControlEvent:UIControlEventValueChanged] == nil) {
        [theControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    }
    self.searchBar.text = @"iOS";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    self.items = nil;
}

- (void)viewWillAppear:(BOOL)inAnimated {
    [super viewWillAppear:inAnimated];
    [self updateItems];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)inInterfaceOrientation {
    return YES;
}

- (IBAction)refresh {
    [self updateItems];
}

- (void)updateItems {
    NSData *theData = [NSData dataWithContentsOfURL:self.createURL];
    NSError *theError = nil;
    NSDictionary *theResult = 
    [NSJSONSerialization JSONObjectWithData:theData options:0 error:&theError];
    
    self.items = [theResult valueForKeyPath:@"feed.entry"];
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}

- (NSURL *)createURL {
    NSString *theQuery = [self.searchBar.text encodedStringForURLWithEncoding:NSUTF8StringEncoding];
    NSString *theURL = [NSString stringWithFormat:@"http://gdata.youtube.com/feeds/api/videos?orderby=published&alt=json&q=%@", theQuery];
                        
    NSLog(@"URL = %@", theURL);
    return [NSURL URLWithString:theURL];
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)inTableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)inTableView numberOfRowsInSection:(NSInteger)inSection {
    return [self.items count];
}

- (UITableViewCell *)tableView:(UITableView *)inTableView cellForRowAtIndexPath:(NSIndexPath *)inIndexPath {
    UITableViewCell *theCell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
    NSDictionary *theItem = (self.items)[inIndexPath.row];

    theCell.textLabel.text = [theItem valueForKeyPath:@"title.$t"];
    theCell.detailTextLabel.text = [theItem valueForKeyPath:@"content.$t"];
    return theCell;
}

#pragma mark UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)inSearchBar {
    [inSearchBar endEditing:YES];
    [self updateItems];
}

@end
