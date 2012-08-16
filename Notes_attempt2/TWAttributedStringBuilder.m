//
//  TWAttributeBuilder.m
//  Notes_attempt2
//
//  Created by Thomas Wilson on 25/06/2012.
//  Copyright (c) 2012 aberystwyth university. All rights reserved.
//

#import "TWAttributedStringBuilder.h"

@interface TWAttributedStringBuilder()

	@property (nonatomic)BOOL isBold;
	@property NSInteger *boldCounter;
	@property (nonatomic, retain)TWTextAttribute *boldAttribute;

	-(id)initWithTextInput:(TWInputView *)input;
@end

@implementation TWAttributedStringBuilder
@synthesize textInput = _textInput;
@synthesize attributes = _attributes;
@synthesize boldAttribute = _boldAttribute;
@synthesize boldCounter = _boldCounter;
@synthesize isBold;
@synthesize attributedString = _attributedString;

-(id)init{
	return [self initWithTextInput:(TWInputView *)nil];
}

-(id)initWithTextInput:(TWInputView *)input{
	
	self = [super init];
	if (self) {
		self.textInput = input;
		self.attributes = [[NSMutableArray alloc]init];
		self.boldCounter = 0;
	}
	return self;
	
}

-(void)startBoldAtIndex:(NSInteger)index{
	self.isBold = YES;
	self.boldCounter = 0;
	self.boldAttribute = [[TWTextAttribute alloc]initWithStartingPosition:index];
	self.boldAttribute.attributeKey = (NSString *)kCTFontAttributeName;
	UIFont *currentFont = self.textInput.textView.font;
	NSString *fontname = currentFont.fontName;
	NSString *boldFontName = [fontname stringByAppendingFormat:@"-Bold"];
	
	UIFont *boldFont = [UIFont fontWithName:boldFontName size:currentFont.pointSize];
	UIFont *finalFont;
	if (boldFont){
		finalFont = boldFont;
	}else {
		boldFontName = [fontname stringByAppendingFormat:@"-BoldMT"];
		finalFont = [UIFont fontWithName:boldFontName size:currentFont.pointSize];
	}
	CTFontRef attribute = CTFontCreateWithName((CFStringRef) finalFont.fontName, finalFont.pointSize, NULL); 
	self.boldAttribute.attribute = (id)attribute;
	
}

-(void)endBoldAtIndex:(NSInteger)index{
	isBold = NO;
	self.boldCounter = 0;
	
	self.boldAttribute.length = index;
	
		//[self.attributes addObject:_boldAttribute];
	
	
}

-(NSMutableAttributedString *)getAttributedString{
	if (!_attributedString) {
		NSLog(@"init string");
		CTFontRef ctFont = CTFontCreateWithName((CFStringRef)self.textInput.textView.font.fontName, self.textInput.textView.font.pointSize, NULL);
		NSDictionary *fontDic = [NSDictionary dictionaryWithObject:(id)ctFont forKey:(NSString *)kCTFontAttributeName];

		self.attributedString = [[NSMutableAttributedString alloc]initWithString:self.textInput.text attributes:fontDic];
	}
	
	[self.attributedString replaceCharactersInRange:NSMakeRange([self.attributedString length], 0) withString:self.textInput.text];
	
	
	if (self.boldAttribute) {
		NSDictionary *dicBold = [NSDictionary dictionaryWithObject:(id)self.boldAttribute.attribute forKey:(NSString *)self.boldAttribute.attributeKey];
		if (isBold) {
			[self.attributedString addAttributes:dicBold range:NSMakeRange(self.boldAttribute.start, self.textInput.textView.text.length)];
		}else if(self.boldAttribute){
			[self.attributedString addAttributes:dicBold range:NSMakeRange(self.boldAttribute.start, self.boldAttribute.length)];
			[_boldAttribute release];
			self.boldAttribute = nil;
		}
	}
	
	
	
	
	return _attributedString;
}

-(void)increment{
	if (isBold) {
		_boldCounter++;
	}
}

@end
