//
//  PhotoDiaryViewController.h
//  PhotoDiary
//
//  Created by Clemens Wagner on 10.09.13.
//  Copyright (c) 2013 Cocoaneheads. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface PhotoDiaryViewController : UITableViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
