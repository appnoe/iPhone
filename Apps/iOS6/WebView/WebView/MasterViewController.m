//
//  MasterViewController.m
//  WebView
//
//  Created by Clemens Wagner on 02.04.13.
//  Copyright (c) 2013 Clemens Wagner. All rights reserved.
//

#import "MasterViewController.h"

#import "DetailViewController.h"

@interface MasterViewController ()

@property (nonatomic, copy) NSArray *items;

@end

@implementation MasterViewController

- (void)awakeFromNib {
    self.clearsSelectionOnViewWillAppear = NO;
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL *theURL = [[NSBundle mainBundle] URLForResource:@"pages" withExtension:@"plist"];

    self.items = [NSArray arrayWithContentsOfURL:theURL];
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)inTableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)inTableView numberOfRowsInSection:(NSInteger)inSection {
    return [self.items count];
}

- (UITableViewCell *)tableView:(UITableView *)inTableView cellForRowAtIndexPath:(NSIndexPath *)inIndexPath {
    UITableViewCell *theCell = [inTableView dequeueReusableCellWithIdentifier:@"Cell"
                                                                 forIndexPath:inIndexPath];
    id theItem = self.items[inIndexPath.row];
    
    theCell.textLabel.text = [theItem valueForKey:@"title"];
    return theCell;
}

- (void)tableView:(UITableView *)inTableView didSelectRowAtIndexPath:(NSIndexPath *)inIndexPath {
    NSDictionary *theItem = self.items[inIndexPath.row];

    [self.detailViewController loadContent:theItem];
}

@end
