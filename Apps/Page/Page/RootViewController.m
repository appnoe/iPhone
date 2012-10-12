//
//  RootViewController.m
//  Page
//
//  Created by Clemens Wagner on 30.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"
#import "LabelViewController.h"

@interface RootViewController()

@property (nonatomic, strong) UIPageViewController *pageViewController;

@end

@implementation RootViewController

@synthesize orientationControl;
@synthesize spineLocationControl;
@synthesize doubleSidedControl;
@synthesize directionControl;
@synthesize pageViewController;

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidUnload {
    self.orientationControl = nil;
    self.spineLocationControl = nil;
    self.doubleSidedControl = nil;
    self.directionControl = nil;
    self.pageViewController = nil;
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)inInterfaceOrientation {
    return YES;
}

- (UIPageViewControllerSpineLocation)selectedSpineLocation {
    return self.spineLocationControl.selectedSegmentIndex + 1;
}

- (UIPageViewControllerNavigationOrientation)selectedNavigationOrientation {
    return self.orientationControl.selectedSegmentIndex;
}

- (UIPageViewControllerNavigationDirection)selectedDirection {
    return self.directionControl.selectedSegmentIndex;
}

- (UIPageViewControllerSpineLocation)spineLocationForInterfaceOrientation:(UIInterfaceOrientation)inInterfaceOrientation navigationOrientation:(UIPageViewControllerNavigationOrientation)inNavigationOrientation {
    BOOL isHorizontal = inNavigationOrientation == UIPageViewControllerNavigationOrientationHorizontal;
    BOOL isLandscape = UIInterfaceOrientationIsLandscape(inInterfaceOrientation);
    
    return isHorizontal == isLandscape ? UIPageViewControllerSpineLocationMid : self.selectedSpineLocation;
}

- (id)labelViewControllerWithPageNumber:(NSInteger)inPage {
    LabelViewController *theController = [self.storyboard instantiateViewControllerWithIdentifier:@"label"];
    
    theController.pageNumber = inPage;
    return theController;
}

- (NSArray *)viewControllersForSpineLocation:(UIPageViewControllerSpineLocation)inLocation {
    id theController = nil;
    
    if(inLocation == UIPageViewControllerSpineLocationMid) {
        theController = [self labelViewControllerWithPageNumber:1];
    }
    return [NSArray arrayWithObjects:[self labelViewControllerWithPageNumber:0], theController, nil];
}

- (IBAction)create {
    UIPageViewControllerNavigationOrientation theOrientation = self.selectedNavigationOrientation;
    UIPageViewControllerSpineLocation theLocation = [self spineLocationForInterfaceOrientation:self.interfaceOrientation navigationOrientation:theOrientation];
    BOOL isDoubleSided = self.doubleSidedControl.selectedSegmentIndex;
    NSDictionary *theOptions = [NSDictionary dictionaryWithObjectsAndKeys:
                                [NSNumber numberWithInt:theLocation], 
                                UIPageViewControllerOptionSpineLocationKey, nil];
    UIPageViewController *theController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl 
                                                                          navigationOrientation:theOrientation 
                                                                                        options:theOptions];
    NSArray *theControllers = [self viewControllersForSpineLocation:theLocation];
    
    theController.doubleSided = isDoubleSided || theLocation == UIPageViewControllerSpineLocationMid;
    theController.dataSource = self;
    theController.delegate = self;
    theController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [theController setViewControllers:theControllers 
                            direction:self.selectedDirection 
                             animated:YES 
                           completion:NULL];
    [self presentModalViewController:theController animated:YES];
    self.pageViewController = theController;
}

- (IBAction)reset {
    UIPageViewController *theController = self.pageViewController;
    NSArray *theControllers = [self viewControllersForSpineLocation:theController.spineLocation];
    
    [theController setViewControllers:theControllers 
                            direction:self.selectedDirection 
                             animated:YES 
                           completion:NULL];
}

#pragma mark UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)inPageViewController viewControllerBeforeViewController:(UIViewController *)inViewController {
    LabelViewController *theController = (LabelViewController *)inViewController;
    
    return [self labelViewControllerWithPageNumber:theController.pageNumber - 1];
}

- (UIViewController *)pageViewController:(UIPageViewController *)inPageViewController viewControllerAfterViewController:(UIViewController *)inViewController {
    LabelViewController *theController = (LabelViewController *)inViewController;
    
    return [self labelViewControllerWithPageNumber:theController.pageNumber + 1];
}

#pragma mark UIPageViewControllerDelegate

- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)inPageViewController 
                   spineLocationForInterfaceOrientation:(UIInterfaceOrientation)inOrientation {
    
    UIPageViewControllerNavigationOrientation theOrientation = inPageViewController.navigationOrientation;     
    UIPageViewControllerSpineLocation theLocation = [self spineLocationForInterfaceOrientation:inOrientation    
                         navigationOrientation:theOrientation];
    NSArray *theControllers = [self viewControllersForSpineLocation:theLocation];

    [inPageViewController setViewControllers:theControllers 
                                   direction:self.selectedDirection 
                                    animated:YES 
                                  completion:NULL];
    return theLocation;
}

@end
