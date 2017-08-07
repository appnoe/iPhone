//
//  ModalViewController.h
//  Modal
//
//  Created by Clemens Wagner on 12.08.13.
//  Copyright (c) 2013 Cocoaneheads. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ModalViewControllerDelegate;

@interface ModalViewController : UIViewController

@property (nonatomic) NSUInteger counter;
@property (nonatomic, weak) id<ModalViewControllerDelegate> delegate;

@end

@protocol ModalViewControllerDelegate <NSObject>

@optional
- (void)modalViewController:(ModalViewController *)inController didUpdateValue:(CGFloat)inValue;

@end

