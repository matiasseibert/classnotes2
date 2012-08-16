//
//  Image.h
//  Notes_attempt2
//
//  Created by Matias Seibert on 8/16/12.
//  Copyright (c) 2012 aberystwyth university. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Note;

@interface Image : NSManagedObject

@property (nonatomic, retain) id position;
@property (nonatomic, retain) UIImage * imageData;
@property (nonatomic, retain) NSNumber * onPage;
@property (nonatomic, retain) Note *note;

@end
