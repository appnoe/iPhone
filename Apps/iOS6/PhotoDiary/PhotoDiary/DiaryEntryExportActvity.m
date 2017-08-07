//
//  ExportActvity.m
//  PhotoDiary
//
//  Created by Clemens Wagner on 15.09.13.
//  Copyright (c) 2013 Cocoaneheads. All rights reserved.
//

#import "DiaryEntryExportActvity.h"
#import "ExportViewController.h"
#import "Model.h"

NSString * const kActivityTypeExport = @"de.cocoaneheads.DiaryEntryExportActvity";

@interface DiaryEntryExportActvity()

@property (nonatomic, strong) IBOutlet UIViewController *activityViewController;

@end


@implementation DiaryEntryExportActvity

- (NSString *)activityType {
    return kActivityTypeExport;
}

- (NSString *)activityTitle {
    return NSLocalizedString(@"Export", @"Activity Title");
}

- (UIImage *)activityImage {
    return [UIImage imageNamed:@"export"];
}

- (BOOL)canPerformWithActivityItems:(NSArray *)inItems {
    NSPredicate *thePredicate = [NSPredicate predicateWithFormat:@"ANY self isKindOfClass:%@", [DiaryEntry class]];

    return [thePredicate evaluateWithObject:inItems];
}

- (void)prepareWithActivityItems:(NSArray *)inItems {
    NSPredicate *thePredicate = [NSPredicate predicateWithFormat:@"self isKindOfClass:%@", [DiaryEntry class]];
    NSArray *theEntries = [inItems filteredArrayUsingPredicate:thePredicate];
    UINavigationController *theController = [self.storyboard instantiateViewControllerWithIdentifier:@"export"];
    ExportViewController *theExportController = theController.viewControllers[0];

    theExportController.activity = self;
    theExportController.diaryEntry = theEntries[0];
    self.activityViewController = theController;
}

- (void)performActivity {
    NSLog(@"performActivity");
}

@end