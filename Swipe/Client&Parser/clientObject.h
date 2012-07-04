//
//  clientObject.h
//  testXML
//
//  Created by svp on 24/12/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ParserObject.h"
//#define kServerIp @"http://208.125.7.187/GG/"
//#define kServerIp @"https://api.petstagram.com/"
//#define REQUEST_TAG 1
#define LOGIN_TAG				1
#define NEW_USER_TAG			2
#define USER_PROFILE_TAG		3
#define USER_FEED_TAG			4
#define POPULAR_TAG				5
#define NEARBY_TAG				6
#define SEARCH_TAG				7
#define ACTIVITY_TAG			8
#define LIKE_TAG				9
#define COMMENTS_TAG			10
#define PHOTO_DETAIL_TAG		11
#define UPLOADPHOTO_TAG			12
#define USERGUIDE_TAG			13
#define PERSONAL_PROFILE_TAG	14
#define USER_PHOTO_TAG			15
#define USER_FOLLOWING_TAG		16
#define USER_FOLLOWED_TAG		17
#define NEW_PET_TAG				18
#define USER_RELATION_TAG		19
#define ADD_PET_TAG             20
#define EDIT_PROFILE_TAG        21
#define PULL_NEXT_TAG           22
#define UPDATE_POPULAR_TAG      23
#define UPDATE_NEARBY_TAG       24
#define UPDATE_ACTIVITY_TAG     25
#define PROFILE_URL_TAG         26
#define PROFILE_IMAGE_TAG       27
#define NEARBYLOC_TAG           28
#define DELETEPOST_TAG          29
#define FLAGPOST_TAG            30
#define THINGS_TAG              31

typedef enum playerStateTypes
{
	LOGIN			=1,
	NEW_USER		=2,
    USER_PROFILE	=3,
	USER_FEED		=4,
	POPULAR			=5,
	NEARBY			=6,
	SEARCH			=7,
	ACTIVITY		=8,
	LIKE			=9,
	COMMENTS		=10,
	PHOTO_DETAIL	=11,
	UPLOADPHOTO		=12,
	USERGUIDE		=13,
	PERSONAL_PROFILE=14,
	USER_PHOTO		=15,
	USER_FOLLOWING	=16,
	USER_FOLLOWED	=17,
	NEW_PET			=18,
    USER_RELATION   =19,
    ADD_PET         =20,
    EDIT_PROFILE    =21,
    PULL_NEXT       =22,
    UPDATE_POPULAR  =23,
    UPDATE_NEARBY   =24,
    UPDATE_ACTIVITY= 25,
    PROFILE_URL      =26,
    PROFILE_IMAGE   = 27,
    NEARBYLOC       = 28,
    DELETEPOST   =29,
    FLAGPOST     = 30,
    THINGS         =31 
	
	
} requestState;

@protocol clientProtocolDelegate <NSObject,ParserProtocolDelegate>
@optional
-(void) notfiyResponse:(NSNumber *)_value;
-(void) profileImageDownload:(NSMutableData *)_imageData;

@end

@interface clientObject : NSObject<ParserProtocolDelegate> {
	
	NSMutableData                   *webData;
	NSString                        *sRequest;
	ParserObject                    *parser;
	
	NSURLConnection                 *urlconnection;
	id<clientProtocolDelegate>      delegate;
    requestState                    requestTag;
	int                             responseCode;
	BOOL							isPull;
	

}

@property (nonatomic, retain) ParserObject *parser;
@property (nonatomic, retain) NSMutableData *webData;
@property (nonatomic, retain) NSString *sRequest;
@property (nonatomic, retain) id<clientProtocolDelegate> delegate;
@property BOOL	isPull;
-(void) newUserSignUp:(NSString *)_url;
-(void) getAuthorization:(NSString *)_url;
-(void) getUserProfileData:(NSString *)_url;

-(void) getFeedData:(NSString *)_url;
-(void) getPopularData:(NSString *)_url;
-(void) getNearByData:(NSString *)_url;
-(void) getUserSearchData:(NSString *)_url;
-(void) getTopFeedData:(NSString *)_url;
-(void) setUserLikeRequest:(NSString *)_url;
-(void) setUserComments:(NSString *)_url;
-(void) setPhotoDetailRequest:(NSString *)_url;
//-(void) setPhotoUploadRequest:(NSString *)_url;
-(void) getUserGuide:(NSString *)_url;
-(void) getPersonalProfileData:(NSString *)_url;
-(void) getPhotoData:(NSString *)_url;
-(void) getUserFollowingThis:(NSString *)_url;
-(void) getUserFollowedThis:(NSString *)_url;
-(void) setNewPetDataRequest:(NSString *)_url;
-(void) setRelationShipWithUser:(NSString *)_url;
-(void) addPetInfo:(NSString *)_url;
-(void) getUserPullData:(NSString *)_url;
-(void) editPersonnalInfo:(NSString *)url:(UIImage *)_image;
-(void) sendPhotoForUpload:(NSString *)url:(UIImage *)_image;
-(void) editPersonnalInfowithOutPhoto:(NSString *)_url;
-(void) checkAndUpdateExistingData:(int)_reqType;
-(void) getProfileURL:(NSString *)_url;
-(void) getPrifileImage:(NSString *)_url;
-(void) getNearByLocationData:(NSString *)_url;

-(void) getUserPostDeleteRequest:(NSString *)_url;
-(void) getUserPostFlagRequest:(NSString *)_url;

-(void)getThingsTagsRequest:(NSString *)_url;

@end
/*
-(void) makeDelegateNull;

-(void) getAllProducts;
-(void) getAuthorization:(NSString *)_userEmail:(NSString *)_password;
-(void) newUserSignUp:(NSString *)_userName:(NSString *)_userEmail:(NSString *)_password;
-(void) getAllRecipies;
-(void) getRecipeDetail:(int)_productId;

-(void) getTransactionID;
-(void) getAllCategories;
-(void) getAllStoresNames;
-(void) getStoreCategories:(int) _storeId;
-(void) getCoupons;
-(void) getCouponDetail:(int)_couponId;
-(void) searchProduct:(int )_catId;
-(void) createShopingList:(NSString *)_name;
-(void) addProductToShoppingList:(NSString *)_productIds:(NSString *)listId;
-(void) getInventory;
-(void) getLessItem;
-(void) getAllShoppinglistName;
-(void) getCategoryProduct:(NSString *)categoryID;


-(void) storeSearchByName:(NSString *)_name;
-(void) storeProducts:(NSString *)_name;

-(void) getProductSearchLocal:(NSString *) _string;
-(void) getProductInformation:(NSString *) _string;
-(void) parserResponse:(BOOL) _value;
-(void) getShareShoppingList;
-(void) getProductReviews:(NSString *) _searchString;
-(void) removeShoppingList:(NSString *) _shoppingListID;
-(void) getUserList;
-(void) shareList:(NSString *)listID:(NSString *)userIDs;
-(void) UpdateInventory:(NSMutableArray *) _array;
-(void) UpdateInventory2:(NSString *)_productID:(NSString *)_count;
-(void) getCellfireProduct:(NSString *) _string;

-(void) getAllProducts;
-(void) getShoppingListItem:(NSString *) _string;

-(void) updateShoppingItem:(NSString *)_shoppinglistID:(NSString *)_itemString:(NSString *)_qtyString;
-(void) RemoveShoppingListItem:(NSString *)_shoppinglistID:(NSString *)_itemString;

-(void) splitShoppingList:(NSString *)_usrId:(NSString *)_listId:(NSString *)_productID;
-(void) leftOverWizard;


-(void) getAllFavorites;

*/
