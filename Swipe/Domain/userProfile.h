//
//  userProfile.h
//  Petstagram
//
//  Created by Haris Jawaid on 4/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FeedData.h"
@interface userProfile : NSObject<NSCopying> {
  
    
    NSString                *userName;
    NSString                *fullName;
	NSNumber                *iden;
    NSString                *imgURL;
    NSString                *accessToken;
    NSNumber                *badges,*followers,*follows,*photos;
    NSMutableArray          *petArray;
	NSMutableDictionary		*relationShip;
	NSMutableArray          *photoArray;
    FeedData                *photoFeed;
    userProfile             *obj;
    NSString                *email,*password;
    BOOL                     likeAPN,commentAPN,followsAPN,shareFB,autoRegisterLocation,supportAPN;
    int                     supporter,comments,post;
    
}
@property int                     supporter,comments,post;
@property (nonatomic,retain) FeedData      *photoFeed;
@property (nonatomic,retain) NSMutableArray  *photoArray;
@property (nonatomic,retain) NSMutableDictionary *relationShip;
@property (nonatomic,retain) NSString *userName;
@property (nonatomic,retain) NSNumber *iden;
@property (nonatomic,retain) NSString *imgURL;
@property (nonatomic,retain) NSString *accessToken;
@property (nonatomic,retain) NSString *fullName;
@property (nonatomic,retain) NSMutableArray  *petArray;
@property (nonatomic,retain) NSNumber *badges,*followers,*follows,*photos;
@property (nonatomic,retain) userProfile  *obj;
@property (nonatomic,retain) NSString *email,*password;
@property BOOL likeAPN,commentAPN,followsAPN,shareFB,autoRegisterLocation,supportAPN;
@end
