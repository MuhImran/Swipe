//
//  User.h
//  Swipe
//
//  Created by imran on 6/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ContactBook;

@interface User : NSManagedObject

@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSNumber * isLinked;
@property (nonatomic, retain) NSNumber * rememerMe;
@property (nonatomic, retain) NSString * timezone;
@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) NSDate * lastSyncAt;
@property (nonatomic, retain) NSString * token;
@property (nonatomic, retain) NSSet *hasContacts;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addHasContactsObject:(ContactBook *)value;
- (void)removeHasContactsObject:(ContactBook *)value;
- (void)addHasContacts:(NSSet *)values;
- (void)removeHasContacts:(NSSet *)values;
@end
