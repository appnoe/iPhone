//
//  ContainerViewController.h
//  Container
//
//  Created by Clemens Wagner on 31.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContainerViewController : UIViewController

@property (nonatomic, copy) NSArray *viewControllers;
@property (strong, nonatomic) IBOutlet UIView *containerView;

@end
