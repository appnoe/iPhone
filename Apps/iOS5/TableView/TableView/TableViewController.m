//
//  TableViewMasterViewController.m
//  TableView
//
//  Created by Clemens Wagner on 14.09.13.
//  Copyright (c) 2013 Cocoaneheads. All rights reserved.
//

#import "TableViewController.h"

@interface TableViewController ()

@property (nonatomic, copy) NSArray *cellIdentifiers;

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cellIdentifiers = @[@"black", @"red", @"green", @"blue", @"yellow"];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)inTableView {
    return 15;
}

- (NSInteger)tableView:(UITableView *)inTableView numberOfRowsInSection:(NSInteger)inSection {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)inTableView cellForRowAtIndexPath:(NSIndexPath *)inIndexPath {
    static NSInteger cellCounter = 0;
    NSUInteger theIndex = inIndexPath.section % self.cellIdentifiers.count;
    NSString *theIdentifier = [self.cellIdentifiers objectAtIndex:theIndex];
    UITableViewCell *theCell = [inTableView dequeueReusableCellWithIdentifier:theIdentifier forIndexPath:inIndexPath];

    if([theCell.detailTextLabel.text length] == 0) {
        theCell.detailTextLabel.text = [NSString stringWithFormat:@"%d", cellCounter++];
    }
    theCell.textLabel.text = [NSString stringWithFormat:@"section=%d, row=%d", inIndexPath.section, inIndexPath.row];
    return theCell;
}

@end
