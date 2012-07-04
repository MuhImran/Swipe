//
//  PhoneList.h
//  Swipe
//
//  Created by imran on 6/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PhoneList : NSManagedObject

@property (nonatomic, retain) NSString * phoneNo;
@property (nonatomic, retain) NSString * phoneTitle;
@property (nonatomic, retain) NSNumber * phoneId;

@end
