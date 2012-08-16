//
//  Document.m
//  Notes_attempt2
//
//  Created by Thomas Wilson on 15/08/2012.
//  Copyright (c) 2012 aberystwyth university. All rights reserved.
//

#import "Document.h"

@implementation Document
@synthesize images = _images;

-(id)init{
	self = [super init];
	if (self) {
		_images = [[NSMutableArray alloc]init];
	}
	
	
	return self;
}


-(void)dealloc{
	[super dealloc];
	[_images release];
}
@end
