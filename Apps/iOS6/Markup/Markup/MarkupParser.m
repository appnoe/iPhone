//
//  MarkupParser.m
//  Markup
//
//  Created by Clemens Wagner on 03.01.13.
//  Copyright (c) 2013 Clemens Wagner. All rights reserved.
//

#import "MarkupParser.h"
#import "UIColor+StringParsing.h"

@interface Markup : NSObject

@property (nonatomic) NSUInteger position;
@property (nonatomic, strong) NSMutableDictionary *attributes;

+ (id)markupWithPosition:(NSUInteger)inPosition attributes:(NSDictionary *)inAttributes;
- (void)addAttribute:(id)inValue forName:(NSString *)inName;

@end

@interface MarkupParser()

@property (nonatomic, strong, readwrite) NSMutableAttributedString *text;
@property (nonatomic, strong) NSMutableDictionary *attributesByTagName;

@property (nonatomic, strong) NSMutableArray *stack;

@end

@implementation MarkupParser

- (id)init {
    self = [super init];
    if (self) {
        self.attributesByTagName = [NSMutableDictionary dictionary];
    }
    return self;
}

- (NSAttributedString *)attributedString {
    return [self.text copy];
}

- (NSDictionary *)attributesForTagName:(NSString *)inName {
    return [self.attributesByTagName valueForKey:inName];
}

- (void)setAttributes:(NSDictionary *)inAttributes forTagName:(NSString *)inName {
    [self.attributesByTagName setValue:inAttributes forKey:inName];
}

- (NSAttributedString *)attributedStringWithContentsOfURL:(NSURL *)inURL error:(NSError **)outError {
    NSXMLParser *theParser = [[NSXMLParser alloc] initWithContentsOfURL:inURL];

    theParser.delegate = self;
    [theParser parse];
    if(outError != NULL) {
        *outError = theParser.parserError;
    }
    return theParser.parserError == nil ? [self attributedString] : nil;
}

#pragma mark NSXMLParserDelegate

- (void)parserDidStartDocument:(NSXMLParser *)inParser {
    self.text = [[NSMutableAttributedString alloc] init];
    self.stack = [NSMutableArray arrayWithCapacity:20];
}

- (void)parserDidEndDocument:(NSXMLParser *)inParser {
}

- (void)parser:(NSXMLParser *)inParser didStartElement:(NSString *)inElementName namespaceURI:(NSString *)inNamespaceURI qualifiedName:(NSString *)inQualifiedName attributes:(NSDictionary *)inAttributes {
    NSDictionary *theAttributes = [self attributesForTagName:inElementName];

    if([inElementName isEqualToString:@"p"]) {
        [self.text.mutableString appendString:@"\n"];
    }
    if(theAttributes != nil) {
        NSUInteger thePosition = [self.text length];
        Markup *theMarkup = [Markup markupWithPosition:thePosition attributes:theAttributes];
        UIColor *theTextColor = [UIColor colorWithString:inAttributes[@"color"]];
        UIColor *theBackgroundColor = [UIColor colorWithString:inAttributes[@"background-color"]];

        [theMarkup addAttribute:theTextColor forName:NSForegroundColorAttributeName];
        [theMarkup addAttribute:theBackgroundColor forName:NSBackgroundColorAttributeName];
        [self.stack addObject:theMarkup];
    }
}

- (void)parser:(NSXMLParser *)inParser didEndElement:(NSString *)inElementName namespaceURI:(NSString *)inNamespaceURI qualifiedName:(NSString *)inQualifiedName {
    if([self.attributesByTagName objectForKey:inElementName] != nil) {
        NSUInteger thePosition = [self.text length];
        Markup *theMarkup = [self.stack lastObject];
        NSRange theRange = NSMakeRange(theMarkup.position, thePosition - theMarkup.position);

        [self.stack removeLastObject];
        [self.text addAttributes:theMarkup.attributes range:theRange];
    }
}

- (void)parser:(NSXMLParser *)inParser foundCharacters:(NSString *)inCharacters {
    NSAttributedString *theString = [[NSAttributedString alloc] initWithString:inCharacters];
    
    [self.text appendAttributedString:theString];
}

@end

@implementation Markup

@synthesize position;
@synthesize attributes;

+ (id)markupWithPosition:(NSUInteger)inPosition attributes:(NSDictionary *)inAttributes {
    Markup *theTag = [[[self class] alloc] init];
    NSMutableDictionary *theAttributes = [NSMutableDictionary dictionaryWithDictionary:inAttributes];

    [theTag setPosition:inPosition];
    [theTag setAttributes:theAttributes];
    return theTag;
}

- (void)addAttribute:(id)inValue forName:(NSString *)inName {
    if(inValue != nil) {
        [self.attributes setValue:inValue forKey:inName];
    }
}

@end
