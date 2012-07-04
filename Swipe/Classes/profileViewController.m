 //isNotSelf =TRUE;//
//  HomeScreenViewController.m
//  show
//
//  Created by svp on 01/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "profileViewController.h"
#import "TopCustomCell.h"
#import "commonUsedMethods.h"



@implementation profileViewController



 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
 if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
 // Custom initialization
   
 }
 return self;
 }
 


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
       
    UINavigationItem *item = [self.navigationController.navigationBar.items objectAtIndex:0];
    item.title = @"SWIPE";
    
    item.rightBarButtonItem = [commonUsedMethods navigationButtonWithText:@"Add":FALSE];
    UIButton* rightButton = (UIButton*)item.rightBarButtonItem.customView;
    [rightButton addTarget:self action:@selector(syncButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    item.leftBarButtonItem = [commonUsedMethods navigationButtonWithText:@"Back":TRUE];
    UIButton* leftButton = (UIButton*)item.leftBarButtonItem.customView;
    [leftButton addTarget:self action:@selector(backButtonMethod) forControlEvents:UIControlEventTouchUpInside];
}

-(void) backButtonMethod
{
    if([self.navigationController.viewControllers count] > 1)
    {
        [self removeAllCacheImagesFromMemory];
    }
    [self.navigationController popViewControllerAnimated:YES];
} 

-(void) removeAllCacheImagesFromMemory
{
        
}



-(IBAction) settingButtonPressed:(id)sender
{
	
}

/*
-(IBAction) singOutButtonPressed:(id)sender
{ 
    EnvetFinderDelegate *appDelegate = (EnvetFinderDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate logout];
}
*/
-(void)viewWillAppear:(BOOL)animated 
{
    [super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:NO];
}
- (void)viewWillDisappear:(BOOL)animated {
	
    
   
}

-(void) settingForPersonalProfile
{
}



-(void) removeTopTableHeader
{
   
}
-(void) createTableHeader
{
  
}
-(void) addPullViewAtBottom
{
    
  	
}

#pragma mark Delete Photo Delegate

-(void) DeletePhotoResponse:(NSString *)_index
{
  
    
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

	
    return 1;

}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath  {
	
    static NSString *ProfileCellIdentifier = @"TopCustomCell";
    TopCustomCell *cell = (TopCustomCell *) [tableView dequeueReusableCellWithIdentifier:ProfileCellIdentifier];
    if (cell == nil) {
        
        cell = [[[TopCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ProfileCellIdentifier] autorelease];
        
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"TopCustomCell" owner:self options:nil];
        
        for (id currentObject in topLevelObjects){
            if ([currentObject isKindOfClass:[TopCustomCell class]]){
                cell =  (TopCustomCell *) currentObject;
                break;
            }
        }
    } 
    [self dataCellForFeedTab:cell:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	// TO DO	
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
	CGFloat height = 110.0f;
    
}


- (void)doneLoadingTableViewData{
	//  model should call this when its done loading
	//self.dataTable.userInteractionEnabled=TRUE;
	[self dataSourceDidFinishLoadingNewData];
}
@end
