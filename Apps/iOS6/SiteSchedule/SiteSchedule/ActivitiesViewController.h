//
//  ActivitiesViewController.h
//  SiteSchedule
//
//  Created by Clemens Wagner on 14.07.12.
//
//

#import <UIKit/UIKit.h>

@interface ActivitiesViewController : UITableViewController

@property (strong, nonatomic) NSArray *activities;

- (void)setUnorderedActivities:(NSSet *)inSet;

@end
