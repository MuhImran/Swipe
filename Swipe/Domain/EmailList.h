//
//  EmailList.h
//  Swipe
//
//  Created by imran on 7/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface EmailList : NSManagedObject

@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSNumber * emailId;
@property (nonatomic, retain) NSString * emailTitle;

@end
