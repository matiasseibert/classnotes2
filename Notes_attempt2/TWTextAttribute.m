//
//  TWTextAttribute.m
//  Notes_attempt2
//
//  Created by Thomas Wilson on 25/06/2012.
//  Copyright (c) 2012 aberystwyth university. All rights reserved.
//

#import "TWTextAttribute.h"

@implementation TWTextAttribute

@synthesize attributeKey = _attributeKey;
@synthesize start = _start;
@synthesize length = _length;
@synthesize attribute = _attribute;

-(id)init{
	
	
	return [self initWithStartingPosition:NSNotFound];
}

-(id)initWithStartingPosition:(NSInteger)start{
	self = [super init];
	if (self) {
		self.start = NSNotFound;
		self.length = 0;
		_attributeKey = [[NSString alloc]init];
	}
	return self;
}

-(void)dealloc{
	[_attributeKey release];
	self.attributeKey = nil;
	[super dealloc];
}
@end
