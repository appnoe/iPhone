//
//  JavaScriptViewController.m
//  WebView
//
//  Created by Clemens Wagner on 29.04.13.
//  Copyright (c) 2013 Clemens Wagner. All rights reserved.
//

#import "JavaScriptViewController.h"

@interface JavaScriptViewController ()

@property (weak, nonatomic) IBOutlet UITextField *scriptField;
@property (weak, nonatomic) IBOutlet UITextView *resultView;

@end

@implementation JavaScriptViewController

- (IBAction)evaluate {
    NSString *theScript = self.scriptField.text;
    NSString *theResult = [self.webView stringByEvaluatingJavaScriptFromString:theScript];

    self.resultView.text = theResult;
}

@end
