//
//  MarkupViewController.m
//  Markup
//
//  Created by Clemens Wagner on 03.01.13.
//  Copyright (c) 2013 Clemens Wagner. All rights reserved.
//

#import "MarkupViewController.h"
#import "MarkupParser.h"

@interface MarkupViewController ()

@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation MarkupViewController

- (MarkupParser *)markupParser {
    MarkupParser *theParser = [[MarkupParser alloc] init];
    NSMutableParagraphStyle *theStyle = [[NSMutableParagraphStyle alloc] init];
    NSShadow *theShadow = [[NSShadow alloc] init];

    [theParser setAttributes:@{NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle) } forTagName:@"u"];
    [theParser setAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Oblique" size:17] } forTagName:@"em"];
    [theParser setAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Bold" size:17] } forTagName:@"strong"];
    [theParser setAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"Courier" size:17] } forTagName:@"code"];
    [theParser setAttributes:@{NSStrikethroughStyleAttributeName : @(NSUnderlineStyleSingle) } forTagName:@"strike"];
    [theParser setAttributes:@{NSStrokeWidthAttributeName : @3.0, NSStrokeColorAttributeName : [UIColor redColor]  } forTagName:@"stroke"];

    [theParser setAttributes:@{
        NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Bold" size:17],
        NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle),
        NSForegroundColorAttributeName : [UIColor redColor]
     } forTagName:@"blink"];
    theShadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.5 alpha:0.6];
    theShadow.shadowBlurRadius = 2.0;
    theShadow.shadowOffset = CGSizeMake(-1.0, 1.0);
    [theParser setAttributes:@{NSShadowAttributeName : theShadow } forTagName:@"shadow"];

    theStyle.alignment = NSTextAlignmentCenter;
    theStyle.paragraphSpacing = 5.0;
    [theParser setAttributes:@{ NSParagraphStyleAttributeName : theStyle } forTagName:@"p"];
    
    return theParser;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL *theURL = [[NSBundle mainBundle] URLForResource:@"text" withExtension:@"xml"];
    NSError *theError = nil;
    NSAttributedString *theString = [[self markupParser] attributedStringWithContentsOfURL:theURL error:&theError];

    if(theError == nil) {
        self.label.attributedText = theString;
    }
    else {
        self.label.text = [NSString stringWithFormat:@"error=%@", theError];
    }
}

@end
