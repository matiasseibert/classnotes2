//
//  TWInputView.h
//  Notes - Attempt 2
//
//  Created by Thomas Wilson on 21/06/2012.
//  Copyright (c) 2012 aberystwyth university. All rights reserved.
//
//@class TWAttributedStringBuilder;

#import <UIKit/UIKit.h>
#import "TWTextRange.h"
#import "TWTextPosition.h"
#import "TWTextView.h"
#import "Document.h"



@interface TWInputView : UIView <UITextInput, UITextInputTraits>

@property (nonatomic, strong)TWTextView *textView;
@property (nonatomic, strong)NSMutableDictionary *attributes;
@property (nonatomic, strong)Document *currentDocument;

	//Text Input stuff
@property (nonatomic, copy)NSMutableAttributedString *text;
@property (nonatomic, weak)id<UITextInputDelegate> inputDelegate;
@property (nonatomic, readonly) id<UITextInputTokenizer> tokenizer;
@property (nonatomic) UITextStorageDirection sectionAffinity;
@property (weak, nonatomic, readonly)TWTextPosition *beginningOfDocument;
@property (weak, nonatomic, readonly)TWTextPosition *endOfDocument;
@property (readwrite, copy)TWTextRange *selectedTextRange;
@property (weak, nonatomic, readonly)TWTextRange *markedTextRange;

	//text input traits - Protocol

@property (nonatomic) UITextAutocapitalizationType autocapitalizationType;
@property (nonatomic) UITextAutocorrectionType autocorrectionType;
@property (nonatomic) BOOL enablesReturnKeyAutomatically;
@property (nonatomic) UIKeyboardAppearance keyboardAppearance;
@property (nonatomic) UIKeyboardType keyboardType;
@property (nonatomic) UIReturnKeyType returnKeyType;
@property (nonatomic, getter =isSecureTextEntry) BOOL secureTextEntry;
@property (nonatomic) UITextSpellCheckingType spellCheckingType;

-(void)tap;

-(void)startBold;
-(void)endBold;


@end
