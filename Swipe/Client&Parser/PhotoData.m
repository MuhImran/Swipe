//
//  PhotoData.m
//  Petstagram
//
//  Created by Haris Jawaid on 4/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PhotoData.h"


@implementation PhotoData

@synthesize  title,desc;
@synthesize commentArray;
@synthesize count;
@synthesize createdDate;
@synthesize supporters;
@synthesize iden;
@synthesize supporterArray;
@synthesize user;
@synthesize lowResolution,standResolution;
@synthesize thumbnail;
@synthesize location;
@synthesize tag;
@synthesize hasComment,hasLike;
@synthesize postPageUrl;


- (CLLocationCoordinate2D)coordinate;
{
    CLLocationCoordinate2D theCoordinate;
    theCoordinate.latitude = self.location.latitude;
    theCoordinate.longitude = self.location.longitude;
    return theCoordinate; 
}


- (NSString *)title
{
    return title;
}

// optional
- (NSString *)subtitle
{
    return user.userName;
	//return firstName;
}

@end
