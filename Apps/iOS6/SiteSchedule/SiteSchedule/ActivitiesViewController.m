//
//  ActivitiesViewController.m
//  SiteSchedule
//
//  Created by Clemens Wagner on 14.07.12.
//
//

#import "ActivitiesViewController.h"
#import "DetailsViewController.h"
#import "PhotoUploadViewController.h"
#import "Model.h"

@interface ActivitiesViewController ()

@end

@implementation ActivitiesViewController

@synthesize activities;

- (void)setUnorderedActivities:(NSSet *)inSet {
    NSSortDescriptor *theDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"start" ascending:YES];
    
    self.activities = [inSet sortedArrayUsingDescriptors:@[theDescriptor]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)inSegue sender:(id)inSender {
    NSIndexPath *theIndexPath = [self.tableView indexPathForSelectedRow];
    Activity *theActivity = (self.activities)[theIndexPath.row];

    if([inSegue.identifier isEqualToString:@"Details"]) {
        DetailsViewController *theController = inSegue.destinationViewController;
        
        theController.activity = theActivity;
    }
    else if([inSegue.identifier isEqualToString:@"Photo"]) {
        PhotoUploadViewController *theController = inSegue.destinationViewController;
        
        theController.activity = theActivity;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)inInterfaceOrientation {
    return NO;
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)inTableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)inTableView numberOfRowsInSection:(NSInteger)inSection {
    return [self.activities count];
}

- (UITableViewCell *)tableView:(UITableView *)inTableView cellForRowAtIndexPath:(NSIndexPath *)inIndexPath {
    UITableViewCell *theCell = [inTableView dequeueReusableCellWithIdentifier:@"Activity"];
    Activity *theActivity = (self.activities)[inIndexPath.row];
    
    theCell.textLabel.text = theActivity.team.name;
    theCell.detailTextLabel.text = theActivity.details;
    return theCell;
}

@end
