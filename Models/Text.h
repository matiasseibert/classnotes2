//
//  Text.h
//  Notes_attempt2
//
//  Created by Matias Seibert on 8/15/12.
//  Copyright (c) 2012 aberystwyth university. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Text : NSManagedObject

@property (nonatomic, retain) NSNumber * page;
@property (nonatomic, retain) NSNumber * paragraph;
@property (nonatomic, retain) id string;
@property (nonatomic, retain) NSManagedObject *note;

@end
