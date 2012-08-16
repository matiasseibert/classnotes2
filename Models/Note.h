//
//  Note.h
//  Notes_attempt2
//
//  Created by Matias Seibert on 8/16/12.
//  Copyright (c) 2012 aberystwyth university. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Note : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSSet *text;
@property (nonatomic, retain) NSSet *images;
@end

@interface Note (CoreDataGeneratedAccessors)

- (void)addTextObject:(NSManagedObject *)value;
- (void)removeTextObject:(NSManagedObject *)value;
- (void)addText:(NSSet *)values;
- (void)removeText:(NSSet *)values;

- (void)addImagesObject:(NSManagedObject *)value;
- (void)removeImagesObject:(NSManagedObject *)value;
- (void)addImages:(NSSet *)values;
- (void)removeImages:(NSSet *)values;

@end
