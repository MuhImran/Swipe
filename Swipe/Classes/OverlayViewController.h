//
//  OverlayViewController.h
//  TableView
//
//  Created by iPhone SDK Articles on 1/17/09.
//  Copyright www.iPhoneSDKArticles.com 2009. 
//

#import <UIKit/UIKit.h>
#import "clientObject.h"

@protocol overlayDelegate <NSObject,clientProtocolDelegate>
@optional
-(void) newShoppinglistCreated:(NSNumber *)_num:(NSString *)_message;
@end
@class ProductObject;
@interface OverlayViewController : UIViewController <clientProtocolDelegate> {

  
	id<overlayDelegate> delegate;
	id rvController;
	BOOL isPull;

	
	
}
@property (nonatomic, retain) id<overlayDelegate> delegate;
@property BOOL isPull;
-(void) newUserSignUp:(NSString *)_url;
-(void) getAuthorization:(NSString *)_url;
-(void) getUserProfileData:(NSString *)_url :(BOOL)_isPull :(BOOL)_firstLoad;
-(void) getFeedData:(NSString *)_url :(BOOL)_isPull;
-(void) getPopularData:(NSString *)_url :(BOOL)_isPull;
-(void) getNearByData:(NSString *)_url :(BOOL)_isPull;
-(void) getUserSearchData:(NSString *)_url :(BOOL)_isPull;
-(void) geTopFeedRequest:(NSString *)_url :(BOOL)_isPull;
-(void) setUserLikeRequest:(NSString *)_url;
-(void) setUserComments:(NSString *)_url;
-(void) setPhotoDetailRequest:(NSString *)_url;
-(void) sendPhotoForUpload:(NSString *)_url :(UIImage *)_image;
-(void) getUserGuide:(NSString *)_url;
-(void) getPersonalProfileData:(NSString *)_url;
-(void) getPhotoData:(NSString *)_url :(BOOL)_isPull;
-(void) getUserPullData:(NSString *)_url;
-(void) getUserFollowingThis:(NSString *)_url;
-(void) getUserFollowedThis:(NSString *)_url;
-(void) setNewPetDataRequest:(NSString *)_url;
-(void) setRelationShipWithUser:(NSString *)_url;
-(void) addPetInfo:(NSString *)_url;
-(void) editPersonnalInfo:(NSString *)_url :(UIImage *)_image;
-(void) editPersonnalInfo1:(NSString *)_url :(UIImage *)_image;
-(void) editPersonnalInfowithOutPhoto:(NSString *)_url;
-(void) checkAndUpdateExistingData:(int)_reqType;
//-(void) getUserProfileData:(NSString *)_url :(BOOL)_isPull;
-(void) getNearByMapData:(NSString *)_url :(BOOL)_isPull;
-(void) getProfileURL:(NSString *)_url;
-(void) getPrifileImage:(NSString *)_url;
-(void) getNearByLocationData:(NSString *)_url :(BOOL)_isPull;

-(void) getUserPostDeleteRequest:(NSString *)_url;
-(void) getUserPostFlagRequest:(NSString *)_url;

-(void) getThingsTagsRequest:(NSString *)_url;
-(void)pleaseWaitOverlay;


- (void)dismiss;
- (void)dismissSuccess;
- (void)dismissError;
@end
