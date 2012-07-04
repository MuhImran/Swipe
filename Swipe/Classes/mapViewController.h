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

@class domainClasses;

@interface mapViewController: UIViewController <overlayDelegate,ParserProtocolDelegate,
clientProtocolDelegate,UISearchBarDelegate,GPXDelegate,MKMapViewDelegate> {
    
	
    
    
    
    MKMapView                  *mapView;
	PhotoData                  *photodata;
	
    
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withPost:(PhotoData*)_photo;

@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) PhotoData   *photodata;




+ (CGFloat)annotationPadding;
+ (CGFloat)calloutHeight;


//-(IBAction) searchButtonPressed:(id)sender;
//-(IBAction) segmentButtonPressed:(id)sender;
//-(IBAction) searchButtonPressed:(id)sender;
//-(void) getFeedDataArray;
-(void) getFeedDataArray:(int)_tab;
//-(void) syncOnThreadAction:(BOOL)_isPull;
//-(void) startGettingGPXPoint:(BOOL)booValue;
-(void) getFeedDataArray:(int)_tab;
//-(void) callNewView;
-(void) loadAlertView:(NSString *)_title1:(NSString *)_msg;

@end

