//
//  likeData.h
//  Petstagram
//
//  Created by Haris Jawaid on 4/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "userProfile.h"
@interface likeData : NSObject {
   
   
     userProfile        *user;
     NSNumber           *count;
    
}
@property (nonatomic,retain)  userProfile     *user;
@property (nonatomic,retain)  NSNumber *count;

@end