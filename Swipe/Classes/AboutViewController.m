//
//  settingViewController.m
//  Petstagram
//
//  Created by Awais Ahmad Qureshi on 5/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AboutViewController.h"
#import "DataModel.h"
#import "userProfile.h"
#import "petsObject.h"
#import "editPetViewController.h"
#import "commonUsedMethods.h"
#import "Font+size.h"


@implementation AboutViewController
@synthesize helpView;
@synthesize htmlString;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withText:(NSString *)_text {
 self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
 if (self) {
 // Custom initialization.
     self.htmlString = _text;
 }
 return self;
 }
 


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
//	 self.navigationItem.titleView =  [commonUsedMethods navigationlogoView];
    [self.helpView loadHTMLString:htmlString baseURL:nil];
    
    
    // New navigation and button code eith effects
    
    UINavigationItem *item = self.navigationItem;
    item.titleView =  [commonUsedMethods navigationlogoView];
    
//    item.rightBarButtonItem = [commonUsedMethods navigationButtonWithText:@"Post":FALSE];
//    UIButton* rightButton = (UIButton*)item.rightBarButtonItem.customView;
//    [rightButton addTarget:self action:@selector(submitButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    
    item.leftBarButtonItem = [commonUsedMethods navigationButtonWithText:@"Back":TRUE];
    UIButton* leftButton = (UIButton*)item.leftBarButtonItem.customView;
    [leftButton addTarget:self action:@selector(backButtonMethod) forControlEvents:UIControlEventTouchUpInside];
    
    // code end
   /* 
    UIImage *image1=[UIImage imageNamed:@"back.png"];
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.bounds = [Font_size getNavRightButtonFrame];     
    [button1 setBackgroundImage:image1 forState:UIControlStateNormal];
    
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
- (void)dealloc {
    [helpView release];
    [htmlString release];
    [super dealloc];
}


@end
