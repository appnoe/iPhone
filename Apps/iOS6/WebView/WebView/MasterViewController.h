//
//  MasterViewController.h
//  WebView
//
//  Created by Clemens Wagner on 02.04.13.
//  Copyright (c) 2013 Clemens Wagner. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController

@property (strong, nonatomic) DetailViewController *detailViewController;

@end
