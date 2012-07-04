//
//  profileImageFetcher.h
//  Posterboard
//
//  Created by Imran on 8/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OverlayViewController.h"
#import "ParserObject.h"

@interface profileImageFetcher : NSObject <overlayDelegate> {
    
    NSMutableData                   *webData;
    int                             requestTag;
    int                             responseCode;
    OverlayViewController           *overlay;
    UIImage                         *profileImage;
    
}
@property (nonatomic, retain) NSMutableData *webData;
@property (nonatomic, retain)  UIImage                         *profileImage;
-(void) getProfileImageRequest:(NSString *)_url;
-(void) getProfileImageURL:(NSString *)_string;
-(void) requestForProfileURL;
-(NSString *) loginAgain;
-(void) editPersonnalInfo:(NSString *)url:(UIImage *)_image;
-(void) loginStringParse:(NSString *)_string;
-(void) saveNewProfilePhotoToToken;
@end
