//
//  dataSelectViewController.m
//  Lobbyfriends
//
//  Created by Awais Ahmad Qureshi on 5/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DataSelecterViewController.h"
#import "editPetProfileCell.h"
#import "petsObject.h"
#import "DataModel.h"
#import "userProfile.h"
#import "commonUsedMethods.h"
#import "headerfiles.h"

@implementation DataSelecterViewController
@synthesize dataTable;
@synthesize delegate;
@synthesize parentClassIndex;
@synthesize eventTitleSearchBar;
@synthesize books;
@synthesize sections;


// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    self.sections = [[NSMutableDictionary alloc] init];
    eventTitleSearchBar.tintColor=[commonUsedMethods getNavTintColor];
    [self.dataTable setBackgroundColor:[UIColor clearColor]];
   
}
-(void) setDetailArray:(NSIndexPath *)_indexPath
{
    
     parentClassIndex = _indexPath;
    self.title = @"Kinds";
    [self.dataTable scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO]; 
   
    NSString *kindString = NSLocalizedStringFromTable(@"KIND",@"AllPet_kind", @"PET_KIND");
    NSLog(@"%@",kindString);
    self.books = [NSArray  arrayWithArray:[kindString componentsSeparatedByString:@","]];
    NSLog(@"array length is %d ",[books count]);
    [self configureSections];
    [self.dataTable reloadData];
}
- (void)configureSections {
	
    BOOL found;
    [self.sections removeAllObjects];
    // Loop through the books and create our keys
    
    for (NSString *str in self.books)
    {        
        NSString *c = [str substringToIndex:1];
        
        found = NO;
        
        for (NSString *str in [self.sections allKeys])
        {
            if ([str isEqualToString:c])
            {
                found = YES;
            }
        }
        
        if (!found)
        {     
            [self.sections setValue:[[NSMutableArray alloc] init] forKey:c];
        }
    }
     
    // Loop again and sort the books into their respective keys
    for (NSString  *str in self.books)
    {
        [[self.sections objectForKey:[str substringToIndex:1]] addObject:str];
    }  
    // Loop again and sort the books into their respective keys
   
    // Sort each section array
    for (NSString *key in [self.sections allKeys])
    {
        [self.sections setValue:[[self.sections objectForKey:key] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)] forKey:key];
    }    
}

-(void) showBreedForKind:(NSString *)_kind:(NSIndexPath *)_indexPath
{
    NSLog(@"%@",_kind);
    parentClassIndex = _indexPath;
    self.title = @"Breeds";
    NSString *kindString = NSLocalizedStringFromTable([_kind uppercaseString],@"AllPet_kind", @"PET_KIND");
    NSLog(@"%@",kindString);
    self.books = [NSArray  arrayWithArray:[kindString componentsSeparatedByString:@","]];
    NSLog(@"array length is %d ",[books count]);
     [self configureSections];
    [self.dataTable reloadData];

}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    [AppDelegate clearAllCacheImage];
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
#pragma mark Table view methods

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return [[self.sections allKeys] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{    
    return [[[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return [(NSArray *)[self.sections valueForKey:[[[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section]] count];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
   // NSMutableArray *book = [[self.sections valueForKey:[[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]];

     NSMutableArray *book  = [self.sections valueForKey:[[[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]];
    
    cell.textLabel.text = [book objectAtIndex:indexPath.row];    
   	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	   NSMutableArray *book  = [self.sections valueForKey:[[[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]];
    
    if(delegate && [delegate respondsToSelector:@selector(dataNameDidSelected::)])
		[delegate performSelector:@selector(dataNameDidSelected::) withObject:[book objectAtIndex:indexPath.row] withObject:parentClassIndex];
	    [self.navigationController popViewControllerAnimated:NO];
}
/*
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	if(searching)
		return nil;
	
	NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
    if (sectionTitle == nil) {
        return nil;
    }
	
	
    // Create label with section title
    UILabel *label = [[[UILabel alloc] init] autorelease];
    label.frame = CGRectMake(20, 0, 300, 18);
    label.backgroundColor = [UIColor clearColor];
    *//*  label.textColor = [UIColor colorWithHue:(136.0/360.0)  // Slightly bluish green
     saturation:1.0
     brightness:0.60
     alpha:1.0];*/
	/*
    // label.shadowColor = [UIColor whiteColor];
	label.textColor=[UIColor whiteColor];
    //  label.shadowOffset = CGSizeMake(0.0, 1.0);
    label.font = [UIFont boldSystemFontOfSize:17];
    label.text = sectionTitle; 
	
    // Create header view and add label as a subview
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 18)];
	//view.backgroundColor=[UIColor darkGrayColor];
	view.backgroundColor =[commonUsedMethods getNavTintColor];
    [view autorelease];
    [view addSubview:label];
    return view;  
}
*/

/*
#pragma mark -
#pragma mark Search Bar 

- (void) searchBarTextDidBeginEditing:(UISearchBar *)theSearchBar {
	
	//This method is called again when the user clicks back from the detail view.
	//So the overlay is displayed on the results, which is something we do not want to happen.
	if(searching)
		return;
	
	//Add the overlay view.
	if(ovController == nil)
		ovController = [[OverlayViewController alloc] initWithNibName:@"OverlayView" bundle:[NSBundle mainBundle]];
	
	//CGFloat yaxis = self.navigationController.navigationBar.frame.size.height;
	CGFloat width = self.view.frame.size.width;
	CGFloat height = self.view.frame.size.height;
	
	//Parameters x = origion on x-axis, y = origon on y-axis.
	CGRect frame = CGRectMake(0, 0, width, height);
	ovController.view.frame = frame;	
	ovController.view.backgroundColor = [UIColor grayColor];
	ovController.view.alpha = 0.5;
	
	//ovController.rvController = self;
	
	//[self.dataTable insertSubview:ovController.view aboveSubview:self.parentViewController.view];
	
	searching = YES;
	letUserSelectRow = NO;
	self.dataTable.scrollEnabled = NO;
	
	//Add the done button.
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] 
											   initWithBarButtonSystemItem:UIBarButtonSystemItemDone 
											   target:self action:@selector(doneSearching_Clicked:)] autorelease];
	
	//searchDone.hidden=NO;
}

- (void)searchBar:(UISearchBar *)theSearchBar textDidChange:(NSString *)searchText {
	
	//Remove all objects first.
	//NSLog(@"%d",[copyListOfItems count]);
    
	
	if([searchText length] > 0) {
		
		[ovController.view removeFromSuperview];
		searching = YES;
		letUserSelectRow = YES;
		self.dataTable.scrollEnabled = YES;
		[self searchTableView];
	}
	else {
		
		[self.dataTable insertSubview:ovController.view aboveSubview:self.parentViewController.view];
		
		searching = NO;
		letUserSelectRow = NO;
		self.dataTable.scrollEnabled = NO;
	}
	
	[self.dataTable reloadData];
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)theSearchBar {
	
	[theSearchBar resignFirstResponder];
	[self searchTableView];
	
}

- (void) searchTableView {
	
	[copyListOfItems removeAllObjects];
	NSString *searchText = eventTitleSearchBar.text;
	NSMutableArray *searchArray = [[NSMutableArray alloc] init];
	
	for (NSDictionary *dictionary in actualList)
	{
		NSArray *array = [dictionary objectForKey:@"Countries"];
		[searchArray addObjectsFromArray:array];
	}
	//	NSLog(@"%d",[searchArray count]);
	
	for (int counter=0;counter<[searchArray count];counter++)
	{
		ProductObject *s=[searchArray objectAtIndex:counter];
		NSString *sTemp=[s ProductName];
		NSRange titleResultsRange = [sTemp rangeOfString:searchText options:NSCaseInsensitiveSearch];
		
		if (titleResultsRange.length > 0)
			[copyListOfItems addObject:[searchArray objectAtIndex:counter]];
	}
	NSLog(@"total search found are %d",[copyListOfItems count]);
	
	[searchArray release];
	searchArray = nil;
}

- (void) doneSearching_Clicked:(id)sender {
	
	eventTitleSearchBar.text = @"";
	[eventTitleSearchBar resignFirstResponder];
	self.navigationItem.rightBarButtonItem=nil;
	letUserSelectRow = YES;
	searching = NO;
	//self.navigationItem.rightBarButtonItem = nil;
	//searchDone.hidden=YES;
	self.dataTable.scrollEnabled = YES;
	
	[ovController.view removeFromSuperview];
	[ovController release];
	ovController = nil;
	
	[self.dataTable reloadData];
}
*/

- (void)dealloc {
	delegate =nil;
    [sections release];
    [eventTitleSearchBar release];
    [parentClassIndex release];
	[dataTable release];
    [books release];
    [sections release];
    [super dealloc];
}


@end
