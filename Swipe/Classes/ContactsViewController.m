//
//  Posptercard
//
//  Created by Imran on 7/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ContactsViewController.h"
#import "contactViewCell.h"
#import "commonUsedMethods.h"
#import "headerfiles.h"
#import "syncManager.h"
#import "EnvetFinderDelegate.h"
#import "SocialData.h"
#import "PhoneList.h"
#import "User.h"
#import "EmailList.h"
#import "ContactBook.h"


@implementation ContactsViewController
@synthesize topicTable;
@synthesize topicArray;
@synthesize searchbar;
@synthesize syncManager;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad {
 [super viewDidLoad];
     self.view.backgroundColor = [Font_size cellBackgroundColor];
     self.searchbar.tintColor = [commonUsedMethods getNavTintColor];
     [Font_size customSearchBarBackground:self.searchbar];
     
     UINavigationItem *item = [self.navigationController.navigationBar.items objectAtIndex:0];
     item.title = @"SWIPE";
     
     item.rightBarButtonItem = [commonUsedMethods navigationButtonWithText:@"Add":FALSE];
     UIButton* rightButton = (UIButton*)item.rightBarButtonItem.customView;
     [rightButton addTarget:self action:@selector(syncButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
     
     item.leftBarButtonItem = [commonUsedMethods navigationButtonWithText:@"Back":TRUE];
     UIButton* leftButton = (UIButton*)item.leftBarButtonItem.customView;
     [leftButton addTarget:self action:@selector(backButtonMethod) forControlEvents:UIControlEventTouchUpInside];
     

     self.topicArray = (NSMutableArray *)[self printAddressBook];
     NSLog(@"array length is %d ",[topicArray count]);
     [self saveDataToLocalPreference:self.topicArray];
     
     isListView  = TRUE;
         
}

- (NSArray*)   printAddressBook   
{
    
    if (managedObjectContext == nil) 
    { 
        managedObjectContext = [(EnvetFinderDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]; 
        NSLog(@"After managedObjectContext: %@",  managedObjectContext);
    }  
    NSMutableArray *mutableData = [NSMutableArray new];
    ABAddressBookRef addressBook = ABAddressBookCreate();
    NSArray *arrayOfAllPeople = (__bridge_transfer NSArray *) ABAddressBookCopyArrayOfAllPeople(addressBook);
    NSUInteger peopleCounter = 0; 
    
    for (peopleCounter = 0;peopleCounter < [arrayOfAllPeople count]; peopleCounter++){
        ABRecordRef thisPerson = (__bridge ABRecordRef) [arrayOfAllPeople objectAtIndex:peopleCounter];
        NSString *name = (__bridge_transfer NSString *) ABRecordCopyCompositeName(thisPerson);
        NSLog(@"First Name = %@", name);  
        ContactBook *user = (ContactBook *)[NSEntityDescription insertNewObjectForEntityForName:@"ContactBook" inManagedObjectContext:managedObjectContext];
        user.firstName = name;
        
         user.jobTitle = (NSString *)ABRecordCopyValue(thisPerson, kABPersonJobTitleProperty);
         user.companyName = (NSString *)ABRecordCopyValue(thisPerson, kABPersonOrganizationProperty);
         user.dept = (NSString *)ABRecordCopyValue(thisPerson, kABPersonDepartmentProperty);
         user.dob = (NSDate *)ABRecordCopyValue(thisPerson, kABPersonBirthdayProperty);
        if( ABPersonHasImageData( thisPerson ) ) {
            //record has an image
            user.imageData = (NSData *) ABPersonCopyImageData( thisPerson ) ;
        } 

       //  user.imageData =  (NSData*)ABPersonCopyImageDataWithFormat([thisPerson objectAtIndex:0], kABPersonImageFormatThumbnail);
        
        NSMutableArray *phoneArray = [[NSMutableArray alloc] init];
        ABMultiValueRef *phones = ABRecordCopyValue(thisPerson, kABPersonPhoneProperty);
        
        
        for(CFIndex j = 0; j < ABMultiValueGetCount(phones); j++)
        {
            PhoneList *phone = (PhoneList *)[NSEntityDescription insertNewObjectForEntityForName:@"PhoneList" inManagedObjectContext:managedObjectContext];
             
             CFStringRef phoneNumberRef = ABMultiValueCopyValueAtIndex(phones, j);
             CFStringRef locLabel = ABMultiValueCopyLabelAtIndex(phones, j);
             phone.phoneNo= (NSString *)phoneNumberRef;
             phone.phoneTitle = (NSString*) ABAddressBookCopyLocalizedLabel(locLabel);

            CFRelease(phoneNumberRef);
            CFRelease(locLabel);
           // NSLog(@"  - %@ (%@)", phoneNumber, phoneLabel);
            [phoneArray addObject:phone];
           // [phoneNumber release];
        }
        
        ABMultiValueRef emails = ABRecordCopyValue(thisPerson, kABPersonEmailProperty);
        
        NSMutableArray *emailArray = [[NSMutableArray alloc] init];
        for (NSUInteger emailCounter = 0; emailCounter < ABMultiValueGetCount(emails); emailCounter++)
        {
            NSString *email = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(emails, emailCounter);
            CFStringRef locLabel = ABMultiValueCopyLabelAtIndex(emails, emailCounter);
            EmailList *emailObject = (EmailList *)[NSEntityDescription insertNewObjectForEntityForName:@"EmailList" inManagedObjectContext:managedObjectContext];
            emailObject.email = email;
            emailObject.emailTitle = (NSString*) ABAddressBookCopyLocalizedLabel(locLabel);
            [emailArray addObject:emailObject];
        }
        ABMultiValueRef multi = ABRecordCopyValue(thisPerson, kABPersonSocialProfileProperty);
       if(ABMultiValueGetCount(multi) > 0)
       {
         SocialData *social = (SocialData *)[NSEntityDescription insertNewObjectForEntityForName:@"SocialData" inManagedObjectContext:managedObjectContext];   
        for (CFIndex i = 0; i < ABMultiValueGetCount(multi); i++) 
        {
            
            NSDictionary* personalDetails = [NSDictionary dictionaryWithDictionary:(NSDictionary*)ABMultiValueCopyValueAtIndex(multi, i)];
            NSLog(@"%@",personalDetails);
           
            if([[personalDetails valueForKey:@"service"] isEqualToString:@"linkedin"])
            {
             social.linkedIn = [personalDetails valueForKey:@"username"];
             social.linkedInURL = [personalDetails valueForKey:@"url"];   
            }
            if([[personalDetails valueForKey:@"service"] isEqualToString:@"twitter"])
            {
                social.twitter = [personalDetails valueForKey:@"username"];
                social.twitterURL = [personalDetails valueForKey:@"url"];   
            }
            if([[personalDetails valueForKey:@"service"] isEqualToString:@"facebook"])
            {
                social.facebook = [personalDetails valueForKey:@"username"];
                social.facebookURL = [personalDetails valueForKey:@"url"];   
            }
            if([[personalDetails valueForKey:@"service"] isEqualToString:@"flickr"])
            {
                social.flicker = [personalDetails valueForKey:@"username"];
                social.flickerURL = [personalDetails valueForKey:@"url"];   
            }
            if([[personalDetails valueForKey:@"service"] isEqualToString:@"myspace"])
            {
                social.mySpace = [personalDetails valueForKey:@"username"];
                social.mySpaceURL = [personalDetails valueForKey:@"url"];   
            }
        }
            user.userSocial = social;
        }
        if([emailArray count] > 0)  
            [user addUserEmails:[NSSet setWithArray:emailArray]];
        if([phoneArray count] > 0)  
            [user addPhones:[NSSet setWithArray:phoneArray]];
         
            
            [mutableData addObject:user];
            [emailArray release];
            [phoneArray release];
        NSLog(@"User:%@",user);
        
    } 
    CFRelease(addressBook);
    return [NSArray arrayWithArray:mutableData];
}


-(void) backButtonMethod
{
    [self.navigationController popViewControllerAnimated:YES];
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
    
}
// called when Search (in our case “Done”) button pressed
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    self.searchbar.text = [commonUsedMethods stripDoubleSpaceFrom:searchBar.text];
    [searchBar resignFirstResponder];
    if([self.searchbar.text length]>0)
    {
       
    }
}


-(void) saveDataToLocalPreference:(NSMutableArray *)_array
{
    
    
    
}
 
#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	if (isListView) {
        return [self.topicArray count];
    }
	return 1;
        
		
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
 
   if(isListView)
   {
       static NSString *hlCellID = @"hlCellID";
       UITableViewCell *hlcell = [tableView dequeueReusableCellWithIdentifier:hlCellID];
       if(hlcell == nil) {
           hlcell =  [[[UITableViewCell alloc] 
                       initWithStyle:UITableViewCellStyleDefault reuseIdentifier:hlCellID] autorelease];
           hlcell.accessoryType = UITableViewCellAccessoryNone;
           hlcell.selectionStyle = UITableViewCellSelectionStyleNone;
       }
       [self removeAllButtonFromCell:hlcell]; 
       [self dataForOtherTab:hlcell:indexPath];
       return hlcell;
   }
   else {
       
    static NSString *CellIdentifier = @"contactViewCell";
    contactViewCell *cell = (contactViewCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"contactViewCell" owner:self options:nil];
        
        for (id currentObject in topLevelObjects){
            if ([currentObject isKindOfClass:[UITableViewCell class]]){
                cell =  (contactViewCell *) currentObject;
                break;
            }
        }
    } 
    
        ContactBook *person = [self.topicArray objectAtIndex:indexPath.row];
        cell.nameLabel.text = person.firstName;
    cell.selectionStyle=0;
    cell.backgroundColor = [Font_size cellBackgroundColor];
    return cell;
   }
    return 0;
}
-(void) removeAllButtonFromCell:(UITableViewCell *)cell
{
	for (UIView *view in cell.contentView.subviews){
		if([view isKindOfClass:[UIButton class]])
		{
			[view removeFromSuperview];
		}
	}
    
	
}
#pragma mark code for image grid
-(void) dataForOtherTab:(UITableViewCell *)hlcell:(NSIndexPath *)indexPath
{
    int n = [self.topicArray count];
	int i=0,i1=0; 
	NSLog(@"redraw cell");
	while(i<n)
    {
		int yy = 4 +i1*75+(4*(i1+1));
		int j=0;
		for(j=0; j<4;j++)
        {
			
			if (i>=n) break;
			ContactBook *person = [self.topicArray objectAtIndex:i];
			CGRect rect = CGRectMake((4*(j+1))+75*j, yy, 75, 75);
			UIButton *button=[[UIButton alloc] initWithFrame:rect];
			[button setFrame:rect];
			NSString *tagValue = [NSString stringWithFormat:@"%d%d", indexPath.row, i];
            //NSString *tagValue = [NSString stringWithFormat:@"%d", i];
			button.tag = [tagValue intValue];
			UIImage *buttonImageNormal = [UIImage imageWithData:person.imageData];
			if (!buttonImageNormal)
		    {
                //       
                buttonImageNormal = [UIImage imageNamed:@"frame.png"];//[Font_size getPlaceholderImage];
               //  buttonImageNormal =[Font_size getPlaceholderImage];
				[self startIconDownload:person.imgURL:indexPath:[tagValue intValue]];
			}
			else
			{
				buttonImageNormal =[imageCaches imageFromKey:person.imgURL];//[ImageManipulator makeRoundCornerImage:[imageCaches getCacheImage:obj.url] :8 : 8];
				[button setBackgroundImage:buttonImageNormal forState:UIControlStateNormal];
                
			}
			[button setImage:buttonImageNormal forState:UIControlStateNormal];
			[button setContentMode:UIViewContentModeScaleAspectFit];
			[button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
			[hlcell.contentView addSubview:button];
			[button release];
            
			
			i++;
		}
		i1 = i1+1;
	}
    hlcell.selectionStyle=0;
}
#pragma mark -
#pragma mark Table cell image support

- (void)startIconDownload:(NSString *)_url:(NSIndexPath *)indexpath:(int)_key
{
	if([_url length] == 0)
        return ;
    NSMutableDictionary *Info = [[NSMutableDictionary alloc] init];
    [Info setObject:indexpath forKey:@"IndexPath"];
    [Info setObject:[NSString stringWithFormat:@"%d",_key] forKey:@"key"];
    [Info setObject:_url forKey:@"url"];
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    // Start an async download
    [manager downloadWithURL:[NSURL URLWithString:_url] delegate:self:Info];
    [Info release];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
     CGFloat result = 80.0f;
       	return result;
}

- (void)dealloc
{
    [topicTable release];
    [topicArray release];
    [searchbar release];
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

- (IBAction)syncButtonPressed:(id)sender {
    
    if(self.syncManager == nil)
    {
        SyncManager *sm = [[SyncManager alloc] initWithDelegate:self];
        self.syncManager = sm;
        [sm release];
    }
    NSError *error = nil;
    [self.syncManager start:&error];
    /*
     if(error != nil && [error code] != 0)
     {
     
     [[[[UIAlertView alloc] initWithTitle:@"Error" message:@"Sorry, there was a problem syncing. Check your network connection." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil] autorelease] show];
     //self.syncManager = nil;
     }
     */
}



@end
