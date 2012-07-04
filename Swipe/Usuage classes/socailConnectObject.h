//
//  faceBookObject.h
//  Posterboard
//
//  Created by Imran on 8/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SA_OAuthTwitterController.h"  
#import "SA_OAuthTwitterEngine.h"

//#define kOAuthConsumerKey				@"kVC8qDOsOBMtDoyZZgNHw"							//REPLACE With Twitter App OAuth  
//#define kOAuthConsumerSecret			@"IWJ6EazbqHnYHhYFlxPhkDCZU29hUTz5b7Wc9NzNeM"		//REPLACE With Twitter App OAuth S

#define kOAuthConsumerKey				@"5M4grNhUdQXXsTHygNYgA"							//REPLACE With Twitter App OAuth  
#define kOAuthConsumerSecret			@"3iybNp4i5px6hbr3bh0N1LNFps3Jqdvy2GkMC2Bww"		//REPLACE With Twitter App OAuth S
@class PhotoData;
@protocol socialResponseDelegate <NSObject>
@optional
-(void)showTwitterView:(SA_OAuthTwitterController *)_controller;
-(void) TwitterStatus:(NSNumber *)_status;
-(void) facebookStatus:(NSNumber *)_status;
-(void) hasUserProfileData:(NSMutableData *)_dictionary;
@end

@interface socailConnectObject : NSObject {
         id<socialResponseDelegate> delegate;
    PhotoData *_photo;
    
}
@property (retain,nonatomic)  PhotoData *_photo;
@property (retain,nonatomic) id<socialResponseDelegate> delegate;
-(id) init;
-(void) setDelegate:(id)_delegate;
-(void) TwitterConnectMethod;
-(void) facebookConnectMethod;
-(void) signOutTwitter;
-(void) loginTwitter;
-(void) logoutTwitter;
-(void) singOutFacebook;
-(BOOL) TwitterHasKey;
-(void) postSocialData:(PhotoData *)_photo1:(BOOL)_isFb:(BOOL)_isTw;
-(void) TwitterMesasgePost:(PhotoData *)_photodata;
-(void)showAlert:(NSString *)msg;
-(void) postFBMessage;
-(void) postSocialData:(PhotoData *)_photo1:(BOOL)_isTw:(BOOL)_isFb;
@end
