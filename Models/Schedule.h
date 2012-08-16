//
//  Schedule.h
//  Notes_attempt2
//
//  Created by Matias Seibert on 8/15/12.
//  Copyright (c) 2012 aberystwyth university. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Class;

@interface Schedule : NSManagedObject

@property (nonatomic, retain) NSSet *classes;
@end

@interface Schedule (CoreDataGeneratedAccessors)

- (void)addClassesObject:(Class *)value;
- (void)removeClassesObject:(Class *)value;
- (void)addClasses:(NSSet *)values;
- (void)removeClasses:(NSSet *)values;

@end
