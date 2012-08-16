//
//  TWTextView.m
//  Notes - Attempt 2
//
//  Created by Thomas Wilson on 22/06/2012.
//  Copyright (c) 2012 aberystwyth university. All rights reserved.
//

#import "TWTextView.h"
#import <QuartzCore/QuartzCore.h>
#import "TWAttributedStringBuilder.h"

@implementation TWTextView
@synthesize selectedTextRange;
@synthesize markedTextRange;
@synthesize text = _text;
@synthesize attributes = _attributes;
@synthesize font = _font;

@synthesize frameRef = _frameRef;
@synthesize frameSetter = _frameSetter;

@synthesize editing = _editing;
@synthesize images = _images;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		//self.text = [NSMutableString stringWithString:@""];
		self.font = [UIFont systemFontOfSize:18];
		self.backgroundColor = [UIColor whiteColor];
		self.layer.geometryFlipped = YES;
		
		selectedTextRange = NSMakeRange(0, 0);
		markedTextRange = NSMakeRange(NSNotFound, 0);
			//_images = [[NSMutableArray alloc]init];
		
		
		self.userInteractionEnabled = NO;
		
    }
	NSLog(@"init text view");
    return self;
}

- (void)clearPreviousLayoutInformation
{
    if (_frameSetter != NULL) {
        CFRelease(_frameSetter);
        _frameSetter = NULL;
    }
    
    if (_frameRef != NULL) {
		CFRelease(_frameRef);
        _frameRef = NULL;
    }
	
}

-(void)textChanged{
	[self setNeedsDisplay];
	[self clearPreviousLayoutInformation];
	
}

-(void)setText:(NSMutableAttributedString *)text{
	NSMutableAttributedString *oldstring = _text;
	_text = [text retain];
	[oldstring release];
	[self textChanged];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
	/*CTFontRef ctFont = CTFontCreateWithName((CFStringRef)self.font.fontName, self.font.pointSize, NULL);
	
	NSDictionary *attribute = [NSDictionary dictionaryWithObject:(id)ctFont forKey:(NSString *)kCTFontAttributeName];*/
	
	
	NSLog(@"at:%@", [_text mutableString]);
	
	
	_frameSetter = CTFramesetterCreateWithAttributedString((CFMutableAttributedStringRef)_text);
	
	UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.bounds];
	NSLog(@"images count %d", [self.images count]);
	for (UIImageView *image in self.images) {
		NSLog(@"in image loop");
		CGRect newframe = [self convertRect:image.frame toView: self.superview];
		[path appendPath:[UIBezierPath bezierPathWithRect:newframe]];
	}
	
	[path stroke];
	
	
	
	_frameRef = CTFramesetterCreateFrame(_frameSetter, CFRangeMake(0, 0), [path CGPath], NULL);
	
	CTFrameDraw(_frameRef, UIGraphicsGetCurrentContext());
}


	// Public method to find the text range index for a given CGPoint
- (NSInteger)closestIndexToPoint:(CGPoint)point
{	
		// Use Core Text to find the text index for a given CGPoint by
		// iterating over the y-origin points for each line, finding the closest
		// line, and finding the closest index within that line.
    NSArray *lines = (NSArray *) CTFrameGetLines(_frameRef);
    CGPoint origins[lines.count];
    CTFrameGetLineOrigins(_frameRef, CFRangeMake(0, lines.count), origins);
    
    for (int i = 0; i < lines.count; i++) {
        if (point.y > origins[i].y) {
				// This line origin is closest to the y-coordinate of our point,
				// now look for the closest string index in this line.
            CTLineRef line = (CTLineRef) [lines objectAtIndex:i];
            return CTLineGetStringIndexForPosition(line, point);
			
        }
    }
    
    return  _text.length;
	
}

	// Public method to determine the CGRect for the insertion point or selection, used
	// when creating or updating our SimpleCaretView instance
- (CGRect)caretRectForIndex:(int)index
{    	
    NSArray *lines = (NSArray *) CTFrameGetLines(_frameRef);
    
		// Special case, no text
    if (_text.length == 0) {
        CGPoint origin = CGPointMake(CGRectGetMinX(self.bounds), CGRectGetMaxY(self.bounds) - self.font.leading);
			// Note: using fabs() for typically negative descender from fonts
        return CGRectMake(origin.x, origin.y - fabs(self.font.descender), 3, self.font.ascender + fabs(self.font.descender));
    }    
    
		// Special case, insertion point at final position in text after newline
    if (index == _text.length && [[_text mutableString]characterAtIndex:(index - 1)] == '\n') {
        CTLineRef line = (CTLineRef) [lines lastObject];
        CFRange range = CTLineGetStringRange(line);
        CGFloat xPos = CTLineGetOffsetForStringIndex(line, range.location, NULL);
        CGPoint origin;
        CGFloat ascent, descent;
        CTLineGetTypographicBounds(line, &ascent, &descent, NULL);
        CTFrameGetLineOrigins(_frameRef, CFRangeMake(lines.count - 1, 0), &origin); 
			// Place point after last line, including any font leading spacing if applicable
        origin.y -= self.font.leading;
        return CGRectMake(xPos, origin.y - descent, 3, ascent + descent);        
    }
	
		// Regular case, caret somewhere within our text content range
    for (int i = 0; i < [lines count]; i++) {
        CTLineRef line = (CTLineRef) [lines objectAtIndex:i];
        CFRange range = CTLineGetStringRange(line);
        NSInteger localIndex = index - range.location;
        if (localIndex >= 0 && localIndex <= range.length) {
				// index is in the range for this line
            CGFloat xPos = CTLineGetOffsetForStringIndex(line, index, NULL);
            CGPoint origin;
            CGFloat ascent, descent;
            CTLineGetTypographicBounds(line, &ascent, &descent, NULL);
            CTFrameGetLineOrigins(_frameRef, CFRangeMake(i, 0), &origin);
				// Make a small "caret" rect at the index position
            return CGRectMake(xPos, origin.y - descent, 3, ascent + descent);
        }
    }
	
    return CGRectNull;
}

	// Public method to create a rect for a given range in the text contents
	// Called by our EditableTextRange to implement the required 
	// UITextInput:firstRectForRange method
- (CGRect)firstRectForNSRange:(NSRange)range;
{
    NSInteger index = range.location;
    
		// Iterate over our CTLines, looking for the line that encompasses the given range
    NSArray *lines = (NSArray *) CTFrameGetLines(_frameRef);
    for (int i = 0; i < [lines count]; i++) {
        CTLineRef line = (CTLineRef) [lines objectAtIndex:i];
        CFRange lineRange = CTLineGetStringRange(line);
        NSInteger localIndex = index - lineRange.location;
        if (localIndex >= 0 && localIndex < lineRange.length) {
				// For this sample, we use just the first line that intersects range
            NSInteger finalIndex = MIN(lineRange.location + lineRange.length, range.location + range.length);
				// Create a rect for the given range within this line
            CGFloat xStart = CTLineGetOffsetForStringIndex(line, index, NULL);
            CGFloat xEnd = CTLineGetOffsetForStringIndex(line, finalIndex, NULL);
            CGPoint origin;			
            CTFrameGetLineOrigins(_frameRef, CFRangeMake(i, 0), &origin);
            CGFloat ascent, descent;
            CTLineGetTypographicBounds(line, &ascent, &descent, NULL);
            
            return CGRectMake(xStart, origin.y - descent, xEnd - xStart, ascent + descent);
        }
    }
    
    return CGRectNull;
}


-(void)dealloc{
	[_text release];
	self.text = nil;
	[_images release];
	[super dealloc];
}

@end
