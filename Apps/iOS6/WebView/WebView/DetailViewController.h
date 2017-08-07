//
//  DetailViewController.h
//  WebView
//
//  Created by Clemens Wagner on 02.04.13.
//  Copyright (c) 2013 Clemens Wagner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate, UIWebViewDelegate>

@property (nonatomic, weak) id valueObject;

- (void)loadContent:(NSDictionary *)inItem;

@end
