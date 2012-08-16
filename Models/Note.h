//
//  Note.h
//  Notes_attempt2
//
//  Created by Matias Seibert on 8/15/12.
//  Copyright (c) 2012 aberystwyth university. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Text;

@interface Note : NSManagedObject

@property (nonatomic, retain) id images;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSSet *text;
@end

@interface Note (CoreDataGeneratedAccessors)

- (void)addTextObject:(Text *)value;
- (void)removeTextObject:(Text *)value;
- (void)addText:(NSSet *)values;
- (void)removeText:(NSSet *)values;

@end
