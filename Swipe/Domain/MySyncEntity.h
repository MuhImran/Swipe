//
//  EmailAddressData.h
//  Posterboard
//
//  Created by Apptellect5 on 9/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>

@interface MySyncEntity:NSObject
{
    NSManagedObjectContext      *managedObjectContext;
}
@property (nonatomic, retain) NSArray* AddressBookArray;
+(MySyncEntity *) getLocalAddressBook;
- (NSArray*)printAddressBook;
@end 