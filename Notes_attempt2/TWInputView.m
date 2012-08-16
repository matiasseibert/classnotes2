//
//  TWInputView.m
//  Notes - Attempt 2
//
//  Created by Thomas Wilson on 21/06/2012.
//  Copyright (c) 2012 aberystwyth university. All rights reserved.
//

#import "TWInputView.h"

@implementation TWInputView
@synthesize text = _text;
@synthesize tokenizer= _tokenizer;
@synthesize inputDelegate;
@synthesize textView=_textView;
@synthesize attributes = _attributes;
@synthesize currentDocument = _currentDocument;
	//UITextInput
@synthesize beginningOfDocument;
@synthesize endOfDocument;
@synthesize markedTextStyle;
@synthesize sectionAffinity;

	//UITextInputTraits
@synthesize autocapitalizationType;
@synthesize autocorrectionType;
@synthesize enablesReturnKeyAutomatically;
@synthesize keyboardAppearance;
@synthesize keyboardType;
@synthesize returnKeyType;
@synthesize secureTextEntry;
@synthesize spellCheckingType;


- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	if (self) {
		self.backgroundColor = [UIColor blueColor];
			//_text = [[NSMutableAttributedString alloc]init];
		
		_textView = [[TWTextView alloc] initWithFrame:self.bounds];
			//_textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.userInteractionEnabled = YES;
		
		CTFontRef ctFont = CTFontCreateWithName((CFStringRef)_textView.font.fontName, _textView.font.pointSize, NULL);
		self.attributes = [[NSMutableDictionary alloc]initWithObjectsAndKeys:(id)ctFont, (NSString *)kCTFontAttributeName
						   , nil];
		
		
		_tokenizer = [[UITextInputStringTokenizer alloc]initWithTextInput:self];
		UITapGestureRecognizer *tapper = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
		
		_textView.userInteractionEnabled = NO;
		
		[self addSubview:_textView];
		[self addGestureRecognizer:tapper];
		
			//set Text Input Traits
		self.autocapitalizationType = UITextAutocapitalizationTypeSentences;
		self.autocorrectionType = UITextAutocorrectionTypeYes;
		self.enablesReturnKeyAutomatically = NO;
		self.spellCheckingType = UITextSpellCheckingTypeYes;
		
		[tapper release];
		
	}
	NSLog(@"Input view init");
	return self;
}

-(void)addSubview:(UIView *)view{
	[super addSubview:view];
	[self.textView setNeedsDisplay];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)dealloc{
	[_tokenizer release];
	[_text release];
	[_textView release];
	[markedTextStyle release];
	[super dealloc];
}

-(BOOL)canBecomeFirstResponder{
	NSLog(@"Frame1 y %f h %f", self.frame.origin.y, self.frame.size.height);

	return YES;
}

	// UIGestureRecognizerDelegate method - called to determine if we want to handle
	// a given gesture
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gesture shouldReceiveTouch:(UITouch *)touch
{
		// If gesture touch occurs in our view, we want to handle it
	if (gesture == [UIPanGestureRecognizer class]) {
		return NO;
	}
	return YES;
}


#pragma mark - UIKeyInputProtocol methods

-(void)insertText:(NSString *)text{
	NSRange sel = self.textView.selectedTextRange;
	NSRange mark = self.textView.markedTextRange;
		//CTFontRef ctFont = CTFontCreateWithName((CFStringRef)_textView.font.fontName, _textView.font.pointSize, NULL);
		//NSDictionary *att = [NSDictionary dictionaryWithObject:(id)ctFont forKey:(NSString *)kCTFontAttributeName];
	NSLog(@"made it to insert");
	
	if (!_text) {
		_text = [[NSMutableAttributedString alloc]initWithString:text attributes:self.attributes];
		sel.location += text.length;
	}else if (mark.location != NSNotFound) {
			// There is marked text -- replace marked text with user-entered text
        [_text replaceCharactersInRange:mark withString:text];
        sel.location = mark.location + text.length;
        sel.length = 0;
        mark = NSMakeRange(NSNotFound, 0);
        NSLog(@"found range marked");
    } else if (sel.length > 0) {
			// Replace selected text with user-entered text
        [_text replaceCharactersInRange:sel withString:text];
        sel.length = 0;
        sel.location += text.length;
		NSLog(@"found range");
    } else {
			// Insert user-entered text at current insertion point
		NSAttributedString *newAttString = [[NSAttributedString alloc]initWithString:text attributes:self.attributes];
        
		[_text insertAttributedString:newAttString atIndex:sel.location];     
		[newAttString release];
        sel.location += text.length;
    }
	NSLog(@"image count IV %d", [self.currentDocument.images count]);
	
	self.textView.text = _text;
	self.textView.selectedTextRange = sel;
	self.textView.markedTextRange = mark;
	
		//NSLog(@"%@", _text);
}
-(void)deleteBackward{
	NSRange sel = self.textView.selectedTextRange;
	NSRange mark = self.textView.markedTextRange;
	
	if (mark.location != NSNotFound) {
			// There is marked text, so delete it
		NSLog(@"found marked");
        [_text deleteCharactersInRange:mark];
        sel.location = mark.location;
        sel.length = 0;
        mark = NSMakeRange(NSNotFound, 0);
		
    } else if (sel.length > 0) {
			// Delete the selected text
		
        [_text deleteCharactersInRange:sel];
        sel.length = 0;
    } else if (sel.location > 0) {
			// Delete one char of text at the current insertion point
        sel.location--;
        sel.length = 1;
        [_text deleteCharactersInRange:sel];
        sel.length = 0;
    }

	
	
	self.textView.text = _text;
	self.textView.selectedTextRange = sel;
	self.textView.markedTextRange = mark;
	
	NSLog(@"%@", _text);
}

-(BOOL)hasText{
	return (_textView.text.length > 0);
}

#pragma mark - UITextInputProtocol

	// UITextInput required method - called by text system to get the string for
	// a given range in the text storage
- (NSString *)textInRange:(UITextRange *)range
{
    TWTextRange *r = (TWTextRange *)range;
	NSLog(@"in here %d %d", r.range.location, r.range.length);
    return ([[_text mutableString] substringWithRange:r.range]);
}

	// UITextInput required method - called by text system to replace the given
	// text storage range with new text
- (void)replaceRange:(UITextRange *)range withText:(NSString *)text
{
	
	NSLog(@"text = %@", text);
    TWTextRange *r = (TWTextRange *)range;
		// Determine if replaced range intersects current selection range
		// and update selection range if so.
    NSRange selectedNSRange = _textView.selectedTextRange;
    if ((r.range.location + r.range.length) <= selectedNSRange.location) {
			// This is the easy case.  
        selectedNSRange.location -= (r.range.length - text.length);
    } else {
			// Need to also deal with overlapping ranges.  Not addressed
			// in this simplified sample.
    }
	NSLog(@"range loc %d len %d", r.range.location, r.range.length);
		// Now replace characters in text storage
    [_text replaceCharactersInRange:r.range withString:text];    
	
		// Update underlying SimpleCoreTextView
    _textView.text = _text;
    _textView.selectedTextRange = selectedNSRange;
	
}

	// UITextInput required method - Inserts the provided text and marks it to indicate 
	// that it is part of an active input session. 
- (void)setMarkedText:(NSString *)markedText selectedRange:(NSRange)selectedRange
{
    NSRange selectedNSRange = _textView.selectedTextRange;
    NSRange markedTextRange = _textView.markedTextRange;
    
    if (markedTextRange.location != NSNotFound) {
        if (!markedText)
            markedText = @"";
			// Replace characters in text storage and update markedText range length
        [_text replaceCharactersInRange:markedTextRange withString:markedText];
        markedTextRange.length = markedText.length;
    } else if (selectedNSRange.length > 0) {
			// There currently isn't a marked text range, but there is a selected range,
			// so replace text storage at selected range and update markedTextRange.
        [_text replaceCharactersInRange:selectedNSRange withString:markedText];
        markedTextRange.location = selectedNSRange.location;
        markedTextRange.length = markedText.length;
    } else {
			// There currently isn't marked or selected text ranges, so just insert
			// given text into storage and update markedTextRange.
		NSAttributedString *newAttString = [[NSAttributedString alloc]initWithString:markedText attributes:self.attributes];
		
		[_text insertAttributedString:newAttString atIndex:selectedNSRange.location-1];        
        markedTextRange.location = selectedNSRange.location;
        markedTextRange.length = markedText.length;
    }
    
		// Updated selected text range and underlying SimpleCoreTextView
	
    selectedNSRange = NSMakeRange(selectedRange.location + markedTextRange.location, selectedRange.length);
    
    _textView.text = _text;
    _textView.markedTextRange = markedTextRange;
    _textView.selectedTextRange = selectedNSRange;   
    
}

	// UITextInput required method - Unmark the currently marked text.
- (void)unmarkText
{
    NSRange markedTextRange = _textView.markedTextRange;
    
    if (markedTextRange.location == NSNotFound)
        return;
	
		// unmark the underlying SimpleCoreTextView.markedTextRange
    markedTextRange.location = NSNotFound;
    _textView.markedTextRange = markedTextRange;
    NSLog(@"something");
}

#pragma mark UITextInput - Computing Text Ranges and Text Positions

	// UITextInput protocol required method - Return the range between two text positions
	// using our implementation of UITextRange
- (UITextRange *)textRangeFromPosition:(UITextPosition *)fromPosition toPosition:(UITextPosition *)toPosition
{
		// Generate TWTextPosition instances that wrap the to and from ranges
    TWTextPosition *from = (TWTextPosition *)fromPosition;
    TWTextPosition *to = (TWTextPosition *)toPosition;    
    NSRange range = NSMakeRange(MIN(from.index, to.index), ABS(to.index - from.index));
    return [TWTextRange rangeWithNSRange:range];    
    
}

	// UITextInput protocol required method - Returns the text position at a given offset 
	// from another text position using our implementation of UITextPosition
- (UITextPosition *)positionFromPosition:(UITextPosition *)position offset:(NSInteger)offset
{
		// Generate TWTextPosition instance, and increment index by offset
    TWTextPosition *pos = (TWTextPosition *)position;    
    NSInteger end = pos.index + offset;
		// Verify position is valid in document
    if (end > _text.length || end < 0)
        return nil;
	
    
    return [TWTextPosition positionWithIndex:end];
}

	// UITextInput protocol required method - Returns the text position at a given offset 
	// in a specified direction from another text position using our implementation of
	// UITextPosition.
- (UITextPosition *)positionFromPosition:(UITextPosition *)position inDirection:(UITextLayoutDirection)direction offset:(NSInteger)offset
{
		// Note that this sample assumes LTR text direction
    TWTextPosition *pos = (TWTextPosition *)position;
    NSInteger newPos = pos.index;
    
    switch (direction) {
        case UITextLayoutDirectionRight:
            newPos += offset;
            break;
        case UITextLayoutDirectionLeft:
            newPos -= offset;
            break;
        UITextLayoutDirectionUp:
        UITextLayoutDirectionDown:
				// This sample does not support vertical text directions
            break;
    }
	
		// Verify new position valid in document
	
    if (newPos < 0)
        newPos = 0;
    
    if (newPos > _text.length)
        newPos = _text.length;
    
    return [TWTextPosition positionWithIndex:newPos];
}


#pragma mark UITextInput - Evaluating Text Positions

	// UITextInput protocol required method - Return how one text position compares to another 
	// text position.  
- (NSComparisonResult)comparePosition:(UITextPosition *)position toPosition:(UITextPosition *)other
{
    TWTextPosition *pos = (TWTextPosition *)position;
    TWTextPosition *o = (TWTextPosition *)other;
    
		// For this sample, we simply compare position index values
    if (pos.index == o.index) {
        return NSOrderedSame;
    } if (pos.index < o.index) {
        return NSOrderedAscending;
    } else {
        return NSOrderedDescending;
    }
}

	// UITextInput protocol required method - Return the number of visible characters 
	// between one text position and another text position.
- (NSInteger)offsetFromPosition:(UITextPosition *)from toPosition:(UITextPosition *)toPosition
{
    TWTextPosition *f = (TWTextPosition *)from;
    TWTextPosition *t = (TWTextPosition *)toPosition;
    return (t.index - f.index);
}

#pragma mark UITextInput - Text Layout, writing direction and position related methods

	// UITextInput protocol method - Return the text position that is at the farthest 
	// extent in a given layout direction within a range of text.
- (UITextPosition *)positionWithinRange:(UITextRange *)range farthestInDirection:(UITextLayoutDirection)direction
{
		// Note that this sample assumes LTR text direction
    TWTextRange	*r = (TWTextRange *)range;
    NSInteger pos = r.range.location;
	
		// For this sample, we just return the extent of the given range if the
		// given direction is "forward" in a LTR context (UITextLayoutDirectionRight
		// or UITextLayoutDirectionDown), otherwise we return just the range position
    switch (direction) {
        case UITextLayoutDirectionUp:
        case UITextLayoutDirectionLeft:
            pos = r.range.location;
            break;
        case UITextLayoutDirectionRight:
        case UITextLayoutDirectionDown:            
            pos = r.range.location + r.range.length;
            break;
    }
    
		// Return text position using our UITextPosition implementation.
		// Note that position is not currently checked against document range.
    return [TWTextPosition positionWithIndex:pos];        
}

	// UITextInput protocol required method - Return a text range from a given text position 
	// to its farthest extent in a certain direction of layout.
- (UITextRange *)characterRangeByExtendingPosition:(UITextPosition *)position inDirection:(UITextLayoutDirection)direction
{
		// Note that this sample assumes LTR text direction
    TWTextPosition *pos = (TWTextPosition *)position;
    NSRange result = NSMakeRange(pos.index, 1);
    
    switch (direction) {
        case UITextLayoutDirectionUp:
        case UITextLayoutDirectionLeft:
            result = NSMakeRange(pos.index - 1, 1);
            break;
        case UITextLayoutDirectionRight:
        case UITextLayoutDirectionDown:            
            result = NSMakeRange(pos.index, 1);
            break;
    }
    
		// Return range using our UITextRange implementation
		// Note that range is not currently checked against document range.
    return [TWTextRange rangeWithNSRange:result];   
}

-(UITextWritingDirection)baseWritingDirectionForPosition:(UITextPosition *)position inDirection:(UITextStorageDirection)direction{
	return UITextWritingDirectionLeftToRight;
}

	// UITextInput protocol required method - Set the base writing direction for a 
	// given range of text in a document.
- (void)setBaseWritingDirection:(UITextWritingDirection)writingDirection forRange:(UITextRange *)range
{
		// This sample assumes LTR text direction and does not currently support BiDi or RTL.
}

#pragma mark UITextInput - Geometry methods

	// UITextInput protocol required method - Return the first rectangle that encloses 
	// a range of text in a document.
- (CGRect)firstRectForRange:(UITextRange *)range
{
    TWTextRange	*r = (TWTextRange *)range;    
		// Use underlying SimpleCoreTextView to get rect for range
    CGRect rect = [_textView firstRectForNSRange:r.range];
		// Convert rect to our view coordinates
    return [self convertRect:rect fromView:_textView];    
}

	// UITextInput protocol required method - Return a rectangle used to draw the caret
	// at a given insertion point.
- (CGRect)caretRectForPosition:(UITextPosition *)position
{
    TWTextPosition *pos = (TWTextPosition *)position;
	
		// Get caret rect from underlying SimpleCoreTextView
    CGRect rect =  [_textView caretRectForIndex:pos.index];   
		// Convert rect to our view coordinates
    return [self convertRect:rect fromView:_textView];    
}

#pragma mark UITextInput - Hit testing

	// Note that for this sample hit testing methods are not implemented, as there
	// is no implemented mechanic for letting user select text via touches.  There
	// is a wide variety of approaches for this (gestures, drag rects, etc) and
	// any approach chosen will depend greatly on the design of the application.

	// UITextInput protocol required method - Return the position in a document that 
	// is closest to a specified point. 
- (UITextPosition *)closestPositionToPoint:(CGPoint)point
{
		// Not implemented in this sample.  Could utilize underlying 
		// SimpleCoreTextView:closestIndexToPoint:point
    return nil;
}

	// UITextInput protocol required method - Return the position in a document that 
	// is closest to a specified point in a given range.
- (UITextPosition *)closestPositionToPoint:(CGPoint)point withinRange:(UITextRange *)range
{
		// Not implemented in this sample.  Could utilize underlying 
		// SimpleCoreTextView:closestIndexToPoint:point
    return nil;
}

	// UITextInput protocol required method - Return the character or range of 
	// characters that is at a given point in a document.
- (UITextRange *)characterRangeAtPoint:(CGPoint)point
{
		// Not implemented in this sample.  Could utilize underlying 
		// SimpleCoreTextView:closestIndexToPoint:point
    return nil;
}

#pragma mark UITextInput - Returning Text Styling Information

	// UITextInput protocol method - Return a dictionary with properties that specify 
	// how text is to be style at a certain location in a document.
- (NSDictionary *)textStylingAtPosition:(UITextPosition *)position inDirection:(UITextStorageDirection)direction
{
		// This sample assumes all text is single-styled, so this is easy.
    return [NSDictionary dictionaryWithObject:_textView.font forKey:UITextInputTextFontKey];
	
}

#pragma mark - Getter and setter overrides for UITextInputProtocol

-(UITextRange *)selectedTextRange{
	return [TWTextRange rangeWithNSRange:self.textView.selectedTextRange];
}
-(void)setSelectedTextRange:(UITextRange *)selectedTextRange{
	TWTextRange *r = (TWTextRange *)selectedTextRange;
	self.textView.selectedTextRange = r.range;
}

-(UITextRange *)markedTextRange{
	return [TWTextRange rangeWithNSRange:self.textView.markedTextRange];
}

-(UITextPosition *)beginningOfDocument {
	return [TWTextPosition positionWithIndex:0];
}

-(UITextPosition *)endOfDocument {
	return [TWTextPosition positionWithIndex:self.textView.text.length];
}

-(id<UITextInputTokenizer>)tokenizer{
	return _tokenizer;
}


-(void)tap{
	if (![self isFirstResponder]) {
		[self becomeFirstResponder];
	}
}


#pragma mark - Text Formatting

-(void)startBold{
	
	
}
-(void)endBold{
	
}
@end
