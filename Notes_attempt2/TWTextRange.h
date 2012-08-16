//
//  TWTextRange.h
//  Notes - Attempt 2
//
//  Created by Thomas Wilson on 22/06/2012.
//  Copyright (c) 2012 aberystwyth university. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TWTextPosition.h"
@interface TWTextRange : UITextRange

@property (nonatomic) NSRange range;

+(TWTextRange *) rangeWithNSRange:(NSRange)range;

@end
