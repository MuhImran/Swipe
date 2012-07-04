//
//  requestStringURLs.h
//  Petstagram
//
//  Created by Awais Ahmad Qureshi on 5/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class userProfile;
@class petsObject;
@class CLLocation;
@interface requestStringURLs : NSObject {

}
+(NSString *) getUserSearchRequest:(NSString *)_searchText :(BOOL)isPull;
+(NSString *) getUserPopularRequest:(BOOL)isPull;
+(NSString *) getUserNearByRequest:(CLLocation *)_newlocation :(BOOL)isPull :(int)_offset;
+(NSString *) getUserFeedRequest:(BOOL)isPull;
+(NSString *) getUserActivityRequest:(BOOL)isPull;
+(NSString *) getUserProfileRequest:(NSNumber *)_iden :(int)_blockSize :(int)_offset;
+(NSString *) getUserSupportRequest:(NSNumber *)_iden :(BOOL)_value;
+(NSString *) getLoginRequest;
+(NSString *) getUserCommentsRequest:(NSNumber *)_iden:(NSString *)_comments;
+(NSString *) getPhotoDetailRequest:(NSNumber *)_iden;
//+(NSString *) getPhotoUploadURL;
+(NSString *) getPhotoUploadURL:(NSString *)_sharingDta;
+(NSString *) getUserGuideURL;
+(NSString *) getPersonalProfileData;
+(NSString *) getUserPhotoRequest:(userProfile *)_user;
+(NSString *) getUserFollowingThisRequest:(NSNumber *)_iden;
+(NSString *) getUserFollowedThisRequest:(NSNumber *)_iden;
+(NSString *) getRelationShipRequest:(NSNumber *)_iden :(BOOL)_action;
+(NSString *) getAddPetRequest:(NSString *)_dataString;
+(NSString *) getPetInfo:(petsObject *)_pet;
+(NSString *) getPersonalProfileURL;
+(NSString *) getTopFeedRequest:(BOOL)isPull;
+(NSString *) getProfileImageURL:(NSMutableDictionary *)_dictionary;
+(NSString *) getProfileImageData:(NSMutableDictionary *)_dictionary;
+(NSString *) UpdateProfileURL;
@end
