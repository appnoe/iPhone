//
//  PDFViewController.m
//  PDFView
//
//  Created by Clemens Wagner on 25.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDFViewController.h"

@interface PDFViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet PDFView *pdfView;

- (IBAction)zoomIn:(UITapGestureRecognizer *)inSender;

@end

@implementation PDFViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL *theURL = [[NSBundle mainBundle] URLForResource:@"lorem-ipsum" withExtension:@"pdf"];
    CGPDFDocumentRef theDocument = CGPDFDocumentCreateWithURL((__bridge CFURLRef) theURL);
        
    self.pdfView.document = theDocument;
    CGPDFDocumentRelease(theDocument);
}

- (void)viewWillAppear:(BOOL)inAnimated {
    [super viewWillAppear:inAnimated];
    CGRect theFrame = self.pdfView.frame;
    
    theFrame.size.height = CGRectGetHeight(self.scrollView.frame) * self.pdfView.countOfPages;
    self.scrollView.contentSize = theFrame.size;
    self.pdfView.frame = theFrame;
}

- (IBAction)zoomIn:(UITapGestureRecognizer *)inSender {
    CGFloat theScale = 2 * self.scrollView.zoomScale;
    
    [self.scrollView setZoomScale:theScale animated:YES];
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)inScrollView {
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)inScrollView {
    return self.pdfView;
}

@end
