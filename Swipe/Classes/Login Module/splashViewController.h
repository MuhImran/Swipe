//
//  splashViewController.h
//  Petstagram
//
//  Created by Awais Ahmad Qureshi on 5/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OverlayViewController.h"
#import "clientObject.h"
#import "ParserObject.h"
#import "GPS_Object.h"

@interface splashViewController : UIViewController<overlayDelegate,clientProtocolDelegate,ParserProtocolDelegate,GPXDelegate> {

	OverlayViewController				*overlay;
	int									reqType;
	IBOutlet UIActivityIndicatorView	*activity;
    CLLocation *currentLocation;
  	//BOOL isLocation;
    
}
@property (retain,nonatomic) IBOutlet UIActivityIndicatorView	*activity;
-(void) getUserFeed;
-(void) syncOnThreadAction;
-(void) callNewView;
-(void) loadAlertView:(NSString *)_title1:(NSString *)_msg;
@property (nonatomic,retain) CLLocation *currentLocation;
//@property (nonatomic,assign) BOOL isLocation;
//-(void)LoadViewAgain;
@end
