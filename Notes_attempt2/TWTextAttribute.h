//
//  TWTextAttribute.h
//  Notes_attempt2
//
//  Created by Thomas Wilson on 25/06/2012.
//  Copyright (c) 2012 aberystwyth university. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TWTextAttribute : NSObject

@property (nonatomic, copy) NSString *attributeKey;
@property (nonatomic, assign)id attribute;
@property (nonatomic)NSInteger start;
@property (nonatomic)NSInteger length;

-(id)initWithStartingPosition:(NSInteger)start;

@end
