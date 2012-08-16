//
//  TWTextPosition.m
//  Notes - Attempt 2
//
//  Created by Thomas Wilson on 22/06/2012.
//  Copyright (c) 2012 aberystwyth university. All rights reserved.
//

#import "TWTextPosition.h"

@implementation TWTextPosition

@synthesize index = _index;
@synthesize inputDelegate = _inputDelegate;


+(TWTextPosition *)positionWithIndex:(NSUInteger)index{
	TWTextPosition *pos = [[TWTextPosition alloc]init];
	pos.index = index;
	return pos;
}

@end
