//
//  SearchResultViewController.m
//  Posterboard
//
//  Created by Apptellect5 on 9/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SearchResultViewController.h"
#import "headerfiles.h"
#import "commonUsedMethods.h"
#import "shareViewController.h"
#import "PageViewController.h"
#import "headerfiles.h"
#import "LocationCell.h"
#import "LocationSearchCell.h"

@implementation SearchResultViewController

@synthesize nbTableView;
@synthesize currentLocation,dataArray,searchArray,strText;
@synthesize delegate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    [AppDelegate clearAllCacheImage];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    
//    nbSearchBar.searchBar.tintColor = [commonUsedMethods getNavTintColor];
//    [Font_size customSearchBarBackground:nbSearchBar.searchBar];
    
 //   searchArray = [[NSMutableArray alloc] init];
    self.navigationItem.title = @"Search Results";
    
    
    // New navigation and button code eith effects
    
//    UINavigationItem *item = [self.navigationController.navigationBar.items objectAtIndex:0];
    UINavigationItem *item = self.navigationItem;
    item.titleView =  [commonUsedMethods navigationlogoView];
    
//    item.rightBarButtonItem = [commonUsedMethods navigationButtonWithText:@"Done":FALSE];
//    UIButton* rightButton = (UIButton*)item.rightBarButtonItem.customView;
//    [rightButton addTarget:self action:@selector(UpdateButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    
    item.leftBarButtonItem = [commonUsedMethods navigationButtonWithText:@"Back":TRUE];
    UIButton* leftButton = (UIButton*)item.leftBarButtonItem.customView;
    [leftButton addTarget:self action:@selector(backButtonMethod) forControlEvents:UIControlEventTouchUpInside];
    
    // code end
    /*
    //navigation back button
    UIImage *image1=[UIImage imageNamed:@"back.png"];
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.bounds = [Font_size getNavRightButtonFrame];     
    [button1 setBackgroundImage:image1 forState:UIControlStateNormal];
    UIImage *image2=[UIImage imageNamed:@"back_selected.png"];
    [button1 setBackgroundImage:image2 forState:UIControlStateSelected];
    [button1 addTarget:self action:@selector(backButtonMethod) forControlEvents:UIControlEventTouchUpInside];    
    UIBarButtonItem *barButtonItem1 = [[UIBarButtonItem alloc] initWithCustomView:button1];
    self.navigationItem.leftBarButtonItem = barButtonItem1;
    [barButtonItem1 release];
     */
    
    
//    // navigation right button
//    UIImage *image=[UIImage imageNamed:@"mylocation.png"];
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.bounds = CGRectMake(0, 0, 35, 30);//[Font_size getNavRightButtonFrame];    
//    [button setBackgroundImage:image forState:UIControlStateNormal];
//    
//    [button addTarget:self action:@selector(locationButtonPressed:) forControlEvents:UIControlEventTouchUpInside];    
//    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
//    self.navigationItem.rightBarButtonItem = barButtonItem;
//    [barButtonItem release];
    
}

-(void) backButtonMethod
{
    [self.navigationController popViewControllerAnimated:YES];
} 
//-(IBAction) locationButtonPressed:(id)sender
//{
//    
//    [self syncOnThreadAction];
//    
//}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
   // [self syncOnThreadAction];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return NO;//(interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) initSearchResultWithSearchText:(NSString *)string :(CLLocation *) loc
{
    strText = [[NSString alloc] initWithString:string];
    currentLocation = loc;
    [self syncOnThreadAction];
}

-(void) searchLocation
{
    NSLog(@"Here GPX are now %@",currentLocation);
    overlay = [[SingletonClass sharedInstance] getOverlay];
    [overlay setDelegate:self];
    [overlay getNearByLocationData:[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/json?location=%f,%f&radius=500&sensor=false&name=%@&key=AIzaSyA_QvWKEompMvFggVyJWS5r7niBdP9LELU",currentLocation.coordinate.latitude,currentLocation.coordinate.longitude,strText] :isPull];
}

#pragma mark GPXPointDelegate
-(void) newGPXPoints:(NSNumber*)_boolValue:(CLLocation *)_newlocation
{
    if([_boolValue boolValue])
    {
        self.currentLocation = _newlocation;
        
    }
    else
    {
       [overlay dismiss];
        overlay.delegate=nil;
        
        
        //[self loadAlertView:@"Either location service is disable or issue in recognizing your location"];
    }
}


-(void) syncOnThreadAction
{
    
	overlay = [[SingletonClass sharedInstance] getOverlay];
	[overlay setDelegate:self];
	    //[[GPS_Object sharedInstance] startUpdatingLocating:self]; 
    [self performSelector:@selector(searchLocation) withObject:nil afterDelay:0.2];
}

#pragma mark Parser Delegate

-(void) ParserArraylist:(NSMutableArray *) _array
{
    [overlay dismiss];
    dataArray = [_array copy];
    [nbTableView reloadData];
    
}

-(void) errorResponseData:(NSDictionary *)_dictionary
{
	[overlay dismiss];
    [self loadAlertView:@"":[_dictionary valueForKey:@"message"]];
}
#pragma mark clientProtocolDelegate

-(void) notfiyResponse:(NSNumber *)_value
{
	
	[overlay dismiss];
	[self loadAlertView:@"Sorry" :@"Internet Connection not available"];
	//[self dataSourceDidFinishLoadingNewData];
	
	
}

-(void)loadAlertView:(NSString *)title :(NSString *)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}



#pragma mark Table view methods

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    
//	return 2;
//}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
        return [dataArray count];
	
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath  
{
    UITableViewCell* rCell = nil;
    

        static NSString *ProfileCellIdentifier = @"NearByLocationCell";
        LocationCell *cell = (LocationCell *) [tableView dequeueReusableCellWithIdentifier:ProfileCellIdentifier];
        if (cell == nil) {
            
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"LocationCell" owner:self options:nil];
            
            for (id currentObject in topLevelObjects){
                if ([currentObject isKindOfClass:[UITableViewCell class]]){
                    cell =  (LocationCell *) currentObject;
                    break;
                }
            }
        } 
        
        NearbyLocationObject *obj = [dataArray objectAtIndex:indexPath.row];
        
        cell.lblLoc_Name.text = obj.loc_name;
        cell.lblLoc_Address.text = obj.loc_vicinity;
        rCell = cell;
    
    
    
    return rCell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.nbTableView deselectRowAtIndexPath:indexPath animated:YES];
    NearbyLocationObject *loc_obj = [dataArray objectAtIndex:indexPath.row];
    if( delegate && [delegate respondsToSelector:@selector(SearchResultResponse:)])
        [delegate performSelector:@selector(SearchResultResponse:) withObject:loc_obj];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    return  50;
}



@end
