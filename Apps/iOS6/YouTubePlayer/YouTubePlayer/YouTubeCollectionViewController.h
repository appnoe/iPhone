//
//  YouTubeCollectionViewController.h
//  UniversalYouTube
//
//  Created by Clemens Wagner on 17.07.12.
//  Copyright (c) 2012 Clemens Wagner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YouTubeCollectionViewController : UICollectionViewController

@property(nonatomic, copy) NSString *query;

- (IBAction)refresh:(id)inSender;

@end
