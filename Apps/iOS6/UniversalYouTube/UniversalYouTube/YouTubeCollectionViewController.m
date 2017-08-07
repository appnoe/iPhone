//
//  YouTubeCollectionViewController.m
//  UniversalYouTube
//
//  Created by Clemens Wagner on 17.07.12.
//  Copyright (c) 2012 Clemens Wagner. All rights reserved.
//

#import "YouTubeCollectionViewController.h"
#import "NSString+URLTools.h"
#import "YouTubeCell.h"
#import "StackLayout.h"

@interface YouTubeCollectionViewController ()<UICollectionViewDelegateFlowLayout, UISearchBarDelegate>

@property (copy, nonatomic) NSArray *items;

@end

@implementation YouTubeCollectionViewController

@synthesize query;
@synthesize items;

- (void)viewDidLoad {
    [super viewDidLoad];
    UICollectionView *theView = self.collectionView;
    
    self.query = @"iOS";
    [theView registerClass:[YouTubeCell class] forCellWithReuseIdentifier:@"YouTube"];
    if(![theView.collectionViewLayout isKindOfClass:[UICollectionViewFlowLayout class]]) {
        UINib *theNib = [UINib nibWithNibName:@"Searchbar" bundle:nil];
        
        [theView registerNib:theNib forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Searchbar"];
        theNib = [UINib nibWithNibName:@"Toolbar" bundle:nil];
        [theView registerNib:theNib forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"Toolbar"];
        theNib = [UINib nibWithNibName:@"Logo" bundle:nil];
        [theView.collectionViewLayout registerNib:theNib forDecorationViewOfKind:@"Logo"];
    }
    [self updateItems];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    self.items = nil;
}

- (void)updateItems {
    UIApplication *theApplication = [UIApplication sharedApplication];
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:self.createURL];
    NSOperationQueue *theQueue = [NSOperationQueue mainQueue];
    
    theApplication.networkActivityIndicatorVisible = YES;
    [NSURLConnection sendAsynchronousRequest:theRequest queue:theQueue completionHandler:^(NSURLResponse *inResponse, NSData *inData, NSError *inError) {
        if(inData == nil) {
            NSLog(@"error = %@", inError);
        }
        else {
            NSError *theError = nil;
            NSDictionary *theResult = [NSJSONSerialization JSONObjectWithData:inData options:0 error:&theError];
        
            self.items = [theResult valueForKeyPath:@"feed.entry"];
            [self.collectionView reloadData];
            theApplication.networkActivityIndicatorVisible = NO;
        }
    }];
}

- (IBAction)refresh:(id)inSender {
    [self updateItems];
}

- (NSURL *)createURL {
    NSString *theQuery = [self.query encodedStringForURLWithEncoding:NSUTF8StringEncoding];
    NSString *theURL = [NSString stringWithFormat:@"http://gdata.youtube.com/feeds/api/videos?orderby=published&alt=json&q=%@", theQuery];
    
    NSLog(@"URL = %@", theURL);
    return [NSURL URLWithString:theURL];
}

#pragma mark UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)inCollectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)inCollectionView numberOfItemsInSection:(NSInteger)inSection {
    return self.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)inCollectionView
                  cellForItemAtIndexPath:(NSIndexPath *)inIndexPath {
    YouTubeCell *theCell = [inCollectionView dequeueReusableCellWithReuseIdentifier:@"YouTube" forIndexPath:inIndexPath];
    NSDictionary *theItem = (self.items)[inIndexPath.row];
    float theRating = [[theItem valueForKeyPath:@"gd$rating.average"] floatValue];
    UIColor *theColor;
    
    if(theRating < 1) {
        theColor = [UIColor darkGrayColor];
    }
    else {
        float theValue = (theRating - 1.0) / 4.0;
        
        theColor = [UIColor colorWithRed:1.0 - theValue green:theValue blue:0.0 alpha:1.0];
    }
    theCell.title = [theItem valueForKeyPath:@"title.$t"];
    theCell.text = [theItem valueForKeyPath:@"content.$t"];
    theCell.titleColor = theColor;
    return theCell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)inCollectionView
           viewForSupplementaryElementOfKind:(NSString *)inKind atIndexPath:(NSIndexPath *)inIndexPath {
    UICollectionReusableView *theView = nil;
    
    if([UICollectionElementKindSectionHeader isEqualToString:inKind]) {
        theView = [inCollectionView dequeueReusableSupplementaryViewOfKind:inKind
                                                       withReuseIdentifier:@"Searchbar"
                                                              forIndexPath:inIndexPath];
        UISearchBar *theSearchBar = (UISearchBar *)[theView viewWithTag:10];
        
        theSearchBar.text = self.query;
        theSearchBar.delegate = self;
    }
    else if([UICollectionElementKindSectionFooter isEqualToString:inKind]) {
        theView = [inCollectionView dequeueReusableSupplementaryViewOfKind:inKind
                                                       withReuseIdentifier:@"Toolbar"
                                                              forIndexPath:inIndexPath];
    }
    return theView;
}

#pragma mark UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)inCollectionView didSelectItemAtIndexPath:(NSIndexPath *)inIndexPath {
    [inCollectionView reloadItemsAtIndexPaths:@[inIndexPath]];
}

- (void)collectionView:(UICollectionView *)inCollectionView didDeselectItemAtIndexPath:(NSIndexPath *)inIndexPath {
    [inCollectionView reloadItemsAtIndexPaths:@[inIndexPath]];
}

#pragma mark UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)inCollectionView layout:(UICollectionViewLayout *)inCollectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)inIndexPath {
    YouTubeCell *theCell = [[YouTubeCell alloc] initWithFrame:CGRectNull];
    NSDictionary *theItem = (self.items)[inIndexPath.row];
    CGSize theSize = CGSizeMake(244.0, 300.0);
    
    theCell.text = [theItem valueForKeyPath:@"content.$t"];
    return CGSizeMake(244.0, [theCell sizeThatFits:theSize].height);
}

#pragma mark UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)inSearchBar {
    [inSearchBar endEditing:YES];
    self.query = inSearchBar.text;
    [self updateItems];
}

@end
