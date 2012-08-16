//
//  Text.h
//  Notes_attempt2
//
//  Created by Matias Seibert on 8/16/12.
//  Copyright (c) 2012 aberystwyth university. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Note;

@interface Text : NSManagedObject

@property (nonatomic, retain) NSNumber * page;
@property (nonatomic, retain) NSNumber * paragraph;
@property (nonatomic, retain) NSAttributedString * string;
@property (nonatomic, retain) Note *note;

@end
