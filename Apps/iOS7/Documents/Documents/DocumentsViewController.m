//
//  DocumentsViewController.m
//  Documents
//
//  Created by Clemens Wagner on 13.10.13.
//  Copyright (c) 2013 Clemens Wagner. All rights reserved.
//

#import "DocumentsViewController.h"

@interface DocumentsViewController ()

@property (nonatomic, strong) NSArray *fileSuffixes;

@end

@implementation DocumentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fileSuffixes = @[@"txt", @"rtf", @"rtfd", @"html"];
}

- (NSAttributedString *)textWithFileSuffix:(NSString *)inSuffix {
    NSError *theError = nil;
    NSURL *theURL = [[NSBundle mainBundle] URLForResource:@"text" withExtension:inSuffix];
    NSAttributedString *theText = [[NSAttributedString alloc] initWithFileURL:theURL
                                                                      options:nil
                                                           documentAttributes:NULL
                                                                        error:&theError];
    
    if(theText == nil) {
        return [[NSAttributedString alloc] initWithString:theError.localizedDescription];
    }
    else {
        return theText;
    }
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)inTableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)inTableView numberOfRowsInSection:(NSInteger)inSection {
    return [self.fileSuffixes count];
}

- (UITableViewCell *)tableView:(UITableView *)inTableView cellForRowAtIndexPath:(NSIndexPath *)inIndexPath {
    UITableViewCell *theCell = [inTableView dequeueReusableCellWithIdentifier:@"document" forIndexPath:inIndexPath];
    UITextView *theView = theCell.contentView.subviews[0];
    
    theView.attributedText = [self textWithFileSuffix:self.fileSuffixes[inIndexPath.row]];
    return theCell;
}

@end
