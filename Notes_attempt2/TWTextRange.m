//
//  TWTextRange.m
//  Notes - Attempt 2
//
//  Created by Thomas Wilson on 22/06/2012.
//  Copyright (c) 2012 aberystwyth university. All rights reserved.
//

#import "TWTextRange.h"


@implementation TWTextRange
@synthesize range = _range;

+(TWTextRange *)rangeWithNSRange:(NSRange)range{
	if (range.location == NSNotFound) {
		return nil;
	}
	TWTextRange *twRange = [[TWTextRange alloc]init];
	twRange.range = range;
	return twRange;
}

-(TWTextPosition *)start {
	return [TWTextPosition positionWithIndex:self.range.location];
}

-(TWTextPosition *)end {
	return [TWTextPosition positionWithIndex:(self.range.location + self.range.length)];
}

-(BOOL)isEmpty{
	return (self.range.length == 0);
}

@end
