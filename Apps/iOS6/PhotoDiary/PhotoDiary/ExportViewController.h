//
//  ExportViewController.h
//  PhotoDiary
//
//  Created by Clemens Wagner on 16.09.13.
//  Copyright (c) 2013 Cocoaneheads. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model.h"

@interface ExportViewController : UIViewController

@property (nonatomic, weak) UIActivity *activity;
@property (nonatomic, strong) DiaryEntry *diaryEntry;

@end
