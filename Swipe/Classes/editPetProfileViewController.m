//
//  editPetProfileViewController.m
//  Petstagram
//
//  Created by Awais Ahmad Qureshi on 5/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "editPetProfileViewController.h"
#import "DataModel.h"
#import "userProfile.h"
#import "petsObject.h"
#import "editPetViewController.h"
#import "headerfiles.h"
#import "editPetProfileCell.h"
#import "SingletonClass.h"
#import "EnvetFinderDelegate.h"
#import "AboutViewController.h"
#import "socailConnectObject.h"
#import "SA_OAuthTwitterController.h"
#import "SliderCell.h"


@implementation editPetProfileViewController
@synthesize settingTable;
@synthesize tableHeaderView;
@synthesize userProfileImage;
@synthesize  userName;
@synthesize userprofile;
@synthesize profileActivity;
@synthesize picDownload;
@synthesize navigationTiteView;
@synthesize navProfileImage,navUserName;
@synthesize newPhoto;
@synthesize segmentedControl;
@synthesize datePicker;
@synthesize cellSlider;
// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withProfileData:(userProfile *)_profile{
 self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
 if (self) {
 // Custom initialization.
       self.userprofile = [_profile copyWithZone:nil];
 }
 return self;
 }
 


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	//self.title = @"Edit Profile";
    updateType = 0;
    NewPush = FALSE;
    resingKeyBoard=FALSE;
    reqType = 0;
    self.segmentedControl.tintColor = [commonUsedMethods getNavTintColor];
	//dataArray = [[NSMutableArray alloc] init];
	//self.settingTable.backgroundColor = [UIColor clearColor];
     
    
    // New navigation and button code eith effects
    
    NSLog(@"%d",[self.navigationController.viewControllers count]);
    UINavigationItem *item = self.navigationItem;
   // item.titleView =  [commonUsedMethods navigationlogoView];
    
    item.rightBarButtonItem = [commonUsedMethods navigationButtonWithText:@"Update":FALSE];
    UIButton* rightButton = (UIButton*)self.navigationItem.rightBarButtonItem.customView;
    [rightButton addTarget:self action:@selector(UpdateButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    
    item.leftBarButtonItem = [commonUsedMethods navigationButtonWithText:@"Back":TRUE];
    UIButton* leftButton = (UIButton*)item.leftBarButtonItem.customView;
    [leftButton addTarget:self action:@selector(backButtonMethod) forControlEvents:UIControlEventTouchUpInside];
    
    // code end
    
    
    /*
    UIImage *image=[UIImage imageNamed:@"update.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image2=[UIImage imageNamed:@"update_selected.png"];
    [button setBackgroundImage:image2 forState:UIControlStateSelected];
    button.bounds = [Font_size getNavRightButtonFrame];    
    [button setBackgroundImage:image forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(UpdateButtonPressed:) forControlEvents:UIControlEventTouchUpInside];    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = barButtonItem;
    [barButtonItem release];
    
    UIImage *image1=[UIImage imageNamed:@"back.png"];
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.bounds = [Font_size getNavRightButtonFrame];     
    [button1 setBackgroundImage:image1 forState:UIControlStateNormal];
    UIImage *image3=[UIImage imageNamed:@"back_selected.png"];
    [button setBackgroundImage:image3 forState:UIControlStateSelected];
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

-(void)viewWillAppear:(BOOL)animated 
{
    [super viewWillAppear:animated];
    /*
    if(!NewPush)
    {
    dataArray = [DataModel getDataInDictionary:8];
    NSLog(@"%d",[dataArray count]);
    [self createTableHeader];
    [self.settingTable reloadData];
    }
    */
    socailObject = [[SingletonClass sharedInstance ] getSocialObject];
}
 

- (void)viewWillDisappear:(BOOL)animated {
	
	NSLog(@"Now removing view and removing all dictionary contents");
	NSArray *viewControllers = self.navigationController.viewControllers;
	NSLog(@"%d",[viewControllers count]);
	if (viewControllers.count > 1 && [viewControllers objectAtIndex:viewControllers.count-2] == self) 
	{
        NewPush=TRUE;
	} 
	else if ([viewControllers indexOfObject:self] == NSNotFound) {
		
		self.segmentedControl.selectedSegmentIndex = 0;
        NewPush=FALSE;
	}
    else
    {
       // self.segmentedControl.selectedSegmentIndex = 0;
        NewPush=FALSE;
        
    }
}

- (void)hideKeybaordViewIfAny
{	
	if(segmentedControl.selectedSegmentIndex == 0)
    {
        for (int i = 0 ; i < 3 ; i++)
        {
        editPetProfileCell *cell = (editPetProfileCell *) [self.settingTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            [cell.textString resignFirstResponder];
        }
     }
}


-(IBAction) UpdateButtonPressed:(id)sender

{
    [self hideKeybaordViewIfAny];
    for (UIView *view in self.view.subviews){
        if([view isKindOfClass:[UITextField class]])
        {
            UITextField *_textfield = (UITextField *)view;
            [self textFieldShouldReturn:_textfield];
        }
    }
    
          if([self validatePersonalData])
          {
              reqType = 1;
              [self syncOnThreadAction];
          }


}
-(BOOL) validatePersonalData
{
    if(!userprofile.email || [userprofile.email length]==0)
    {
        [self loadAlertView:@"email required"];
        return FALSE;
    }
   /*
    else if(!userprofile.password || [userprofile.password length]==0)
    {
        [self loadAlertView:@"you must enter the password value"];
        return FALSE;
    }*/
    return TRUE;
}

-(void) createNavigationTitleView
{

	 self.navigationItem.titleView =  [commonUsedMethods EditNavigationView];
    // self.navigationItem.titleView = self.navigationTiteView;
    /*
	navUserName.text = userprofile.userName;
	if(userprofile.imgURL && [imageCaches checkCacheImage:userprofile.imgURL])
    {
       [self.navProfileImage setImage:[imageCaches getCacheImage:userprofile.imgURL]];
    }*/
   /* else
    {
        [userProfileImage setImage:[Font_size getPersonShahowImage]];
    }*/
	
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if(segmentedControl.selectedSegmentIndex == 0)
    {
        if([commonUsedMethods getIsFacebookUser])
            return 4;
      return 6;
    }
    else if(segmentedControl.selectedSegmentIndex == 1)
        return 7;
    return 0;
}
// Customize the appearance of table view cells.
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    static NSString *CellIdentifier = @"editPetProfileCell";
    editPetProfileCell *cell = (editPetProfileCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"editPetProfileCell" owner:self options:nil];
        
        for (id currentObject in topLevelObjects){
            if ([currentObject isKindOfClass:[UITableViewCell class]]){
                cell =  (editPetProfileCell *) currentObject;
                break;
            }
        }
    } 
    cell.switchButton.hidden=TRUE;
    cell.toggleSwitch.hidden=TRUE;
    cell.textString.delegate = self;
    cell.profileImgView.image=nil;
    cell.profileImgView.hidden = FALSE;
     cell.textString.returnKeyType = UIReturnKeyDone;
    cell.textString.text=@"";
    cell.textString.secureTextEntry = FALSE;
    cell.textString.placeholder=@"";
     cell.accessoryType = 1;
	
    
    if(segmentedControl.selectedSegmentIndex == 0)
    {
        if([commonUsedMethods getIsFacebookUser])
        {
            if(indexPath.row == 0)
            {   
                //[self createNavigationTitleView];
                cell.labelString.text = @"Full Name";
                cell.textString.placeholder = @"Enter your fullName";
                cell.textString.text = userprofile.userName;
                cell.textString.tag = indexPath.section+indexPath.row;
                cell.textString.enabled = TRUE;
                cell.textString.hidden = FALSE;
                cell.textString.tag = indexPath.row;
                cell.accessoryType = 0; 
                
            }
            
            else  if(indexPath.row == 1)
            {
                cell.labelString.text = @"Email";
                cell.textString.placeholder = @"Enter new email";
                cell.textString.text = userprofile.email;
                // cell.textString.placeholder = @"new email address";
                cell.textString.tag = indexPath.section+indexPath.row;
                cell.textString.enabled = TRUE;
                cell.textString.hidden = FALSE;
                cell.textString.tag = indexPath.row;
                cell.accessoryType = 0; 
            }
            
            else  if(indexPath.row == 2)
            {
                cell.labelString.text = @"Support Notification service";
                cell.textString.hidden = TRUE;
                cell.toggleSwitch.hidden=FALSE;
                [cell.toggleSwitch  addTarget:self action:@selector(toggleSwitchChange:) forControlEvents:UIControlEventValueChanged];
                [cell.toggleSwitch setTag:indexPath.row];
                [cell.toggleSwitch setOn:[commonUsedMethods getSupportNotification]];
                cell.accessoryType = 0;
                
            }
            else  if(indexPath.row == 3)
            {
                cell.labelString.text = @"Comments Notification service";
                cell.textString.hidden = TRUE;
                cell.toggleSwitch.hidden=FALSE;
                [cell.toggleSwitch  addTarget:self action:@selector(toggleSwitchChange:) forControlEvents:UIControlEventValueChanged];
                [cell.toggleSwitch setTag:indexPath.row];
                [cell.toggleSwitch setOn:[commonUsedMethods getCommentNotification]];
                cell.accessoryType = 0;
                
            }
            
        }
        else
        {
            if(indexPath.row == 0)
            {   
                [self createNavigationTitleView];
                cell.labelString.text = @"Full Name";
                cell.textString.placeholder = @"Enter your fullName";
                cell.textString.text = userprofile.userName;
                cell.textString.tag = indexPath.section+indexPath.row;
                cell.textString.enabled = TRUE;
                cell.textString.hidden = FALSE;
                cell.textString.tag = indexPath.row;
                cell.accessoryType = 0; 
                
            }
            
            else  if(indexPath.row == 1)
            {
                cell.labelString.text = @"Email";
                cell.textString.placeholder = @"Enter new email";
                cell.textString.text = userprofile.email;
                // cell.textString.placeholder = @"new email address";
                cell.textString.tag = indexPath.section+indexPath.row;
                cell.textString.enabled = TRUE;
                cell.textString.hidden = FALSE;
                cell.textString.tag = indexPath.row;
                cell.accessoryType = 0; 
            }
            else  if(indexPath.row == 2)
            {
                cell.labelString.text = @"Password";
                cell.textString.placeholder = @"Enter your Password";
                cell.textString.secureTextEntry = TRUE;
                //cell.textString.placeholder = @"**********";
                cell.textString.tag = indexPath.section+indexPath.row;
                cell.textString.enabled = TRUE;
                cell.textString.hidden = FALSE;
                cell.textString.tag = indexPath.row;
                cell.accessoryType = 0; 
            }
            else  if(indexPath.row == 3)
            {
                cell.labelString.text = @"Support Notification service";
                cell.textString.hidden = TRUE;
                cell.toggleSwitch.hidden=FALSE;
                [cell.toggleSwitch  addTarget:self action:@selector(toggleSwitchChange:) forControlEvents:UIControlEventValueChanged];
                [cell.toggleSwitch setTag:indexPath.row];
                [cell.toggleSwitch setOn:[commonUsedMethods getSupportNotification]];
                cell.accessoryType = 0;
                
            }
            else  if(indexPath.row == 4)
            {
                cell.labelString.text = @"Comments Notification service";
                cell.textString.hidden = TRUE;
                cell.toggleSwitch.hidden=FALSE;
                [cell.toggleSwitch  addTarget:self action:@selector(toggleSwitchChange:) forControlEvents:UIControlEventValueChanged];
                [cell.toggleSwitch setTag:indexPath.row];
                [cell.toggleSwitch setOn:[commonUsedMethods getCommentNotification]];
                cell.accessoryType = 0;
                
            }
            else  if(indexPath.row == 5)
            {
                cell.labelString.text = @"Profile photo";
                cell.textString.hidden = TRUE;
                cell.switchButton.hidden=TRUE;
                cell.profileImgView.hidden = FALSE;
                CGRect rect = CGRectMake(170, 5, 70, 70);
                [cell.profileImgView setFrame:rect];
                if(!newPhoto)
                {
                    tokeInfo *tokeninfo = [[SingletonClass sharedInstance] getTokenInformation];
                    if ([imageCaches imageFromKey:userprofile.imgURL])
                    {
                        [cell.profileImgView setImage:[imageCaches imageFromKey:userprofile.imgURL]];
                    }
                    else if([imageCaches imageFromKey:tokeninfo.imgURL])
                    {
                        
                        [cell.profileImgView setImage:[imageCaches imageFromKey:tokeninfo.imgURL]]; 
                    }
                    else
                    {
                        [cell.profileImgView setImage:[Font_size getPersonShahowImage]];
                    }
                    
                }
                else
                {
                    [cell.profileImgView setImage:self.newPhoto];
                }
            }
        }

    }
    else if(segmentedControl.selectedSegmentIndex == 1)
    {
        
        if(indexPath.row == 0)
        {
                cell.labelString.text = @"Facebook";
                cell.textString.hidden = TRUE;
                cell.toggleSwitch.hidden=FALSE;
                [cell.toggleSwitch  addTarget:self action:@selector(toggleSwitchChange:) forControlEvents:UIControlEventValueChanged];
                [cell.toggleSwitch setTag:indexPath.row];
                [cell.toggleSwitch setOn:[commonUsedMethods getFacebookConfigured]];
//            if([[NSUserDefaults standardUserDefaults] objectForKey:@"AccessToken"])
//                [cell.toggleSwitch setOn:YES];
//            else
//                [cell.toggleSwitch setOn:NO];
                cell.accessoryType = 0;
        }
        else  if(indexPath.row == 1)
        {
            cell.labelString.text = @"Twitter";
            cell.textString.hidden = TRUE;
            cell.toggleSwitch.hidden=FALSE;
            [cell.toggleSwitch  addTarget:self action:@selector(toggleSwitchChange:) forControlEvents:UIControlEventValueChanged];
            [cell.toggleSwitch setTag:indexPath.row];
            [cell.toggleSwitch setOn:[commonUsedMethods getTwitterConfigured]];
//            if(![socailObject TwitterHasKey])
//                [cell.toggleSwitch setOn:YES];
//            else
//                [cell.toggleSwitch setOn:NO];
            cell.accessoryType = 0;
        }
        else  if(indexPath.row == 2)
        {
            cell.labelString.text = @"Auto Registration location";
            cell.textString.hidden = TRUE;
            cell.toggleSwitch.hidden=FALSE;
            [cell.toggleSwitch  addTarget:self action:@selector(toggleSwitchChange:) forControlEvents:UIControlEventValueChanged];
            [cell.toggleSwitch setTag:indexPath.row];
            [cell.toggleSwitch setOn:[commonUsedMethods getAutoRegisterLocationNotification]];
            cell.accessoryType = 0;
            
            
        }
        else  if(indexPath.row == 3)
        {
            static NSString *CellIdentifier = @"sliderCell";
            SliderCell *cell1 = (SliderCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell1 == nil) {
                
                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SliderCell" owner:self options:nil];
                
                for (id currentObject in topLevelObjects){
                    if ([currentObject isKindOfClass:[UITableViewCell class]]){
                        cell1 =  (SliderCell *) currentObject;
                        break;
                    }
                }
            } 
            cell1.lblRadius.text = [commonUsedMethods getDefaultRadius];
            int val = [[commonUsedMethods getDefaultRadius] intValue];
            val = (val - 1500)/100;
            cell1.slider.value = val;
            [cell1.slider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
            cell1.selectionStyle = 0;
            [cell1 setBackgroundColor:[Font_size cellBackgroundColor]];
            cellSlider = cell1;
            return cell1;
        }
        else  if(indexPath.row == 4)
        {
            
            cell.labelString.text =  @"Private Policy"; 
            cell.textString.enabled = FALSE;
            cell.textString.hidden = FALSE;
        }
        else  if(indexPath.row == 5)
        {
            
            cell.labelString.text = @"Terms and Condition";
            cell.textString.enabled = FALSE;
            cell.textString.hidden = FALSE;
        }
        
        else  if(indexPath.row == 6)
        {
            
            cell.labelString.text = @"Logout";
            cell.textString.enabled = FALSE;
            cell.textString.hidden = FALSE;
        }

    }
	cell.selectionStyle = 0;
    // cell.backgroundColor = [UIColor redColor]; //[Font_size cellBackgroundColor];
     [cell setBackgroundColor:[Font_size cellBackgroundColor]];
	return cell;
	
}

-(void)sliderChanged:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    int value = (int)slider.value;
    value = value * 100 +1500;
    cellSlider.lblRadius.text = [NSString stringWithFormat:@"%d",value];
    [commonUsedMethods setDefaultRadius:[NSString stringWithFormat:@"%d",value]];
    //[settingTable reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self hideKeyBoardIfVisible:indexPath];
    if(segmentedControl.selectedSegmentIndex == 0)
    {
        if(![commonUsedMethods getIsFacebookUser])
        {
            if(indexPath.row == 2)
            {
                
            }
            else if(indexPath.row == 3)
            {
                
            }
            
            else if(indexPath.row == 5)
            {
                [self changeProfileImage];
            }
        }
    }
   else  if(segmentedControl.selectedSegmentIndex == 1)
   {
       if(indexPath.row == 4)
       {
           NSString *kindString = NSLocalizedStringFromTable(@"About",@"data", @"About");
           NSLog(@"%@",kindString);
           AboutViewController *about = [[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil withText:kindString];
           [self.navigationController pushViewController:about animated:NO];
           [about release];
          
       }
       if(indexPath.row == 5)
       {
           NSString *kindString = NSLocalizedStringFromTable(@"About1",@"data", @"About1");
           NSLog(@"%@",kindString);
           AboutViewController *about = [[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil withText:kindString];
           [self.navigationController pushViewController:about animated:NO];
           [about release];
           
       }
       if(indexPath.row ==6)
       {
           [self singOutButtonPressed];
           
       }
   }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
	if(segmentedControl.selectedSegmentIndex == 0 && indexPath.row == 5)
	{
        return 80;
	}
    if(segmentedControl.selectedSegmentIndex == 1 && indexPath.row == 3)
        return 55;
	return 38;
}
-(void) singOutButtonPressed
{ 
    [commonUsedMethods setIsLogout:YES];
    EnvetFinderDelegate *appDelegate = (EnvetFinderDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate logout];
}
-(IBAction) segmentValueChange:(id)sender
{
    [self.settingTable reloadData];
    
}


-(void) hideKeyBoardIfVisible:(NSIndexPath *)indexPath
{
    editPetProfileCell *cell = (editPetProfileCell *) [self.settingTable cellForRowAtIndexPath:indexPath];
    for (UIView *view in cell.contentView.subviews){
        if([view isKindOfClass:[UITextField class]])
        {
            UITextField *_textfield = (UITextField *)view;
           // if(cell.textString.tag == indexPath.row)
            [self textFieldShouldReturn:_textfield];
        }
    }

}
/*
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection: (NSInteger)section 
{
	CGRect footerFrame = CGRectMake(0.0, 0.0, self.settingTable.frame.size.width, 30);
	UIView *_headerView = [[[UIView alloc] initWithFrame: footerFrame] autorelease];
	_headerView.backgroundColor = [UIColor clearColor];
	// _footerView.contentMode = UIViewContentModeCenter;
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 6.0, self.settingTable.frame.size.width, 25)];
	label.backgroundColor = [UIColor clearColor];
	label.textAlignment = UITextAlignmentLeft;
     if(segmentControl.selectedSegmentIndex == 0)
	label.text = @"Your Pet";
    else 
    label.text = @"Profile";
	[_headerView addSubview:label];
    
	return _headerView;
	
}
 */


-(IBAction) toggleSwitchChange:(id)sender
{
    UISwitch *switcher = (UISwitch *)sender;
    NSLog(@"Swith button pressed:%d",switcher.tag);
    if(segmentedControl.selectedSegmentIndex == 0)
    {
        if( switcher.tag == 3)
         {
        //userprofile.commentAPN  = switcher.on;
        // [commonUsedMethods setCommentNotification:switcher.on];
         [commonUsedMethods setSupportNotification:switcher.on];
         }
    else  if( switcher.tag == 4)
    {
         //userprofile.autoRegisterLocation  = switcher.on;
         [commonUsedMethods setCommentNotification:switcher.on];
    }
    }
    else if(segmentedControl.selectedSegmentIndex == 1)
    {
        if( switcher.tag == 0)
        {
            
            if(switcher.on)
            {
                NSLog(@"Turn on");
                socailObject.delegate= self;
                [socailObject facebookConnectMethod];
            }
            else
            {
                NSLog(@"Turn off");
                [commonUsedMethods setFacebookConfigured:switcher.on];
                socailObject.delegate= self;
                [socailObject singOutFacebook];
            }
        }
        else  if( switcher.tag == 1)
        {
            // userprofile.likeAPN     = switcher.on;
            
            if(switcher.on)
            {
                if(![socailObject TwitterHasKey])
                {
                    socailObject.delegate= self;
                    [socailObject logoutTwitter];
                    [socailObject loginTwitter];
                }
            }
            else
            {
                [commonUsedMethods setTwitterConfigured:switcher.on];
                socailObject.delegate= self;
                [socailObject logoutTwitter];
            }
        }
        else  if( switcher.tag == 2)
        {
            // userprofile.likeAPN     = switcher.on;
            [commonUsedMethods setAutoRegisterLocationNotification:switcher.on];
            
        }
    }
    
      /*
        if( switcher.tag == 0)
        {
            //userprofile.shareFB     = switcher.on;
             [commonUsedMethods setFBSharingNotification:switcher.on];
            if(switcher.on)
            {
            socailConnectObject *obj = [[SingletonClass sharedInstance] getSocialObject];
                obj.delegate = self;
             [obj facebookConnectMethod];
           // [obj release];
            }
            else 
            {
               socailConnectObject *obj = [[SingletonClass sharedInstance] getSocialObject];
                
                [obj singOutFacebook];
               // [obj release];
            }
        }*/
       // else  if( switcher.tag == 1)
        //{
            // userprofile.likeAPN     = switcher.on;
          //  [commonUsedMethods setTwitterSharingNotification:switcher.on];
        //}
            /*
            if(switcher.on)
            {
             socailConnectObject *obj = [[SingletonClass sharedInstance] getSocialObject];
                obj.delegate = self;
             //[obj setDelegate:self];
             [obj loginTwitter];
               // [obj release];
            }
            else 
            {
               socailConnectObject *obj = [[SingletonClass sharedInstance] getSocialObject];
                [obj logoutTwitter];
               // [obj release];
            }
            
        }
        else  if( switcher.tag == 2)
        {
            // userprofile.likeAPN     = switcher.on;
            [commonUsedMethods setAutoRegisterLocationNotification:switcher.on];
            
        }*/

        
    //}
    //}
    
}



-(void)changeProfileImage
{
    UIImage *tempImage = nil;
    if([imageCaches imageFromKey:userprofile.imgURL])
        tempImage = [imageCaches imageFromKey:userprofile.imgURL];
       profilePicViewController *PPCV = [[profilePicViewController alloc] initWithNibName:@"profilePicViewController" bundle:nil withDelegate:self withPic:tempImage];
     //   [self.navigationController presentModalViewController:PPCV animated:NO];
    [self.navigationController pushViewController:PPCV animated:NO];
    [PPCV release];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    textField.text = [commonUsedMethods trimString:textField.text]; 
  //  if([textField.text length] > 0){
        if(textField.tag == 0)
            {
                NSLog(@"%@ and %@",userprofile.userName,textField.text);
                userprofile.userName = textField.text;
                NSLog(@"%@",userprofile.userName);
            }
            else  if(textField.tag == 1)
            {
                userprofile.email = textField.text;
            }
            else  if(textField.tag == 2)
            {
                userprofile.password = textField.text;
            }
        
    //}
    resingKeyBoard=FALSE;

}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
   
	//if(textField.tag > 0)
	//self.view.frame = CGRectMake(0.0f, -50.0f, 320.0f, 370);
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //if(textField.tag > 0)
       // self.view.frame = CGRectMake(0.0f,0.0f, 320.0f, 370);
 /*
 if([textField.text length] > 0)
   {
    if(segmentControl.selectedSegmentIndex == 1)
    {
        if(textField.tag == 0)
        {
            NSLog(@"%@ and %@",userprofile.fullName,textField.text);
            userprofile.fullName = textField.text;
             NSLog(@"%@",userprofile.fullName);
        }
        else  if(textField.tag == 1)
        {
            userprofile.email = textField.text;
        }
        else  if(textField.tag == 2)
            userprofile.password = textField.text;
    }
    else if(segmentControl.selectedSegmentIndex == 0)
    {
        if(textField.tag == 0)
            currentPet.petName = textField.text;
        else  if(textField.tag == 1)
            currentPet.tagArray =(NSMutableArray *)[textField.text componentsSeparatedByString:@","];
    }
   }*/
    resingKeyBoard=TRUE;
    [textField resignFirstResponder];
    return YES;
}

/*
 - (UIView *)tableView:(UITableView *)tableView viewForFooterInSection: (NSInteger)section 
 {
 
 CGRect footerFrame = CGRectMake(0.0, 0.0, self.settingTable.frame.size.width, 40);
 UIView *_footerView = [[UIView alloc] initWithFrame: footerFrame];
 _footerView.backgroundColor = [UIColor clearColor];
 UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
 [button setTitle:@"Sign Out" forState:UIControlStateNormal];
 [button addTarget:self action:@selector(singOutPressed:) forControlEvents:UIControlEventTouchUpInside];	
 [button setTitleColor:[UIColor darkGrayColor]  forState:UIControlStateNormal];
 button.frame = CGRectMake(10.0, 10.0, self.settingTable.frame.size.width, 30);
 [_footerView addSubview:button];
 return _footerView;
 }
 */
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
- (void)dealloc {
   
    [userName release];
    [userProfileImage release];
    [tableHeaderView release];
	[settingTable release];
    [profileActivity release];
    [picDownload release];
    [userprofile release];
    [newPhoto release];
    [navigationTiteView release];
    [navProfileImage release];
    [navUserName release];
    [segmentedControl release];
    [super dealloc];
}

#pragma mark overlayDelegate
-(void) syncOnThreadAction
{
	
    overlay = [[SingletonClass sharedInstance] getOverlay];
	[overlay setDelegate:self];
     if(reqType == 1)
       {
           if(isNewPhoto)   
               [overlay editPersonnalInfo:[self getPersonalProfileURL]:self.newPhoto];
           else
               [overlay editPersonnalInfowithOutPhoto:[self getPersonalProfileURL]];   
       }
    else if(reqType == 2)
        [overlay getAuthorization:[requestStringURLs getLoginRequest]];
    else if(reqType == 3)
        {
            tokeInfo *token = [[SingletonClass sharedInstance] getTokenInformation];    
            [overlay getUserProfileData:[requestStringURLs getUserProfileRequest:token.iden:24 :0]:NO :NO];
        }
    
}
-(UIImage *) getNewImage
{
    return [UIImage imageNamed:@"imran2.jpg"];
}
-(NSString *) getPersonalProfileURL
{
    /*
     [NSString stringWithFormat:@"http://www.devexpertsteam.com/petstagram/web/api.php/postPhoto?lat=112.34&tags=pet&access_token=%@&caption=abc&lng=-34.434&%@&name=photo",tokeninfo.accessToken,@"&fb_token=166942940015970tc0ooRAAQrWcDm_84h307NN729DM&tw_token=JvyS7DO2qd6NNTsXJ4E7zA&email_address=airfl@devexperts.com"];
     
     */
    tokeInfo *tokeninfo = [[SingletonClass sharedInstance] getTokenInformation];
    NSMutableString *url = [[[NSMutableString alloc] init] autorelease];
    [url setString:kServerIp];
    //[url appendString:@"/users/"];
    //[url appendString:[NSString stringWithFormat:@"%d",[tokeninfo.iden intValue]]];
	[url appendString:@"/updateAccount?"];
    if(userprofile.email && [userprofile.email length] > 0)
        [url appendString:[NSString stringWithFormat:@"email=%@",userprofile.email]];
    if(userprofile.userName && [userprofile.userName length] > 0)
    [url appendString:[NSString stringWithFormat:@"&username=%@",userprofile.userName]];
    if(userprofile.password && [userprofile.password length] > 0)
        [url appendString:[NSString stringWithFormat:@"&password=%@",userprofile.password]];
    //if(userprofile.email && [userprofile.email length] > 0)
     //   [url appendString:[NSString stringWithFormat:@"&email=%@",userprofile.email]];
     [url appendString:[NSString stringWithFormat:@"&access_token=%@",tokeninfo.accessToken]];
    [url appendString:[NSString stringWithFormat:@"&receive_push_for_supports=%@&receive_push_for_comments=%@",[commonUsedMethods getSupportNotification] ? @"yes":@"no", [commonUsedMethods getCommentNotification] ? @"yes":@"no"]];
    if(isNewPhoto)
     [url appendString:@"&name=user_photo"];
    url = [[url stringByReplacingOccurrencesOfString:@" " withString:@"%20"] mutableCopy];
    NSLog(@"%@",url);
    return url;
}

#pragma mark ParserProtocolDelegate
-(void) userFeedData:(NSDictionary *)_dictionary
{
	
    [overlay dismiss];
	[overlay setDelegate:nil];
    if([_dictionary valueForKey:@"status"] && [[_dictionary valueForKey:@"status"] isEqualToString:@"OK"])
    {
        [self saveNewProfilePhotoToToken];
        reqType = 3;
        [self syncOnThreadAction];
       
        // to DO
    } 
	else  if([_dictionary valueForKey:@"status"] && [[_dictionary valueForKey:@"status"] isEqualToString:@"ERROR"])
    {
        NSMutableDictionary *errorDic = [[_dictionary valueForKey:@"errors"] objectAtIndex:0];
        [self loadAlertView:[errorDic valueForKey:@"message"]];
    }
}

-(void) loginResponse:(NSNumber *)_value
{
	
	[overlay dismiss];
    [overlay setDelegate:nil];
     if(reqType == 1)
     {
         [self saveNewProfilePhotoToToken];
         reqType = 3;
         [self syncOnThreadAction];
     }
   else  if(reqType == 2)
    {
        reqType = 3;
         [self syncOnThreadAction];
    }
}
-(void) saveNewProfilePhotoToToken
{
   
   
   // [commonUsedMethods removeUserCrediential]; 
   // [commonUsedMethods setSupportNotification:userprofile.supportAPN];
   // [commonUsedMethods setCommentNotification:userprofile.commentAPN];
   // [commonUsedMethods setAutoRegisterLocationNotification:userprofile.autoRegisterLocation];
    //[commonUsedMethods setFBSharingNotification:userprofile.shareFB];
  if(isNewPhoto && newPhoto)
  {
      tokeInfo *token = [[SingletonClass sharedInstance] getTokenInformation];
      if(!token.imgURL)
      {
          token.imgURL = USER_PROFILE_IMAGE;    
//      [imageCaches setCacheImage:newPhoto :USER_PROFILE_IMAGE];
          [imageCaches storeImage:newPhoto imageData:UIImageJPEGRepresentation(newPhoto, 1.0) forKey:USER_PROFILE_IMAGE toDisk:YES];
      }
      else
      {
      //[imageCaches setCacheImage:newPhoto :token.imgURL];
          [imageCaches storeImage:newPhoto imageData:UIImageJPEGRepresentation(newPhoto, 1.0) forKey:token.imgURL toDisk:YES];
      }
  }
}
-(void) errorResponseData:(NSDictionary *)_dictionary
{
	[overlay dismiss];
    [overlay setDelegate:nil];
    [self loadAlertView:[_dictionary valueForKey:@"message"]];
}
-(void) ParserArraylist:(NSMutableArray *) _array
{
    [overlay dismiss];
    [DataModel setDataInDictionary:_array:6];
    [self.navigationController popViewControllerAnimated:NO];
}



#pragma mark clientProtocolDelegate
-(void) notfiyResponse:(NSNumber *)_value
{
	[overlay dismiss];
    [overlay setDelegate:nil];
    [self loadAlertView:@"Unable To Connect To Internet Check Your Internet Connection"];
}
-(void) loadAlertView:(NSString *)_msg
{
	UIAlertView *alert = [[UIAlertView alloc] 
						  initWithTitle:@"" 
						  message:_msg 
						  delegate:self 
						  cancelButtonTitle:@"OK" 
						  otherButtonTitles:nil];
	[alert show];
	[alert release];
	
}
#pragma mark -
#pragma mark Download support (NSURLConnectionDelegate)

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.picDownload appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    self.picDownload = nil;
    connection = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    UIImage *image = [[UIImage alloc] initWithData:self.picDownload];
	
	if(image)
	{
        for (UIView *view2 in userProfileImage.subviews)
        {
            if([view2 isKindOfClass:[UIActivityIndicatorView class]])
                [view2 removeFromSuperview];
        }
        [userProfileImage setImage:image];
        [image release];
	}
    self.picDownload = nil;
    connection = nil;
}
#pragma marked for ProfilePictureChange
-(void) pictureHasTaken:(UIImage *)_image;
{
    self.newPhoto = _image;
    self.newPhoto = [commonUsedMethods imageWithBorderFromImage:self.newPhoto];
    self.newPhoto = [commonUsedMethods imageWithImage:self.newPhoto :CGSizeMake(100, 100)];
    isNewPhoto = TRUE;
    [self.settingTable reloadData];
    
    
}
#pragma mark socialResponseDelegate
-(void)showTwitterView:(SA_OAuthTwitterController *)_controller
{
    [self presentModalViewController: _controller animated:YES];
}
-(void) TwitterStatus:(NSNumber *)_status
{
    if([_status boolValue])
    {
       
        [commonUsedMethods setTwitterConfigured:YES];
        
        [self.settingTable reloadData];
    }
    else
    {
        [commonUsedMethods setTwitterConfigured:NO];
        [self.settingTable reloadData];
    }
    
}
-(void) facebookStatus:(NSNumber *)_status
{
    if([_status boolValue])
    {
        
        [commonUsedMethods setFacebookConfigured:YES];
         [self.settingTable reloadData];
    }
    else
    {
       [commonUsedMethods setFacebookConfigured:NO];
       [self.settingTable reloadData]; 
    }
   
}

@end
