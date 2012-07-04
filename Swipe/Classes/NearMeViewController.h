//
//  HomeScreenViewController.h
//  show
//
//  Created by svp on 01/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "clientObject.h"
#import "OverlayViewController.h"
#import "ParserObject.h"

#import "clientObject.h"
#import "feedCommentView.h"
#import "addCommentViewController.h"
#import "GPS_Object.h"
#import <MapKit/MapKit.h>
#import "photoDetailViewController.h"

@class domainClasses;
//@class photoDetailViewController;
@class profileViewController;
@class EGORefreshTableFooterView;
@class commitDetailViewController;

@interface NearMeViewController: UIViewController <overlayDelegate,ParserProtocolDelegate,
clientProtocolDelegate,UISearchBarDelegate,GPXDelegate,MKMapViewDelegate,DeletePhotoProtocolDelegate> {
    
	
                                                        
    
    NSMutableArray *mapAnnotations;
    MKMapView                  *mapView;
     NSMutableDictionary        *imageDownloadsInProgress;
	NSMutableArray              *dataArray,*searchArray;
	IBOutlet UISearchBar		*searchbar;
	IBOutlet UIBarButtonItem    *searchButton;
    OverlayViewController       *overlay;
    BOOL                        overScreen,firtTimeView,searching,isPull,isPushNewView;
    int                         reqType;
	int                         Iden;
    CLLocation                  *currentLocation;
    GPS_Object                  *GpxObject;
    BOOL isFirstRun;
}
@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) NSMutableArray *mapAnnotations;
@property (nonatomic, retain) NSMutableDictionary        *imageDownloadsInProgress;
@property (retain,nonatomic )  GPS_Object    *GpxObject;
@property (retain,nonatomic ) IBOutlet UIBarButtonItem    *searchButton;
@property (retain,nonatomic ) IBOutlet IBOutlet UISearchBar	*searchbar;
@property (retain,nonatomic ) NSMutableArray *dataArray,*searchArray;
@property (retain,nonatomic )  CLLocation   *currentLocation; 


+ (CGFloat)annotationPadding;
+ (CGFloat)calloutHeight;

-(void) getLocationFromAddressString;
//-(IBAction) searchButtonPressed:(id)sender;
//-(IBAction) segmentButtonPressed:(id)sender;
//-(IBAction) searchButtonPressed:(id)sender;
//-(void) getFeedDataArray;
-(void) syncOnThreadAction:(BOOL)_isPull;
-(void) startGettingGPXPoint:(BOOL)booValue;
-(void) getFeedDataArray:(int)_tab;
//-(void) callNewView;
-(void) loadAlertView:(NSString *)_title1:(NSString *)_msg;
-(IBAction) getMyLocation:(id)sender;
-(NSMutableArray *)FilterExsistingFeedsWithDataArray:(NSMutableArray *)_array;
-(NSMutableArray *)FilterPhotoDataWithDate:(NSMutableArray *)_array;
-(void) CancelSearchbar;
@end

