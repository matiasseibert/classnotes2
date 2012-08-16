//
//  TWTextPosition.h
//  Notes - Attempt 2
//
//  Created by Thomas Wilson on 22/06/2012.
//  Copyright (c) 2012 aberystwyth university. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TWTextPosition : UITextPosition
@property (nonatomic)NSUInteger index;
@property (nonatomic, assign)id<UITextInputDelegate> inputDelegate;

+(TWTextPosition *)positionWithIndex:(NSUInteger)index;
@end
