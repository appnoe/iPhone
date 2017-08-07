//
//  DataViewController.m
//  WebView
//
//  Created by Clemens Wagner on 27.04.13.
//  Copyright (c) 2013 Clemens Wagner. All rights reserved.
//

#import "DataViewController.h"

@interface DataViewController ()

@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *cityField;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation DataViewController

- (void)viewWillAppear:(BOOL)inAnimated {
    [super viewWillAppear:inAnimated];
    NSUserDefaults *theDefaults = [NSUserDefaults standardUserDefaults];

    self.titleField.text = [theDefaults objectForKey:@"title"];
    self.nameField.text = [theDefaults objectForKey:@"name"];
    self.cityField.text = [theDefaults objectForKey:@"city"];
    self.textView.text = [theDefaults objectForKey:@"text"];
}

- (void)viewWillDisappear:(BOOL)inAnimated {
    [super viewWillDisappear:inAnimated];
    NSUserDefaults *theDefaults = [NSUserDefaults standardUserDefaults];

    [theDefaults setValue:self.titleField.text forKey:@"title"];
    [theDefaults setValue:self.nameField.text forKey:@"name"];
    [theDefaults setValue:self.cityField.text forKey:@"city"];
    [theDefaults setValue:self.textView.text forKey:@"text"];
}

@end
