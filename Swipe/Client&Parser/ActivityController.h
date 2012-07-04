//
//  ActivityController.h
//  Petstagram
//
//  Created by Awais Ahmad Qureshi on 4/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResolutionInfo.h"
#import "userProfile.h"


@interface ActivityController : NSObject {
	
	NSNumber                *blocksize,*offset;
    NSMutableArray          *activityArray;

}


@property (nonatomic,retain) NSNumber        *blocksize,*offset;
@property (nonatomic,retain)  NSMutableArray  *activityArray;
@end
