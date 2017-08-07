//
//  PDFView.m
//  PDFView
//
//  Created by Clemens Wagner on 25.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDFView.h"
#import <QuartzCore/QuartzCore.h>

@interface PDFView()

- (void)drawPage:(CGPDFPageRef)inPage inRect:(CGRect)inRect context:(CGContextRef)inContext;

@end

@implementation PDFView {
    CGPDFDocumentRef document;
}

+ (id)layerClass {
    return [CATiledLayer class];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    CATiledLayer *theLayer = (CATiledLayer *)self.layer;
    
    theLayer.levelsOfDetail = 4;
    theLayer.levelsOfDetailBias = 4;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CATiledLayer *theLayer = (CATiledLayer *)self.layer;
    CGSize theSize = self.bounds.size;

    theSize.height /= 4 * self.countOfPages;
    theLayer.tileSize = theSize;    
}

- (void)dealloc {
    CGPDFDocumentRelease(document);
}

- (CGPDFDocumentRef)document {
    return document;
}

- (void)setDocument:(CGPDFDocumentRef)inDocument {
    if(inDocument != document) {
        CGPDFDocumentRelease(document);
        document = inDocument;
        CGPDFDocumentRetain(document);
    }
}

- (size_t)countOfPages {
    return CGPDFDocumentGetNumberOfPages(self.document);
}

- (void)drawRect:(CGRect)inRect {
    CGContextRef theContext = UIGraphicsGetCurrentContext();
    CGRect theBounds = self.bounds;
    size_t theCount = self.countOfPages;
    CGFloat theHeight = CGRectGetHeight(theBounds) / theCount;
    CGRect thePageFrame = theBounds;

    NSLog(@"drawRect:%@", NSStringFromCGRect(inRect));
    thePageFrame.size.height = theHeight;
    for(int i = 0; i < theCount; ++i) {
        thePageFrame.origin.y = i * theHeight;
        if(CGRectIntersectsRect(inRect, thePageFrame)) {
            CGPDFPageRef thePage = CGPDFDocumentGetPage(self.document, i + 1);
            
            CGContextSaveGState(theContext);
            CGContextSetGrayStrokeColor(theContext, 0.5, 1.0);
            CGContextStrokeRect(theContext, CGRectInset(thePageFrame, 10.0, 10.0));
            CGContextScaleCTM(theContext, 1.0, -1.0);
            thePageFrame.origin.y = -(i + 1) * theHeight;
            [self drawPage:thePage inRect:thePageFrame context:theContext];
            CGContextRestoreGState(theContext);
        }
    }
}

- (void)drawPage:(CGPDFPageRef)inPage inRect:(CGRect)inRect context:(CGContextRef)inContext {
    CGAffineTransform theTransform = CGPDFPageGetDrawingTransform(inPage, kCGPDFMediaBox, inRect, 0, YES);
    
    CGContextConcatCTM(inContext, theTransform);
    CGContextDrawPDFPage(inContext, inPage);
}

@end
