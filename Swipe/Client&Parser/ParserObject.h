//
//  ParserObject.h
//  GG Application
//
//  Created by Haris Jawaid on 12/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSON.h"
#import "domainClasses.h"


@protocol ParserProtocolDelegate <NSObject>
@optional
-(void) ParserResponse:(NSString *)_str;
-(void) ParserArraylist:(NSMutableArray *) _array;
-(void) addPullDataInlist:(NSMutableArray *) _array;
-(void) loginResponse:(NSNumber *)_value;
-(void) hasPullNewData:(NSMutableArray *) _array;
-(void) userFeedData:(NSDictionary *)_dictionary;
-(void) errorResponse:(NSDictionary *)_dictionary;

@end


@interface ParserObject : NSObject {
    
	id<ParserProtocolDelegate>                  delegate;
	NSMutableArray                              *blogEntries;
	SBJSON                                      *json2; 
	BOOL										isPull;

}
@property (retain,nonatomic) id<ParserProtocolDelegate> delegate;
@property BOOL isPull;
-(id) init;
//-(void) delegateActionError;
//-(void) delegateAction:(int )_num:(NSString *)_str;

-(void) loginStringParse:(NSString  *)_string;
-(void) registrationStringParse:(NSString *)_string;

-(void) userFeedStringParse:(NSString *)_string;
-(void) popularStringParse:(NSString *)_string;
-(void) nearByStringParse:(NSString *)_string;
-(void) searchStringParse:(NSString *)_string;
-(void) TopFeedStringParse:(NSString *)_string;
-(void) likeStringPase:(NSString *)_string;
-(void) getPhotoDetail:(NSString *)_string;
-(void) getPhotoUploadResponse:(NSString *)_string;
-(void) guideStringParse:(NSString *)_string;
//-(void) getTopFeedRequest:(NSString *)_string;
-(void) getProfileImageURL:(NSString *)_string;


-(void) userProfilePullData:(NSString *)_string;

-(void) userPhotoStringParse:(NSString *)_string;
-(void) userFollowingStringParse:(NSString *)_string;
-(void) userFollowedStringParse:(NSString *)_string;
-(void) relationStringParse:(NSString *)_string;
-(void) addPetStringParse:(NSString *)_string;
-(void) EditProfileStringParse:(NSString *)_string;
-(void) personalProfileStringParse:(NSString *)_string;
-(void) userProfileStringParse:(NSString *)_string;

-(void) updatePopularData:(NSString *)_string;
-(void) updateNearByData:(NSString *)_string;
-(void) updateActivityData:(NSString *)_string;


-(void) requestForImageDownload:(NSString*)_url;


-(void) userNearByLocationParse:(NSString *)_string;

-(NSMutableArray *) getCommentArray:(NSMutableArray *)_commentArray;
-(NSMutableArray *) getLikeData:(NSMutableArray *)_likeArray;
-(locationData *) getLocation:(NSMutableDictionary *)_dictionary;
-(ResolutionInfo *) getResolution:(NSString *)_urlString:(BOOL)isDownloadAble;
-(NSMutableArray *) getPhotoArray:(NSMutableArray *)_array;
-(userProfile *) getUser:(NSMutableDictionary *)_dictionary;
-(BOOL) checkNullValues:(NSString *)_string;
-(userProfile *) getLoggedUser;
-(NSMutableArray *) getPhotoArray2:(NSMutableArray *)_array:(userProfile *)_user;

-(void) getUserPostDeleteData:(NSString *)_string;
-(void) getUserPostFlagData:(NSString *)_string;

-(void)getThingsTagsData:(NSString *)_string;

@end
