//
//  userProfile.m
//  Petstagram
//
//  Created by Haris Jawaid on 4/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "userProfile.h"


@implementation userProfile

@synthesize  userName;
@synthesize  iden;
@synthesize  imgURL;
@synthesize accessToken;
@synthesize fullName;
@synthesize petArray;
@synthesize badges,followers,follows,photos;
@synthesize photoArray;
@synthesize photoFeed;
@synthesize relationShip;
@synthesize obj;
@synthesize email,password;
@synthesize likeAPN,commentAPN,followsAPN,shareFB,autoRegisterLocation,supportAPN;
@synthesize supporter,comments,post;
-(id)copyWithZone:(NSZone *)zone
{
    // We'll ignore the zone for now
    userProfile *another = [[userProfile alloc] init];
     another.userName = [userName copyWithZone: zone];
     another.fullName = [fullName copyWithZone: zone];
     another.petArray = [petArray copyWithZone: zone];
     another.iden = [iden copyWithZone: zone];
     another.imgURL = [imgURL copyWithZone: zone];
     another.accessToken = [accessToken copyWithZone: zone];
     another.petArray = [petArray copyWithZone: zone];
   
     another.badges = [badges copyWithZone: zone];
     another.followers = [followers copyWithZone: zone];
     another.follows = [follows copyWithZone: zone];
     another.photos = [photos copyWithZone: zone];
     another.relationShip = [relationShip copyWithZone: zone];
     another.email = [email copyWithZone: zone];
     another.password = [password copyWithZone: zone];
    
    
    return another;
}


@end