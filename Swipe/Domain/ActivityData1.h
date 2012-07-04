//
//  ActivityData1.h
//  Petstagram
//
//  Created by Awais Ahmad Qureshi on 6/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResolutionInfo.h"
#import "userProfile.h"
@interface ActivityData1 : NSObject {
    
    NSNumber        *iden,*photoId;
    NSString        *textString,*typeString;
    ResolutionInfo  *thumbnail;
    userProfile     *user;
}

@property (nonatomic,retain) NSNumber  *iden,*photoId;
@property (nonatomic,retain) NSString  *textString,*typeString;
@property (nonatomic,retain) ResolutionInfo *thumbnail;
@property (nonatomic,retain) userProfile     *user;

@end
