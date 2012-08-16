//
//  TWAttributeBuilder.h
//  Notes_attempt2
//
//  Created by Thomas Wilson on 25/06/2012.
//  Copyright (c) 2012 aberystwyth university. All rights reserved.
//
@class TWInputView;

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
#import "TWInputView.h"
#import "TWTextAttribute.h"

@interface TWAttributedStringBuilder : NSObject

@property (nonatomic, retain)TWInputView *textInput;
@property (nonatomic, retain)NSMutableAttributedString *attributedString;
@property (nonatomic, retain)NSMutableArray *attributes;



-(id)init;
-(id)initWithTextInput:(TWInputView *)input;

-(void)startBoldAtIndex:(NSInteger)index;
-(void)endBoldAtIndex:(NSInteger)index;
-(NSMutableAttributedString *)getAttributedString;

@end
