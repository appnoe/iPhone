//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Clemens Wagner on 25.03.14.
//  Copyright (c) 2014 Clemens Wagner. All rights reserved.
//

#import "CalculatorViewController.h"
#import "Calculator.h"

@interface CalculatorViewController ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *termView;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

@property (strong, nonatomic) Calculator *calculator;

@end

@implementation CalculatorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSNotificationCenter * theCenter = [NSNotificationCenter defaultCenter];
    
    [theCenter addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
    [theCenter addObserver:self selector:@selector(keyboardWillDisappear:) name:UIKeyboardWillHideNotification object:nil];
    self.calculator = [Calculator new];
    self.calculator.values = @{@"e": @M_E, @"pi": @M_PI};
}

- (void)keyboardWillAppear:(NSNotification *)inNotification {
    NSValue *theValue = inNotification.userInfo[UIKeyboardFrameEndUserInfoKey];
    NSNumber *theDuration = inNotification.userInfo[UIKeyboardAnimationDurationUserInfoKey];
    UIView *theView = self.view;
    CGRect theFrame = [theView.window convertRect:[theValue CGRectValue] toView:theView];

    self.bottomConstraint.constant = CGRectGetHeight(theFrame) + 10.0;
    [UIView animateWithDuration:[theDuration doubleValue] animations:^{
        [theView layoutIfNeeded];
    }];
}

- (void)keyboardWillDisappear:(NSNotification *)inNotification {
    self.bottomConstraint.constant = 10.0;
}

- (IBAction)calculate {
    NSString *theTerm = self.termView.text;
    double theValue = [self.calculator calculateWithString:theTerm];
    NSInteger thePosition = [self.calculator errorPosition];
    
    if(thePosition < 0) {
        self.resultLabel.text = [NSString stringWithFormat:@"%f", theValue];
        [self.view endEditing:YES];
    }
    else {
        NSRange theRange = NSMakeRange(thePosition, theTerm.length - thePosition);
        
        [self.termView setSelectedRange:theRange];
    }
}

@end
