//
//  ViewController.m
//  FormFoo
//
//  Created by Klaus Rodewig on 07.11.14.
//  Copyright (c) 2014 Cocoaneheads. All rights reserved.
//

#import "ViewController.h"
#import "RootForm.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.formController.form = [[RootForm alloc] init];
    [self setupFormWithData];
}

-(void)setupFormWithData{
    RootForm *theForm = self.formController.form;
    
    theForm.name = @"Willi";
    theForm.surName = @"Wurst";
    [self.formController.tableView reloadData];
}

@end
