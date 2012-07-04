//
//  SingletonClass.h
//  FindASitter
//
//  Created by svp on 29/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "OverlayViewController.h"
@class clientObject;
@class ParserObject;
@class tokeInfo;
@class socailConnectObject;
//#define imageCaches [SingletonClass sharedInstance] 
@interface SingletonClass : NSObject <overlayDelegate>{
	
    clientObject                *client;
	ParserObject                *parser;
	OverlayViewController       *overlay;
    tokeInfo                        *tokeninfo;
	NSMutableDictionary         *imageDictionary,*fbDictionary;
    CLLocation                  *currentLocation;
    UIImage                     *profileImage;
    NSString                    *pushKey;
    socailConnectObject         *socialObj;
}

@property (retain,nonatomic) socailConnectObject         *socialObj;
@property (retain,nonatomic)  UIImage                     *profileImage;
@property (retain,nonatomic) NSMutableDictionary *imageDictionary,*fbDictionary;
@property (retain,nonatomic) ParserObject *parser;
@property (retain,nonatomic) clientObject *client;
@property (retain,nonatomic) OverlayViewController *overlay;
@property (retain,nonatomic) tokeInfo  *tokeninfo;
@property (retain,nonatomic) CLLocation                  *currentLocation;
@property (retain,nonatomic) NSString                    *pushKey;


+ (SingletonClass*)sharedInstance;
-(ParserObject *) getParser;
-(clientObject *) getClientObject;
-(OverlayViewController *) getOverlay;
-(UIImage *) getCacheImage:(NSString *)_key;
-(NSMutableDictionary *) getImageDictionary;
//-(BOOL) checkCacheImage:(NSString *)_key;
-(void) setCacheImage:(UIImage *)_img:(NSString *)_key;

-(void) setTokenInformation:(tokeInfo *)_userData;
-(tokeInfo *) getTokenInformation;

-(void) setMyCurrentLocation:(CLLocation *)_location;
-(CLLocation *) getMyCurrentLocation;

-(void) setFbDictionary:(NSMutableDictionary *)_fbDictionary;
-(NSMutableDictionary *) getFbDictionary;

-(void) saveUserPushKey:(NSString *)_key;
-(NSString *) getUserPushKey;
-(void) setFaceBookDictionary:(NSMutableDictionary *)_fbDictionary;
-(socailConnectObject *) getSocialObject;
@end

/*
http://blog.theanalogguy.be/2010/10/06/custom-colored-uitabbar-icons/
http://didikot.com/?p=106
*/