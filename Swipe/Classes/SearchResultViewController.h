//
//  SearchResultViewController.h
//  Posterboard
//
//  Created by Apptellect5 on 9/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cameraViewController.h"
#import "adjustLibPhotViewContorller.h"
#import "TiledScrollView.h"
#import "TapDetectingView.h"
#import "ThumbImageView.h"
#import "ParserObject.h"
#import "clientObject.h"
#import "GPS_Object.h"
#import "OverlayViewController.h"
#import "NearbyLocationObject.h"

@protocol SearchResultProtocolDelegate <NSObject>
@optional
-(void) SearchResultResponse:(NearbyLocationObject *)_object;

@end

@interface SearchResultViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,overlayDelegate,ParserProtocolDelegate,clientProtocolDelegate,GPXDelegate,MKMapViewDelegate>{
    
    IBOutlet UITableView *nbTableView;
//    IBOutlet UISearchDisplayController *nbSearchBar;
    BOOL                        isPull,overScreen;
    NSMutableArray                     *dataArray,*searchArray;
    OverlayViewController               *overlay;
    CLLocation                          *currentLocation;
    NSString*   strText;
    id<SearchResultProtocolDelegate>                  delegate;
    
}

@property (retain,nonatomic) id<SearchResultProtocolDelegate> delegate;

@property (nonatomic,retain) IBOutlet UITableView *nbTableView;
//@property (nonatomic,retain) IBOutlet UISearchDisplayController *nbSearchBar;
@property (nonatomic,retain) NSString*   strText;
@property (nonatomic, retain) IBOutlet CLLocation   *currentLocation;
@property (nonatomic, retain) NSMutableArray        *dataArray,*searchArray;


-(void)loadAlertView:(NSString *)title :(NSString *)msg;
-(void) backButtonMethod;
//-(IBAction) locationButtonPressed:(id)sender;

-(void) syncOnThreadAction;
-(void) initSearchResultWithSearchText:(NSString *)string :(CLLocation *) loc;
-(void) searchLocation;

@end
