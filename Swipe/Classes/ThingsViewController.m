//
//  ThingsViewController.m
//  Posterboard
//
//  Created by Apptellect5 on 9/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ThingsViewController.h"
#import "commonUsedMethods.h"
#import "PageViewController.h"
#import "headerfiles.h"


@implementation ThingsViewController

@synthesize tTableView,tSearchBar;
@synthesize dataArray,searchArray,selectedThings;
@synthesize myTextField;
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
    [tTableView release];
   // [tSearchBar release];
    [dataArray release];
    [searchArray release];
    [selectedThings release];
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
    isSearching = FALSE;
    
    dataArray = [[NSMutableArray alloc] init];//WithArray:[NSArray arrayWithObjects:@"Announcements", @"Business", @"Classifieds", @"Construction", @"Crime", @"Entertainment",@"Events", @"Health", @"Lifestyle",@"Nightlife", @"Odd news",@"Other news", @"Real estate",@"Restaurants", @"Science", @"Sports", @"Tech",@"Traffic",@"Weather",nil]];
    searchArray = [[NSMutableArray alloc] init];//WithCapacity:[dataArray count]];
    selectedThings = [[NSMutableArray alloc] init];//WithCapacity:[dataArray count]];
    //[tTableView reloadData];
    [self syncOnThreadAction];
    self.navigationItem.title = @"Things";
    tSearchBar.searchBar.tintColor = [commonUsedMethods getNavTintColor];
    [Font_size customSearchBarBackground:tSearchBar.searchBar];
    
    
    // New navigation and button code eith effects
    
//    UINavigationItem *item = [self.navigationController.navigationBar.items objectAtIndex:0];
    UINavigationItem *item = self.navigationItem;
    item.titleView =  [commonUsedMethods navigationlogoView];
    
    item.rightBarButtonItem = [commonUsedMethods navigationButtonWithText:@"Done":FALSE];
    UIButton* rightButton = (UIButton*)item.rightBarButtonItem.customView;
    [rightButton addTarget:self action:@selector(UpdateButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    
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
    
    
    // navigation right button
    UIImage *image=[UIImage imageNamed:@"done.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.bounds = [Font_size getNavRightButtonFrame];    
    [button setBackgroundImage:image forState:UIControlStateNormal];
    UIImage *image3=[UIImage imageNamed:@"done_selected.png"];
    [button setBackgroundImage:image3 forState:UIControlStateSelected];
    [button addTarget:self action:@selector(UpdateButtonPressed:) forControlEvents:UIControlEventTouchUpInside];    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = barButtonItem;
    [barButtonItem release];
     */
     
}

-(void) backButtonMethod
{
    [self.navigationController popViewControllerAnimated:YES];
} 
-(IBAction) UpdateButtonPressed:(id)sender
{
    if([selectedThings count] > 0)
    {
        NSString *things = @"";
        
        for(int i=0;i<[selectedThings count];i++)
        {
            ThingsData *thing = [selectedThings objectAtIndex:i];
            if(i==0)
               things = thing.title;
            else
                things = [things stringByAppendingString:[NSString stringWithFormat:@",%@",thing.title]];
        }
        
        if( delegate && [delegate respondsToSelector:@selector(ThingsViewResponse:)])
            [delegate performSelector:@selector(ThingsViewResponse:) withObject:things];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
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


-(void) syncOnThreadAction
{
    
    
	overlay = [[SingletonClass sharedInstance] getOverlay];
	[overlay setDelegate:self];
	
    //[[GPS_Object sharedInstance] startUpdatingLocating:self]; 
//    [self performSelector:@selector(searchLocation) withObject:nil afterDelay:0.2];
    
    [overlay getThingsTagsRequest:[self getThingsUrl]];
    
}

-(NSString *) getThingsUrl
{
    
    tokeInfo *tokeninfo = [[SingletonClass sharedInstance] getTokenInformation];
    NSMutableString *url = [[[NSMutableString alloc] init] autorelease];
    [url setString:kServerIp];
    
	[url appendString:@"/tags?"];
    
    [url appendString:[NSString stringWithFormat:@"&access_token=%@",tokeninfo.accessToken]];
    
    url = [[url stringByReplacingOccurrencesOfString:@" " withString:@"%20"] mutableCopy];
    NSLog(@"%@",url);
    return url;
}


#pragma mark Parser Delegate

-(void) ParserArraylist:(NSMutableArray *) _array
{
   [overlay dismiss];
    dataArray = [_array copy];
    [tTableView reloadData];
    
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
	
    if(tableView == self.searchDisplayController.searchResultsTableView)
        return [searchArray count];
    else
        return [dataArray count]+1;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath  
{
    static NSString *kCellID = @"cellID";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellID] autorelease];
		//cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	
	/*
	 If the requesting table view is the search display controller's table view, configure the cell using the filtered content, otherwise use the main list.
	 */
	ThingsData *product = nil;
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        NSLog(@"%@",[searchArray objectAtIndex:0]);
        product = [searchArray objectAtIndex:indexPath.row];
        for(ThingsData *str in selectedThings)
        {
            if([product.title isEqualToString:str.title])
            {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            else
            {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            
        }
    }
	else
	{
        if(indexPath.row == [dataArray count])
        {
            cell.textLabel.text = @"other";
        }
        else
        {
            product = [dataArray objectAtIndex:indexPath.row];
            for(ThingsData *str in selectedThings)
            {
                if([product.title isEqualToString:str.title])
                {
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                }
                else
                {
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
                
            }
        }
            
    }
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
    if(product != nil)
        cell.textLabel.text = product.title;
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tTableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
    ThingsData *product = nil;
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        product = [searchArray objectAtIndex:indexPath.row];
        UITableViewCell *thisCell = [tableView cellForRowAtIndexPath:indexPath];
        
        
        if (thisCell.accessoryType == UITableViewCellAccessoryNone) 
        {
            thisCell.accessoryType = UITableViewCellAccessoryCheckmark;
            [selectedThings addObject:product];
        }
        else
        {
            thisCell.accessoryType = UITableViewCellAccessoryNone;
            for(int i = 0; i < [selectedThings count]; i++)
            {
                ThingsData *temp = [selectedThings objectAtIndex:i];
                if([product.title isEqualToString:temp.title])
                    [selectedThings removeObjectAtIndex:i];
            }
            
        }
    }
	else
	{
        if(indexPath.row == [dataArray count])
        {
            UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Tag name" message:@"this gets covered" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
            myTextField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 45.0, 260.0, 25.0)];
            [myTextField setBackgroundColor:[UIColor whiteColor]];
            myTextField.borderStyle = UITextBorderStyleRoundedRect;
            [myAlertView addSubview:myTextField];
            myAlertView.tag = 1;
            [myAlertView show];
            [myAlertView release];
        }
        else
        {
            product = [dataArray objectAtIndex:indexPath.row];
            UITableViewCell *thisCell = [tableView cellForRowAtIndexPath:indexPath];
            
            
            if (thisCell.accessoryType == UITableViewCellAccessoryNone) 
            {
                thisCell.accessoryType = UITableViewCellAccessoryCheckmark;
                [selectedThings addObject:product];
            }
            else
            {
                thisCell.accessoryType = UITableViewCellAccessoryNone;
                for(int i = 0; i < [selectedThings count]; i++)
                {
                    ThingsData *temp = [selectedThings objectAtIndex:i];
                    if([product.title isEqualToString:temp.title])
                        [selectedThings removeObjectAtIndex:i];
                }
            }
        }
        
    }


    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    return  45;
}

#pragma mark Alert view delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        
        NSLog(@"Cancel pressed");
    }
    else
    {
        NSLog(@"ok pressed");
        if(alertView.tag == 1)
        {
            if([myTextField.text length] > 0)
            {
                ThingsData *data = [[ThingsData alloc] init];
                data.iden = 123;
                data.title = myTextField.text;
                data.counter = 0;
                if( delegate && [delegate respondsToSelector:@selector(ThingsViewResponse:)])
                    [delegate performSelector:@selector(ThingsViewResponse:) withObject:data.title];
            
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }
}

#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

#pragma mark -
#pragma mark Content Filtering

- (void)filterContentForSearchText:(NSString*)searchText
{
	/*
	 Update the filtered array based on the search text and scope.
	 */
	
	[searchArray removeAllObjects]; // First clear the filtered array.
	
	/*
	 Search the main list for products whose type matches the scope (if selected) and whose name matches searchText; add items that match to the filtered array.
	 */
	for (ThingsData *product in dataArray)
	{
		
			NSComparisonResult result = [product.title compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
            if (result == NSOrderedSame)
			{
				[searchArray addObject:product];
            }
		
	}
}


@end
