//
//  HomeScreenViewController.m
//  show
//
//  Created by svp on 01/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "mapViewController.h"
#import "headerfiles.h"
#import "profileViewCell.h"
#import "domainClasses.h"
#import "photoDetailViewController.h"
#import "ActivityController.h"
#import "FeedCustomCell.h"
#import "feedCommentView.h"
#import "EGORefreshTableFooterView.h"
#import "profileViewController.h"
#import "commitDetailViewController.h"
#import "addCommentViewController.h"

#import "PhotoData.h"
@interface mapViewController (Private)

@end

@implementation mapViewController
@synthesize mapView;
@synthesize photodata;



#pragma mark -

+ (CGFloat)annotationPadding;
{
    return 10.0f;
}
+ (CGFloat)calloutHeight;
{
    return 40.0f;
}

- (void)gotoLocation
{
    // start off by default in San Francisco   //-33.841900:151.068200
    MKCoordinateRegion newRegion;
	newRegion.center.latitude = self.photodata.location.latitude;
    newRegion.center.longitude = self.photodata.location.longitude;
    newRegion.span.latitudeDelta = 0.071872;
    newRegion.span.longitudeDelta = 0.071863;
    [self.mapView setRegion:newRegion animated:YES];
    [self.mapView addAnnotation:photodata];
}

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withPost:(PhotoData*)_photo{
 if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
     self.photodata = _photo;
 // Custom initialization
 }
 return self;
 }
 


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView.mapType = MKMapTypeStandard;   // also MKMapTypeSatellite or MKMapTypeHybrid     MKMapTypeStandard
	self.title= @"Map";
    [self gotoLocation];
    
    
    // New navigation and button code eith effects
    
//    UINavigationItem *item = [self.navigationController.navigationBar.items objectAtIndex:0];
    UINavigationItem *item = self.navigationItem;
    item.titleView =  [commonUsedMethods navigationlogoView];
    
    item.leftBarButtonItem = [commonUsedMethods navigationButtonWithText:@"Back":TRUE];
    UIButton* rightButton = (UIButton*)item.leftBarButtonItem.customView;
    [rightButton addTarget:self action:@selector(backButtonMethod) forControlEvents:UIControlEventTouchUpInside];
    
    // code end
    
    /*
    UIImage *image1=[UIImage imageNamed:@"back.png"];
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.bounds = [Font_size getNavRightButtonFrame];     
    [button1 setBackgroundImage:image1 forState:UIControlStateNormal];
    UIImage *image2=[UIImage imageNamed:@"back_selected.png"];
    [button1 setBackgroundImage:image2 forState:UIControlStateSelected];
    //UIImage *image=[UIImage imageNamed:@"settings.png"];
    //UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    //button.bounds = [Font_size getNavRightButtonFrame];     
    [button1 setBackgroundImage:image1 forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(backButtonMethod) forControlEvents:UIControlEventTouchUpInside];    
    UIBarButtonItem *barButtonItem1 = [[UIBarButtonItem alloc] initWithCustomView:button1];
    self.navigationItem.leftBarButtonItem = barButtonItem1;
    [barButtonItem1 release];
     */
}

-(void) backButtonMethod
{
    [self.navigationController popViewControllerAnimated:YES];
} 
#pragma mark -
#pragma mark MKMapViewDelegate
/*
 - (void)showDetails:(id)sender
 {
 // the detail view does not want a toolbar so hide it
 // [self.navigationController setToolbarHidden:YES animated:NO];
 
 // [self.navigationController pushViewController:self.detailViewController animated:YES];
 }*/

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    // if it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    // handle our two custom annotations
    //
    if ([annotation isKindOfClass:[PhotoData class]]) 
        //  if ([annotation isKindOfClass:[BridgeAnnotation class]]) // for Golden Gate Bridge
    {
        // try to dequeue an existing pin view first
        static NSString* BridgeAnnotationIdentifier = @"bridgeAnnotationIdentifier";
        MKPinAnnotationView* pinView = (MKPinAnnotationView *)
        [mapView dequeueReusableAnnotationViewWithIdentifier:BridgeAnnotationIdentifier];
        if (!pinView)
        {
            // if an existing pin view was not available, create one
            MKPinAnnotationView* customPinView = [[[MKPinAnnotationView alloc]
                                                   initWithAnnotation:annotation reuseIdentifier:BridgeAnnotationIdentifier] autorelease];
            customPinView.pinColor = MKPinAnnotationColorPurple;
            customPinView.animatesDrop = YES;
            customPinView.canShowCallout = YES;
            
			NSLog(@"%@",annotation.title);
			NSLog(@"%@",annotation);
            return customPinView;
        }
        else
        {
            pinView.annotation = annotation;
        }
        return pinView;
    }
    return nil;
}
/*
 - (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
 {
 if (view.annotation == mapView.userLocation)
 return;
 
 EntertainDetailObject *buttonDetail = (EntertainDetailObject *)view.annotation;
 UIImageView *sfIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Icon-Small-50.png"]];
 view.leftCalloutAccessoryView = sfIconView;
 [sfIconView release];
 }
 */

- (void)mapView:(MKMapView *)theMapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    if (view.annotation == theMapView.userLocation)
        return;
	
    //PhotoData *photo = (PhotoData *)view.annotation;
    photoDetailViewController *PDVC1 = [[photoDetailViewController alloc] initWithNibName:@"photoDetailViewController" bundle:nil withPhoto:(PhotoData *)view.annotation];
    [self.navigationController pushViewController:PDVC1 animated:YES];
    [PDVC1 release];
    
    //	[self showDetailsViewController:photo];
	
    //show detail view using buttonDetail...
}
/*
 - (void)showDetailsViewController:(PhotoData *)_photoDetail
 {
 NSLog(@"showDetailsViewController by delegate method:%@",_photoDetail.title);
 //[self.navigationController pushViewController:detailViewController animated:YES];
 //[detailViewController setDetailItemDesc:_photoDetail:0];
 }
 */

-(void)viewWillAppear:(BOOL)animated 
{
    [super viewWillAppear:animated];
}
-(void) getFeedDataArray:(int)_tab
{
	//NSMutableArray *array
}
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    [AppDelegate clearAllCacheImage];
    // Release any cached data, images, etc that aren't in use.
}

/*
 
 - (void)enableCancelButton:(UISearchBar *)aSearchBar {
 for (id subview in [aSearchBar subviews]) {
 if ([subview isKindOfClass:[UIButton class]]) {
 [subview setEnabled:TRUE];
 }
 }  
 }
 
 - (void)searchBarTextDidEndEditing:(UISearchBar *)aSearchBar {
 [aSearchBar resignFirstResponder];
 [self performSelector:@selector(enableCancelButton:) withObject:aSearchBar afterDelay:0.0];
 }
 */
// called when text starts editing
/*
 - (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
 {
 searching = FALSE;
 NSLog(@"Search bar cancel button pressed ");
 [self.toolBar setFrame:self.searchbar.frame];
 searchBar.text=@"";
 [self.searchbar removeFromSuperview];
 [self.view addSubview:self.toolBar];
 reqType = segmentControl.selectedSegmentIndex;
 [self getFeedDataArray:reqType+1];
 [self reloadTableData];
 }
 
 - (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
 {
 NSLog(@"%@",searchBar.text);
 if([[commonUsedMethods trimString:searchBar.text] length] > 0)
 {
 searching = TRUE;
 reqType = 4;
 [self syncOnThreadAction:FALSE];
 }
 [searchBar resignFirstResponder];
 }
 */
-(void) loadAlertView:(NSString *)_title1:(NSString *)_msg
{
	UIAlertView *alert = [[UIAlertView alloc] 
						  initWithTitle:_title1 
						  message:_msg 
						  delegate:self 
						  cancelButtonTitle:@"OK" 
						  otherButtonTitles:nil];
	[alert show];
	[alert release];
	
}

- (void)viewDidUnload
{
    self.mapView = nil;
}

- (void)dealloc {
   	[mapView release];
	
    [super dealloc];
}



@end
