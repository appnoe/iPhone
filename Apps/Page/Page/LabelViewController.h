//
//  PageViewController.h
//  Page
//
//  Created by Clemens Wagner on 30.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LabelViewController : UIViewController

@property (nonatomic) NSInteger pageNumber;
@property (strong, nonatomic) IBOutlet UILabel *label;

- (IBAction)done;
- (IBAction)reset;

@end
