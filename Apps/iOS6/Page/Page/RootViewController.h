//
//  RootViewController.h
//  Page
//
//  Created by Clemens Wagner on 30.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UITableViewController<UIPageViewControllerDataSource, UIPageViewControllerDelegate>

- (IBAction)create;

@end
