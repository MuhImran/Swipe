//
//  DataModel.h
//  Petstagram
//
//  Created by Awais Ahmad Qureshi on 5/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PhotoData;
@class likeData;
@class CommentsData;
@interface DataModel : NSObject {

}
+(void )   setUserProfileArray:(NSMutableArray *)_userProfileArray;
+(NSMutableArray *) getUserProfileArray;

+(void )   setUserFeedArray:(NSMutableArray *)_feedArray;
+(NSMutableArray *) getUserFeedArray;

+(void )setDataInDictionary:(NSMutableArray *)_userArray:(int)_tab;
+(NSMutableArray *) getDataInDictionary:(int)_tab;
+(BOOL ) hasDataInDictionary:(int)_tab;
+(NSString *) keyValueOfTab:(int)_tab;
+(void )   upDateDataInDictionary:(NSMutableArray *)_Array:(int)_tab;
+(void)   updateLikeProperty:(NSNumber *)_iden:(int)selectedIndex;
+(void)   updateCommentProperty:(NSNumber *)_iden:(NSString *)text:(int)selectedIndex;
+(PhotoData *)  getPhotoDataWithIdentity:(NSNumber *)_iden:(int)selectedIndex;
+(void)   updateLikePropertyInPhotoArray:(NSNumber *)_iden:(int)selectedIndex;
+(likeData *) createUserObject2;
+(CommentsData *) createUserObject:(NSString *)_str;
+(BOOL )   upDateExistingDataWithNewData:(NSMutableArray *)_Array:(int)_tab;
+(void) removeAllStoreData;
+(void) addUploadedPhotoInDictionary:(PhotoData *)_photoData;
+(NSMutableArray *) applyFilters:(NSMutableArray *)_array;
+(NSMutableArray *) setSortArray:(NSMutableArray *)_feedArray;
+(BOOL)   updateNearByData:(NSMutableArray *)_Array:(int)_tab;

+(void)deletePhotoData:(int)_iden:(int)_tab;
+(BOOL)updateProfileData:(NSMutableArray *)_Array:(int)_tab;
+(void)   updateCommentInSingleDetailPhoto:(NSNumber *)_iden:(NSString *)text:(int)selectedIndex;
+(void) updateCommentInPhotoArray:(NSNumber *)_iden:(NSString *)text:(int)selectedIndex;
+(void)   updateLikePropertyInSinglePhoto:(NSNumber *)_iden:(int)selectedIndex;
@end
