//
//  PhotoData.h
//  Petstagram
//
//  Created by Haris Jawaid on 4/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "likeData.h"
#import "CommentsData.h"
#import "ResolutionInfo.h"
#import "locationData.h"
#import "userProfile.h"
#import <MapKit/MapKit.h>

@interface PhotoData : NSObject<NSCopying,NSFastEnumeration,MKAnnotation>  {
    
    NSString        *title,*desc,*tag;
    NSMutableArray  *commentArray,*supporterArray;
    NSNumber        *count;
    NSString        *createdDate;
    NSNumber        *iden;
    userProfile     *user;
    ResolutionInfo  *lowResolution,*standResolution,*thumbnail;
    locationData    *location;
	BOOL			hasComment,hasLike;
    NSString        *postPageUrl;
    NSNumber        *supporters;

    
    
}
@property (nonatomic,retain) NSString        *postPageUrl;
@property (nonatomic,retain) NSString *title,*desc,*tag;
@property (nonatomic,retain) NSMutableArray *commentArray,*supporterArray;
@property (nonatomic,retain) NSNumber  *count;
@property (nonatomic,retain) NSString  *createdDate;
@property (nonatomic,retain) NSNumber  *supporters;
@property (nonatomic,retain) NSNumber  *iden;
@property (nonatomic,retain) userProfile  *user;
@property (nonatomic,retain) ResolutionInfo  *lowResolution,*standResolution;
@property (nonatomic,retain) ResolutionInfo  *thumbnail;
@property (nonatomic,retain) locationData    *location;
@property BOOL hasComment,hasLike;
@end