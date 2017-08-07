//
//  ModalViewController.h
//  Container
//
//  Created by Clemens Wagner on 31.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SupernumeraryViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) IBOutlet UIButton *closeButton;

- (IBAction)close;

@end
