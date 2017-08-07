//
//  YouTubeViewController.m
//  YouTube
//
//  Created by Clemens Wagner on 07.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "YouTubeViewController.h"
#import "JSONKit.h"
#import "NSString+URLTools.h"

#define YOUTUBE_URL @"http://gdata.youtube.com/feeds/api/videos"
#define USE_POST_REQUEST 1
#define USE_JSON_KIT 0

@interface YouTubeViewController()

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, copy) NSArray *items;

- (NSURL *)createURL;
- (void)updateItems;

@end

@implementation YouTubeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchBar.text = @"iOS";
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.searchBar = nil;
    self.items = nil;
}

- (void)viewWillAppear:(BOOL)inAnimated {
    [super viewWillAppear:inAnimated];
    [self updateItems];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)inInterfaceOrientation {
    return YES;
}

- (void)updateItems {
    NSData *theData = [NSData dataWithContentsOfURL:self.createURL];
    NSError *theError = nil;
    NSDictionary *theResult = 
#if USE_JSON_KIT
    [theData objectFromJSONDataWithParseOptions:JKParseOptionStrict error:&theError];
#else
    [NSJSONSerialization JSONObjectWithData:theData options:0 error:&theError];
#endif
    
    self.items = [theResult valueForKeyPath:@"feed.entry"];
    [self.tableView reloadData];
}

- (NSURL *)createURL {
    NSString *theQuery = [self.searchBar.text encodedStringForURLWithEncoding:NSUTF8StringEncoding];
    NSString *theURL = [NSString stringWithFormat:@"%@?orderby=published&alt=json&q=%@", YOUTUBE_URL, theQuery];
                        
    NSLog(@"URL = %@", theURL);
    return [NSURL URLWithString:theURL];
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)inScrollView willDecelerate:(BOOL)inDecelerate {
    CGPoint theOffset = inScrollView.contentOffset;
    
    if(theOffset.y < -CGRectGetHeight(inScrollView.frame) / 4.0) {
        [self updateItems];
    }
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
    NSDictionary *theItem = [self.items objectAtIndex:inIndexPath.row];

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
