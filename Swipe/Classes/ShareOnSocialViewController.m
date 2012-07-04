//
//  ShareOnSocialViewController.m
//  Posterboard
//
//  Created by Apptellect5 on 9/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ShareOnSocialViewController.h"
#import "SharingSetupViewController.h"
#import "headerfiles.h"
#import "domainClasses.h"
#import "commonUsedMethods.h"
#import "ShareButtonCell.h"
#import "PhotoData.h"
#import "headerfiles.h"
#import "domainClasses.h"
#import "commonUsedMethods.h"
#import "SetupSharingCell.h"
#import "commonUsedMethods.h"
#import "SA_OAuthTwitterEngine.h"
#import "OAToken.h"
#import "EnvetFinderDelegate.h"

@implementation ShareOnSocialViewController

@synthesize tableView;
@synthesize photoData;
@synthesize _engine,fmgr;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withPhotoData:(PhotoData *)_photoData
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.photoData = _photoData;
    }
    return self;
}

- (void)dealloc
{
    [tableView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    [AppDelegate clearAllCacheImage];
    // Release any cached data, images, etc that aren't in use.
}

-(void) backButtonMethod
{
    [self.navigationController popViewControllerAnimated:YES];
} 
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    // New navigation and button code eith effects
    
//    UINavigationItem *item = [self.navigationController.navigationBar.items objectAtIndex:0];
    UINavigationItem *item = self.navigationItem;
    item.titleView =  [commonUsedMethods navigationlogoView];
    
    item.leftBarButtonItem = [commonUsedMethods navigationButtonWithText:@"Back":TRUE];
    UIButton* rightButton = (UIButton*)item.leftBarButtonItem.customView;
    [rightButton addTarget:self action:@selector(backButtonMethod) forControlEvents:UIControlEventTouchUpInside];
    
    // code end
    
    /*
    self.navigationItem.titleView =  [commonUsedMethods navigationlogoView];
    UIImage *image=[UIImage imageNamed:@"back.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.bounds = CGRectMake(0, 0, 72, 30);//[Font_size getNavRightButtonFrame];     
    [button setBackgroundImage:image forState:UIControlStateNormal];
    UIImage *image1=[UIImage imageNamed:@"back_selected.png"];
    [button setBackgroundImage:image1 forState:UIControlStateSelected];
    //UIImage *image=[UIImage imageNamed:@"settings.png"];
    //UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    //button.bounds = [Font_size getNavRightButtonFrame];     
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backButtonMethod) forControlEvents:UIControlEventTouchUpInside];    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = barButtonItem;
    [barButtonItem release];
     */
    
    objectsCount = [[NSMutableArray alloc] init];
    if([commonUsedMethods getFacebookConfigured])
        [objectsCount addObject:@"Facebook"];
    if([commonUsedMethods getTwitterConfigured])
        [objectsCount addObject:@"Twitter"];
    
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
	return 2;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
    if(section == 0)
        return [objectsCount count];
    else
        return 1;
	
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath  
{
    
    UITableViewCell *rcell = nil;
    
    if(indexPath.section == 0 && [objectsCount count] > 0)
    {
        static NSString *ProfileCellIdentifier = @"ShareViewCell";
        ShareButtonCell *cell = (ShareButtonCell *) [self.tableView dequeueReusableCellWithIdentifier:ProfileCellIdentifier];
        if (cell == nil)
        {
            
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ShareButtonCell" owner:self options:nil];
            
            for (id currentObject in topLevelObjects){
                if ([currentObject isKindOfClass:[UITableViewCell class]]){
                    cell =  (ShareButtonCell *) currentObject;
                    break;
                }
            }
        }
        cell.lblTitle.text = [objectsCount objectAtIndex:indexPath.row];
        [cell.btnShare addTarget:self action:@selector(ButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        cell.btnShare.tag = indexPath.row;
        rcell = cell;
        rcell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else if(indexPath.section == 1)
    {
        static NSString *hlCellID = @"hlCellID";
        UITableViewCell *hlcell = [tableView dequeueReusableCellWithIdentifier:hlCellID];
        if(hlcell == nil) {
            hlcell =  [[UITableViewCell alloc] 
                       initWithStyle:UITableViewCellStyleDefault reuseIdentifier:hlCellID];
            hlcell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            hlcell.textLabel.text = @"Setup sharing";
            hlcell.textLabel.font = [UIFont boldSystemFontOfSize:18];
            
        }
        rcell = hlcell;
    }
    
    
    return rcell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 0)
        return;
    else if(indexPath.section == 1)
    {
        if(indexPath.row == 0)
        {
            SharingSetupViewController *svc = [[SharingSetupViewController alloc] initWithNibName:@"SharingSetupViewController" bundle:nil];
            svc.delegate = self;
            [self.navigationController pushViewController:svc animated:YES];
        }
    }
        
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    return  45;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(15, 0, 290, 50)];
    view.backgroundColor = [UIColor clearColor];
    if(section == 0 && [objectsCount count] == 0)
    {
        UILabel *lbl = [[[UILabel alloc] init] autorelease];
        lbl.frame = view.frame;//CGRectMake(15, 5, 290, 90);
        
        lbl.textColor = [UIColor grayColor];
        lbl.numberOfLines = 2;
        [lbl setFont:[UIFont fontWithName:@"Helvetica" size:14]];
        lbl.textAlignment = UITextAlignmentCenter;
        lbl.shadowColor = [UIColor whiteColor];
        lbl.shadowOffset = CGSizeMake(0.0, 1.0);
        lbl.backgroundColor = [UIColor clearColor];
        [view addSubview:lbl];
        lbl.text = [NSString stringWithFormat:@"You haven't set up any sharing service.\nTap below to get started."];
    }
    return view;
}


-(IBAction)ButtonPressed:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSString *str = [objectsCount objectAtIndex:button.tag];
    NSLog(@"%@ pressed",str);
    overlay = [[SingletonClass sharedInstance] getOverlay];
	[overlay setDelegate:self];
    [overlay pleaseWaitOverlay];
    if([str isEqualToString:@"Facebook"])
    {
        socailObject = [[SingletonClass sharedInstance] getSocialObject];
        socailObject.delegate= self;
        [socailObject facebookConnectMethod];
        [socailObject postSocialData:self.photoData:NO:YES];
    }
    else if([str isEqualToString:@"Twitter"])
    {
        if(![socailObject TwitterHasKey]){
            
            socailObject.delegate= self;
            [socailObject loginTwitter];
        }
        socailObject = [[SingletonClass sharedInstance] getSocialObject];
        [socailObject postSocialData:self.photoData:YES:NO];
    }
    
    [self performSelector:@selector(removeOverlayViewReturnBack) withObject:nil afterDelay:2.0];
}

-(void)removeOverlayViewReturnBack
{
    overlay.delegate = nil;
    [overlay dismiss];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark Setup Sharing delegate

-(void) SetupSharingResponse:(NSMutableArray *)_object
{

    NSLog(@"%d",[_object count]);
    if([objectsCount count] > 0)
        [objectsCount removeAllObjects];
    objectsCount = [_object copy];
    [tableView reloadData];
}

@end
