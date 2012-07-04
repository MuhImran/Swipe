//
//  HomeScreenViewController.m
//  show
//
//  Created by svp on 01/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NearMeViewController.h"
#import "headerfiles.h"
#import "profileViewCell.h"
#import "domainClasses.h"
//#import "photoDetailViewController.h"
#import "FeedCustomCell.h"
#import "feedCommentView.h"
#import "EGORefreshTableFooterView.h"
#import "profileViewController.h"
#import "commitDetailViewController.h"
#import "addCommentViewController.h"
#import "FeedData.h"



@interface NearMeViewController (Private)

@end

@implementation NearMeViewController
@synthesize searchbar;
@synthesize searchButton;
@synthesize mapAnnotations;
@synthesize currentLocation;
@synthesize GpxObject;
@synthesize mapView;
@synthesize searchArray,dataArray;
@synthesize imageDownloadsInProgress;



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
    if(!searching)
    {
        newRegion.center.latitude = self.currentLocation.coordinate.latitude;
        newRegion.center.longitude = self.currentLocation.coordinate.longitude;
    }
    else
    {
        for (int i =0 ; i < [self.searchArray count]; i++) {
            PhotoData *data = [self.searchArray objectAtIndex:i];
            if(data.location.latitude && data.location.longitude)
            {
                newRegion.center.latitude =  data.location.latitude;
                newRegion.center.longitude = data.location.longitude;
                break;
            }
            
        }
    }
    if(searching)
    {
        newRegion.span.latitudeDelta = 0.425872;
        newRegion.span.longitudeDelta = 0.425863;
    }
    else
    {
        isFirstRun = NO;
        
        NSLog(@"span lat %f span lon %f",[commonUsedMethods getMapSpanLatitudeDelta],[commonUsedMethods getMapSpanLongitudeDelta]);
        newRegion.span.latitudeDelta = [commonUsedMethods getMapSpanLatitudeDelta];// default is 0.016
        newRegion.span.longitudeDelta = [commonUsedMethods getMapSpanLongitudeDelta];// default is 0.016
    }
    [self.mapView setRegion:newRegion animated:YES];
}
-(IBAction) getMyLocation:(id)sender
{
    [self gotoLocation];
    isPull = TRUE;
    [[GPS_Object sharedInstance] startUpdatingLocating:self];
    
}
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
 // Custom initialization
 }
 return self;
 }
 */


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title= @"Map";
    self.mapView.mapType = MKMapTypeStandard;   // also MKMapTypeSatellite or MKMapTypeHybrid     MKMapTypeStandard
	imageDownloadsInProgress = [[NSMutableDictionary alloc] init];
    // New navigation and button code eith effects
    
    UINavigationItem *item = [self.navigationController.navigationBar.items objectAtIndex:0];
    item.titleView =  [commonUsedMethods navigationlogoView];
    
//    self.navigationItem.titleView =  [commonUsedMethods navigationlogoView];
	self.searchbar.tintColor = [commonUsedMethods getNavTintColor];
    [Font_size customSearchBarBackground:self.searchbar];
	firtTimeView = TRUE;
	searching = FALSE;
    isPull = FALSE;
    self.mapView.showsUserLocation  = YES;
    
    //UIImage *image=[UIImage imageNamed:@"topicButton.png"];
    //UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    //button.bounds = [Font_size getNavRightButtonFrame];  
    /*
    UIImage *image=[UIImage imageNamed:@"Topics.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.bounds = CGRectMake(0, 0, 72, 30);     
    
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(topicButtonPressed:) forControlEvents:UIControlEventTouchUpInside];    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = barButtonItem;
    [barButtonItem release];*/
    isPushNewView = FALSE;
    
    
}
-(void)viewWillAppear:(BOOL)animated 
{
    [super viewWillAppear:animated];
    isFirstRun = YES;
    //[[GPS_Object sharedInstance] startUpdatingLocating:self];
    [commonUsedMethods setTabIndexToReturn:1];
//    if(!isPushNewView)
//    {
        searching = FALSE;
        if(![DataModel hasDataInDictionary:10])
        {   
            isPull = TRUE;
            [DataModel setDataInDictionary:[DataModel getDataInDictionary:3] :10];
            FeedData *feed = [[DataModel getDataInDictionary:10] objectAtIndex:0];
            
            //self.dataArray = feed.photoArray;
            self.dataArray = [self FilterPhotoDataWithDate:feed.photoArray];
//            [self.mapView removeAnnotations:self.mapView.annotations];
            [self.mapView addAnnotations:self.dataArray];
        }
    if(!isPushNewView)
       [[GPS_Object sharedInstance] startUpdatingLocating:self];
//    else
//        [self.mapView addAnnotations:self.dataArray];
        
//    }
//    else
//    {
//        FeedData *feed = [[DataModel getDataInDictionary:3] objectAtIndex:0];
//        self.dataArray = feed.photoArray;
//        [self.mapView removeAnnotations:self.mapView.annotations];
//        [self.mapView addAnnotations:self.dataArray];
//        
//    }
     
}
- (void)viewWillDisappear:(BOOL)animated {
	
	NSLog(@"Now removing view and removing all dictionary contents");
	NSArray *viewControllers = self.navigationController.viewControllers;
	if (viewControllers.count > 1 && [viewControllers objectAtIndex:viewControllers.count-2] == self) 
	{
        // TO DO
        isPushNewView = TRUE;
	} 
	else if ([viewControllers indexOfObject:self] == NSNotFound) {
        
    }
    else
    {
        isPushNewView = FALSE;
    }
    
}

-(IBAction) topicButtonPressed:(id)sender
{
    
}

#pragma mark Delete Photo Delegate

-(void) DeletePhotoResponse:(NSString *)_index
{
    NSLog(@"index %d, array : %d",[_index intValue], [dataArray count]);
    [DataModel deletePhotoData:[_index intValue] :3];
    //[DataModel deletePhotoData:[_index intValue] :10];
    //[self.dataArray removeObjectAtIndex:[[commonUsedMethods getPhotoIndexToDelete] intValue]];
    NSLog(@"data array %d ",[dataArray count]);
    //[self reloadTableData];
    //[self.dataTable reloadData];
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:self.dataArray];
    for(PhotoData *foto in array)
    {
        if([_index intValue] == [foto.iden intValue])
        {
            [array removeObject:foto];
            [self.mapView removeAnnotations:[NSArray arrayWithObjects:foto, nil]];
            self.dataArray = array;
            break;
        }
    }
    [array release];
    
    
}


#pragma mark -
#pragma mark Search Bar 
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    // only show the status bar’s cancel button while in edit mode
    searchBar.showsCancelButton = YES;
    searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = NO;
}

/*
 - (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
 {
 if([searchText isEqualToString:@""] || searchText==nil){
 return;
 }
 }
 */
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    // if a valid search was entered but the user wanted to cancel, bring back the main list 
    searchBar.text = @"";
    // searchBar.showsCancelButton = NO;
    [searchBar resignFirstResponder];
    [self CancelSearchbar];
}
// called when Search (in our case “Done”) button pressed
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    self.searchbar.text = [commonUsedMethods stripDoubleSpaceFrom:searchbar.text];
    [searchBar resignFirstResponder];
    if([self.searchbar.text length]>0)
    {
        reqType =2;
        searching = TRUE;
        [self syncOnThreadAction:FALSE];
    }
}

-(void) CancelSearchbar
{
    NSMutableArray *array = [DataModel getDataInDictionary:10];
    FeedData *feed = [array objectAtIndex:0];
    self.dataArray = feed.photoArray;
    reqType = 1;
    searching = FALSE;
    //[self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView addAnnotations:[self FilterExsistingFeedsWithDataArray:self.dataArray]];
    [self gotoLocation];
    //[self getLocationFromAddressString];
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


- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    NSLog(@"mapview span latitudedelta %f longitudedelta %f",mapView.region.span.latitudeDelta,mapView.region.span.longitudeDelta);
    if(!isFirstRun)
    {
        [commonUsedMethods setMapSpanLatitudeDelta:mapView.region.span.latitudeDelta];
        [commonUsedMethods setMapSpanLongitudeDelta:mapView.region.span.longitudeDelta];
    }
}

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
			UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            customPinView.rightCalloutAccessoryView = rightButton;
            // adding image to annotation modifiied 04-10-2011
            PhotoData *photodata = (PhotoData *)annotation;
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(2, 2, 32, 32)];
            if (![imageCaches imageFromKey:photodata.user.imgURL])
            {
//                UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(8, 8, 20, 20)];
//                [activityIndicator startAnimating];
//                activityIndicator.activityIndicatorViewStyle= UIActivityIndicatorViewStyleGray;
//                [cell.profileButton addSubview:activityIndicator];
//                [activityIndicator release];
                //[self startIconDownload:annotation..user.imgURL:indexPath:1];
                imgView.image = [UIImage imageNamed:@"profile.png"];
            }
            else
            {
                
                imgView.image = [imageCaches imageFromKey:photodata.user.imgURL];
            }
            customPinView.leftCalloutAccessoryView = imgView;
            //
            customPinView.pinColor = MKPinAnnotationColorPurple;
            customPinView.animatesDrop = YES;
            customPinView.canShowCallout = YES;
            
			//NSLog(@"%@",annotation);
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
    PDVC1.delegate = self;
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

-(void) getFeedDataArray:(int)_tab
{
	
	//NSMutableArray *array;
	    
}

-(IBAction)buttonPressed:(id)sender {
	int tagId = [(UIButton *)sender tag];
    [commonUsedMethods setPhotoIndexToDelete:[NSString stringWithFormat:@"%d",tagId]];
    photoDetailViewController    *PDVC = [[photoDetailViewController alloc] initWithNibName:@"photoDetailViewController" bundle:nil withPhoto:[dataArray objectAtIndex:tagId]];
    PDVC.delegate = self;
    [self.navigationController pushViewController:PDVC animated:YES];
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


-(void) startGettingGPXPoint:(BOOL)booValue
{
  //  isPull = booValue;
    if(!booValue)
        [[GPS_Object sharedInstance] startUpdatingLocating:self];
    else
        [self newGPXPoints:[NSNumber numberWithBool:booValue]:self.currentLocation];
    
}
-(void) syncOnThreadAction:(BOOL)_isPull
{
    
	overlay = [[SingletonClass sharedInstance] getOverlay];
	[overlay setDelegate:self];
    if(reqType == 2)
        [overlay getUserSearchData:[requestStringURLs getUserSearchRequest:searchbar.text:_isPull]:_isPull];
   
}

#pragma mark ParserProtocolDelegate
-(void) loginResponse:(NSNumber *)_value
{
	[overlay dismiss];
	if([_value intValue] == 1)
	{
        FeedData *feed = [[DataModel getDataInDictionary:3] objectAtIndex:0];
        self.dataArray = feed.photoArray;
        [self.mapView removeAnnotations:self.mapView.annotations];
        [self.mapView addAnnotations:self.dataArray];
	}
}
-(void) hasPullNewData:(NSMutableArray *)_array
{
   
    
}
-(void) errorResponseData:(NSDictionary *)_dictionary
{
	[overlay dismiss];
    [self loadAlertView:@"":[_dictionary valueForKey:@"message"]];
}

-(void) userFeedData:(NSDictionary *)_dictionary
{
	[overlay dismiss];
	//reqType = 
    if([_dictionary valueForKey:@"status"] && [[_dictionary valueForKey:@"status"] isEqualToString:@"OK"])
    {
        
    } 
	else  if([_dictionary valueForKey:@"status"] && [[_dictionary valueForKey:@"status"] isEqualToString:@"ERROR"])
    {
        NSMutableDictionary *errorDic = [[_dictionary valueForKey:@"errors"] objectAtIndex:0];
        [self loadAlertView:@"":[errorDic valueForKey:@"message"]];
        
        
    }
}
-(void) ParserArraylist:(NSMutableArray *) _array
{
    [overlay dismiss];
    //[self.mapView removeAnnotations:self.mapView.annotations]; // remove any annotations that exist
    FeedData *feed = [_array objectAtIndex:0];
    if(!searching)
    {
//         self.dataArray = feed.photoArray;
//         [self.mapView addAnnotations:self.dataArray];
        
        [self.mapView addAnnotations:[self FilterExsistingFeedsWithDataArray:[self FilterPhotoDataWithDate:feed.photoArray]]];
        
    }
    else
    {
        
        self.searchArray = feed.photoArray;
        if([self.searchArray count] > 0)
        {
            [self.mapView removeAnnotations:self.mapView.annotations];
            [self.mapView addAnnotations:self.searchArray];
            [self gotoLocation];
        }
        else
        {
            searchbar.text = @"";
            [AppDelegate showAlertView:@"No data found"];
            [self CancelSearchbar];
        }
        
    }
    //[self getLocationFromAddressString];
}


-(NSMutableArray *)FilterPhotoDataWithDate:(NSMutableArray *)_array
{
    NSMutableArray *filterArray = [[NSMutableArray alloc] init];
    
   
    NSDateFormatter* df = [[[NSDateFormatter alloc]init] autorelease];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [df setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    
    for(PhotoData *photo in _array)
    {
        NSLog(@"Date : %@",photo.createdDate);
        NSDate* date1 = [df dateFromString:photo.createdDate];
        NSTimeInterval delta = [[NSDate date] timeIntervalSinceDate:date1];
        if(delta <= MONTH)
        {
            [filterArray addObject:photo];
        }
    }
    

    
    return filterArray;
    
}

-(NSMutableArray *)FilterExsistingFeedsWithDataArray:(NSMutableArray *)_array
{
    NSMutableArray *filterArray = [[NSMutableArray alloc] init];
    BOOL success = FALSE;
    //FeedData *feed =     [self.dataArray objectAtIndex:0];
    //FeedData *tempFeed = [_array objectAtIndex:0];
    NSMutableSet *set = [NSMutableSet setWithArray:self.dataArray];
    for (id arrayItem in _array)//tempFeed.photoArray)
    {
        id setItem = [[set filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"iden.intValue = %d", [[arrayItem valueForKey:@"iden"] intValue]]] anyObject];
        if (setItem != nil)
        {
            [set removeObject:setItem];
            [set addObject:arrayItem];
        }
        else
        {
            success = TRUE;
            [set addObject:arrayItem]; 
            [filterArray addObject:arrayItem];
        }
    }
    if(success)
    {
        self.dataArray =  (NSMutableArray *)[set allObjects];
        NSLog(@"WOW-->photo is now %d %d",[set count],[self.dataArray count]);
        // [array replaceObjectAtIndex:0 withObject:feed];
        FeedData *feed = [[DataModel getDataInDictionary:10] objectAtIndex:0];
        NSMutableArray *arr = [[NSMutableArray alloc] initWithObjects:feed, nil];
        feed.photoArray = self.dataArray;
        [DataModel setDataInDictionary:arr:10];
        [arr release];
    }
    
    return filterArray;
}

#pragma mark clientProtocolDelegate

-(void) notfiyResponse:(NSNumber *)_value
{
	
	[overlay dismiss];
	[self loadAlertView:@"Sorry" :@"Internet Connection not available"];
}

#pragma mark GPXPointDelegate
-(void) newGPXPoints:(NSNumber*)_boolValue:(CLLocation *)_newlocation
{
    if([_boolValue boolValue])
    {
        self.currentLocation = _newlocation;
        NSLog(@"Here GPX are now %@",currentLocation);
        [self gotoLocation];
        overlay = [[SingletonClass sharedInstance] getOverlay];
        [overlay setDelegate:self];
        [overlay getNearByMapData:[requestStringURLs getUserNearByRequest:self.currentLocation:FALSE :0]:isPull];
        
    }
    else
    {
        [overlay dismiss];
        overlay.delegate=nil;
        [self loadAlertView:@"":@"Either location service is disable or issue in recognizing your location"];
        
    }
    
}
- (void)viewDidUnload
{
    self.mapAnnotations = nil;
    
    self.mapView = nil;
}

- (void)dealloc {
   	[searchbar release];
	[dataArray release];
    [currentLocation release];
    [GpxObject release];
    [searchArray release];
    [imageDownloadsInProgress release];
    [super dealloc];
}

-(void) getLocationFromAddressString 
{
    
    NSMutableArray *array;
    if(!searching)
        array = self.dataArray;
    else
        array = self.searchArray;
    for (int i = 0 ; i< [array count]; i++) {
        PhotoData *photo = [array objectAtIndex:i];
       // locationData *loc = photo.location;
        if(photo.location &&(!photo.location.latitude && !photo.location.longitude) && photo.location.locName)
        {
            /*
        IconDownloader *marker = [imageDownloadsInProgress objectForKey:[NSString stringWithFormat:@"%d",photo.iden]];
        if(!marker)
         {
             marker = [[IconDownloader alloc] init];
             marker.photodata = photo;
             marker.delegate = self;
             [imageDownloadsInProgress setObject:marker forKey:[NSString stringWithFormat:@"%d",photo.iden]];
             [marker fetchPointFromAddress];
             [marker release];
         }*/
        }
    }
}

#pragma mark locationPointGetter
-(void) locationFound
{
    if(!searching)
    {
       [self.mapView addAnnotations:self.dataArray];
    }
    else
    {
        [self gotoLocation]; 
        [self.mapView addAnnotations:self.searchArray]; 
    }
}


@end
