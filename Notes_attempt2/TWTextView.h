//
//  TWTextView.h
//  Notes - Attempt 2
//
//  Created by Thomas Wilson on 22/06/2012.
//  Copyright (c) 2012 aberystwyth university. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
	//#import "TWAttributedStringBuilder.h"



@interface TWTextView : UIView

@property (nonatomic, readwrite)NSRange selectedTextRange;
@property (nonatomic, readwrite)NSRange markedTextRange;
	//@property (nonatomic, retain)NSMutableAttributedString *attText;
@property (nonatomic, strong)NSMutableAttributedString *text;
@property (nonatomic, strong)UIFont *font;
@property (nonatomic, strong)NSMutableDictionary *attributes;

@property (nonatomic)CTFrameRef frameRef;
@property (nonatomic)CTFramesetterRef frameSetter;

@property (nonatomic)BOOL editing;
@property (nonatomic, strong)NSMutableArray *images;

-(void)textChanged;

- (CGRect)caretRectForIndex:(int)index;
- (CGRect)firstRectForNSRange:(NSRange)range;
- (NSInteger)closestIndexToPoint:(CGPoint)point;

@end
