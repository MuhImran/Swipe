//
//  FindNearbyViewController.h
//  Posterboard
//
//  Created by Apptellect5 on 9/6/11.
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
#import "SearchResultViewController.h"

@protocol FindNearbyProtocolDelegate <NSObject,SearchResultProtocolDelegate>

-(void) FindNearbyResponse:(NearbyLocationObject *)_object;

@end

@interface FindNearbyViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,overlayDelegate,ParserProtocolDelegate,clientProtocolDelegate,UISearchBarDelegate,GPXDelegate,MKMapViewDelegate,SearchResultProtocolDelegate>
{

    IBOutlet UITableView *nbTableView;
    IBOutlet UISearchDisplayController *nbSearchBar;
    BOOL                        isPull,overScreen;
    NSMutableArray                     *dataArray,*searchArray;
    OverlayViewController               *overlay;
    CLLocation                          *currentLocation;
    id<FindNearbyProtocolDelegate>                  delegate;
    NSString *strSearch;
}


@property (retain,nonatomic) id<FindNearbyProtocolDelegate> delegate;
@property (nonatomic,retain) IBOutlet UITableView *nbTableView;
@property (nonatomic,retain) IBOutlet UISearchDisplayController *nbSearchBar;
@property (nonatomic,retain)     NSString *strSearch;
@property (nonatomic, retain) IBOutlet CLLocation   *currentLocation;
@property (nonatomic, retain) NSMutableArray        *dataArray,*searchArray;


-(void)loadAlertView:(NSString *)title :(NSString *)msg;
-(void) backButtonMethod;
-(IBAction) locationButtonPressed:(id)sender;

-(void) syncOnThreadAction;
@end
