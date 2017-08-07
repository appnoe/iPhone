//
//  XPathViewController.m
//  XPath
//
//  Created by Clemens Wagner on 24.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "XPathViewController.h"
#import <TouchXML/TouchXML.h>

@interface XPathViewController ()

@property (nonatomic, strong) CXMLDocument *document;
@property (nonatomic, strong) NSArray *nodes;
@property (nonatomic, strong) NSError *error;

@end

@implementation XPathViewController

@synthesize document;
@synthesize nodes;
@synthesize error;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL *theURL = [[NSBundle mainBundle] URLForResource:@"example" withExtension:@"xml"];
    self.document = [[CXMLDocument alloc] initWithContentsOfURL:theURL options:0 error:NULL];
}

- (void)viewDidUnload {
    self.document = nil;
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)inInterfaceOrientation {
    return YES;
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)inTableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)inTableView numberOfRowsInSection:(NSInteger)inSection {
    return self.error ? 1 : [self.nodes count];
}

- (UITableViewCell *)tableView:(UITableView *)inTableView cellForRowAtIndexPath:(NSIndexPath *)inIndexPath {
    UITableViewCell *theCell = [inTableView dequeueReusableCellWithIdentifier:@"node"];
    
    if(self.error) {
        theCell = [inTableView dequeueReusableCellWithIdentifier:@"error"];
        theCell.textLabel.text = self.error.description;
        theCell.detailTextLabel.text = self.error.domain;
    }
    else {
        CXMLNode *theNode = [self.nodes objectAtIndex:inIndexPath.row];
        UILabel *theLabel;
        
        theCell = [inTableView dequeueReusableCellWithIdentifier:@"node"];
        theLabel = (UILabel *)[theCell.contentView viewWithTag:10];
        theLabel.text = theNode.XMLString;
        theLabel = (UILabel *)[theCell.contentView viewWithTag:20];
        theLabel.text = [[theNode class] description];
        NSLog(@"XML=%@, class=%@", theNode.XMLString, [[theNode class] description]);
    }
    return theCell;
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)inTableView heightForRowAtIndexPath:(NSIndexPath *)inIndexPath {
    if(self.error) {
        return 44.0;
    }
    else {
        CXMLNode *theNode = [self.nodes objectAtIndex:inIndexPath.row];
        UIFont *theFont = [UIFont systemFontOfSize:17.0];
        CGSize theSize = [theNode.XMLString sizeWithFont:theFont 
                                       constrainedToSize:CGSizeMake(600, MAXFLOAT) 
                                           lineBreakMode:UILineBreakModeWordWrap];
        
        return theSize.height;
    }
}

#pragma mark UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)inSearchBar {
    NSError *theError = nil;
    
    self.nodes = [self.document nodesForXPath:inSearchBar.text error:&theError];
    self.error = theError;
    [self.tableView reloadData];
    [inSearchBar endEditing:YES];
}

@end
