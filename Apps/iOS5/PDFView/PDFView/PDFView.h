//
//  PDFView.h
//  PDFView
//
//  Created by Clemens Wagner on 25.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDFView : UIView

- (CGPDFDocumentRef)document;
- (void)setDocument:(CGPDFDocumentRef)inDocument;

- (size_t)countOfPages;

@end