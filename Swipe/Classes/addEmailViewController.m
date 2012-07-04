//
//  addEmailViewController.m
//  Petstagram
//
//  Created by Awais Ahmad Qureshi on 5/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "addEmailViewController.h"
#import "addEmailCell.h"
#import "commonUsedMethods.h"
#import "headerfiles.h"

@implementation addEmailViewController
@synthesize addEmailTable;
@synthesize dataArray;
@synthesize delegate;

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
	self.title = @"Email";
	dataArray = [[NSMutableArray alloc] initWithCapacity:5];
	[dataArray addObject:@""];
	[dataArray addObject:@""];
	[dataArray addObject:@""];
	[dataArray addObject:@""];
	[dataArray addObject:@""];
	self.addEmailTable.backgroundColor = [UIColor clearColor];
	UIBarButtonItem *submitButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(doneButtonPressed:)];          
	self.navigationItem.rightBarButtonItem = submitButton;
	[submitButton release];
}

-(void)viewWillAppear:(BOOL)animated 
{
    [super viewWillAppear:animated];
	[self.addEmailTable reloadData];
}

-(IBAction) doneButtonPressed:(id)sender
{
	BOOL success=FALSE;
	NSMutableArray *tempArray = [[NSMutableArray alloc] init];
	for (int i = 0; i < [dataArray count]; i++) {
		if(![[dataArray objectAtIndex:i] isEqualToString:@""])
		{
			success =  TRUE;
		[tempArray addObject:[dataArray objectAtIndex:i]];
		[dataArray replaceObjectAtIndex:i withObject:@""];
	}
	 }
	if(success)
	{
	if(delegate && [delegate respondsToSelector:@selector(configureEmailIDs:)])
		[delegate performSelector:@selector(configureEmailIDs:) withObject:tempArray];
	}
	[tempArray release];
	[self.navigationController popViewControllerAnimated:NO];
}

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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}
// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [dataArray count];
}
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	static NSString *CellIdentifier = @"addEmailCell";
	addEmailCell *cell = (addEmailCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		
		NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"addEmailCell" owner:self options:nil];
		
		for (id currentObject in topLevelObjects){
			if ([currentObject isKindOfClass:[UITableViewCell class]]){
				cell =  (addEmailCell *) currentObject;
				break;
			}
		}
	} 
	if([[dataArray objectAtIndex:[indexPath row]] length] == 0)
	{
		
		cell.emailString.text = 	@"Add email here";
		//cell.userButton.hidden  =  FALSE;
		[cell.userButton addTarget:self action:@selector(contactButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
		[cell.userButton setTag:indexPath.row];
		
	}
	else
	{
	cell.emailString.text = [dataArray objectAtIndex:[indexPath row]];
	//cell.userButton.hidden  =  TRUE;
	
	}
	cell.emailString.delegate = self;
	cell.emailString.tag = [indexPath row];
	cell.accessoryType=1;
 return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection: (NSInteger)section 
{
	CGRect footerFrame = CGRectMake(0.0, 0.0, self.addEmailTable.frame.size.width, 40);
	UIView *_headerView = [[UIView alloc] initWithFrame: footerFrame];
	_headerView.backgroundColor = [UIColor clearColor];
	// _footerView.contentMode = UIViewContentModeCenter;
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 10.0, self.addEmailTable.frame.size.width, 30)];
	label.backgroundColor = [UIColor clearColor];
	label.text = @"You can add five email address";
	[_headerView addSubview:label];
	return _headerView;
	
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
	textField.text=@"";
	if(textField.tag >= 3)
	self.view.frame = CGRectMake(0.0f, -70.0f, 320.0f, 460);
	
	return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{    
	  self.view.frame = CGRectMake(0.0f,0.0f, 320.0f, 460);
	 [dataArray replaceObjectAtIndex:textField.tag withObject:textField.text];
	 [self.addEmailTable reloadData];
	  [textField resignFirstResponder];
		return YES;
}


-(IBAction) contactButtonPressed:(id)sender {
	
	UIButton *button = (UIButton *)sender;
	reqType = button.tag;
	// creating the picker
	ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
	// place the delegate of the picker to the controll
	picker.peoplePickerDelegate = self;
	
	picker.topViewController.navigationController.navigationBar.tintColor = [commonUsedMethods getNavTintColor];
	picker.topViewController.searchDisplayController.searchBar.tintColor = [commonUsedMethods getNavTintColor];
	
	// showing the picker
	picker.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	[self presentModalViewController:picker animated:YES];
	// releasing
	[picker release];
}

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker {
    // assigning control back to the main controller
	
	[self dismissModalViewControllerAnimated:YES];
	//[dataArray replaceObjectAtIndex:reqType withObject:@"muh.imrans@gmail.com"];
	 
	//isABPicker = FALSE;
	///////    HARD CODED VALUES  ////////
	//[self hardCodedMethod];
}

/////////////////////////  HARD CODED METHOD AND MUST BE REMOVED IN ACTUAL IMPLEMENTATION //////////
-(void) hardCodedMethod
{
	//if(!contactPerson)
	//	contactPerson = [[personInfoObject alloc] init];
	//contactPerson.firstName = @"Ali murtiza";
	//contactPerson.lastName = @"Haider";
	//contactPerson.email = @"Beven@a.com";
	//contactPerson.cellNo = @"03336378123";
	
	//[ObjectList setPersonInfo:contactPerson];
}
//if (!([[NSNull null] isEqual:(NSString *)ABRecordCopyValue(person, kABPersonEmailProperty)]))
//[dataArray replaceObjectAtIndex:reqType withObject:(NSString *)ABRecordCopyValue(person, kABPersonEmailProperty)];
/////////////////////////  HARD CODED METHOD AND MUST BE REMOVED IN ACTUAL IMPLEMENTATION //////////

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    // as soon as they select someone, return
   // personDealingWithFullName = (NSString *)ABRecordCopyCompositeName(person);
   // personDealingWithFirstName = (NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
    // construct array of emails
   // [personDealingWithEmails removeAllObjects];
    ABMutableMultiValueRef multi = ABRecordCopyValue(person, kABPersonEmailProperty);
    if (ABMultiValueGetCount(multi) > 0) {
        // collect all emails in array
        //for (CFIndex i = 0; i < ABMultiValueGetCount(multi); i++) {
            CFStringRef emailRef = ABMultiValueCopyValueAtIndex(multi, 0);
            //[personDealingWithEmails addObject:(NSString *)emailRef];
            [dataArray replaceObjectAtIndex:reqType withObject:(NSString *)emailRef]; 
            CFRelease(emailRef);
            [self dismissModalViewControllerAnimated:YES];
        //}
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] 
                              initWithTitle:@"" 
                              message:@"Select contact has missing email info" 
                              delegate:self 
                              cancelButtonTitle:@"OK" 
                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        
    }
    CFRelease(multi);
    return NO;
}
/*
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
    return NO;
}*/

- (void)dealloc {
	delegate=nil;
	[dataArray release];
	[addEmailTable release];
    [super dealloc];
}


@end
