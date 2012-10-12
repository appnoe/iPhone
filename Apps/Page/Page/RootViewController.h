//
//  RootViewController.h
//  Page
//
//  Created by Clemens Wagner on 30.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController<UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UISegmentedControl *orientationControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *spineLocationControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *doubleSidedControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *directionControl;

- (IBAction)create;

@end
