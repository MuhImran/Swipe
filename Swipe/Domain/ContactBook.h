//
//  ContactBook.h
//  Swipe
//
//  Created by imran on 7/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class EmailList, PhoneList, SocialData;

@interface ContactBook : NSManagedObject

@property (nonatomic, retain) NSString * companyName;
@property (nonatomic, retain) NSNumber * contactId;
@property (nonatomic, retain) NSString * dept;
@property (nonatomic, retain) NSDate * dob;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * jobTitle;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * phoneNo;
@property (nonatomic, retain) NSString * imgURL;
@property (nonatomic, retain) NSData * imageData;
@property (nonatomic, retain) NSSet *phones;
@property (nonatomic, retain) NSSet *userEmails;
@property (nonatomic, retain) SocialData *userSocial;
@end

@interface ContactBook (CoreDataGeneratedAccessors)

- (void)addPhonesObject:(PhoneList *)value;
- (void)removePhonesObject:(PhoneList *)value;
- (void)addPhones:(NSSet *)values;
- (void)removePhones:(NSSet *)values;
- (void)addUserEmailsObject:(EmailList *)value;
- (void)removeUserEmailsObject:(EmailList *)value;
- (void)addUserEmails:(NSSet *)values;
- (void)removeUserEmails:(NSSet *)values;
@end
