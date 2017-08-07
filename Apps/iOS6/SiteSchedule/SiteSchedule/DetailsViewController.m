//
//  DetailsViewController.m
//  SiteSchedule
//
//  Created by Clemens Wagner on 14.07.12.
//
//

#import "DetailsViewController.h"

@interface DetailsViewController ()

@end

@implementation DetailsViewController

@synthesize activity;

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)inInterfaceOrientation {
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSString *)startDate {
    NSString *theText = [NSDateFormatter localizedStringFromDate:self.activity.start
                                                       dateStyle:NSDateFormatterShortStyle
                                                       timeStyle:NSDateFormatterShortStyle];
    return theText;
}

- (NSString *)endDate {
    NSString *theText = [NSDateFormatter localizedStringFromDate:self.activity.end
                                                       dateStyle:NSDateFormatterShortStyle
                                                       timeStyle:NSDateFormatterShortStyle];
    return theText;
}

- (NSString *)city {
    return [NSString stringWithFormat:@"%@ %@", self.activity.site.zip, self.activity.site.city];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)inTableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)inTableView numberOfRowsInSection:(NSInteger)inSection {
    if(inSection == 0) {
        return 4;
    }
    else if(inSection == 1) {
        return 3;
    }
    else {
        return [self.activity.team.contacts count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)inTableView cellForRowAtIndexPath:(NSIndexPath *)inIndexPath {
    UITableViewCell *theCell;
    
    if(inIndexPath.section < 2) {
        NSString *theKey = [NSString stringWithFormat:@"Cell%d%d", inIndexPath.section, inIndexPath.row];
        theCell = [inTableView dequeueReusableCellWithIdentifier:theKey];
        NSString *thePath;
        
        theKey = [NSString stringWithFormat:@"cell%d%dpath", inIndexPath.section, inIndexPath.row];
        thePath = NSLocalizedString(theKey, @"");
        theCell.detailTextLabel.text = [self valueForKeyPath:thePath];
    }
    else {
        theCell = [inTableView dequeueReusableCellWithIdentifier:@"Cell30"];
        NSArray *theContacts = [self.activity.team.contacts allObjects];
        Contact *theContact = theContacts[inIndexPath.row];
        
        theCell.textLabel.textColor = theContact.isHead ? [UIColor blackColor] : [UIColor darkGrayColor];
        theCell.textLabel.text = theContact.name;
        theCell.detailTextLabel.text = theContact.phone;
    }
    return theCell;
}

#pragma mark UITableViewDelegate

- (NSString *)tableView:(UITableView *)inTableView titleForHeaderInSection:(NSInteger)inSection {
    NSString *theKey = [NSString stringWithFormat:@"Details%d", inSection];
    
    return NSLocalizedString(theKey, @"");
}

@end
