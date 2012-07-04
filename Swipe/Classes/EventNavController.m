//
//  BooksNavController.m
//  ORBooks
//
//  Created by Elisabeth Robson on 6/19/09.
//  Copyright 2009 Elisabeth Robson. All rights reserved.
//

#import "EventNavController.h"
#import "commonUsedMethods.h"
#import "headerfiles.h"



@implementation EventNavController

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	UINavigationBar *bar=self.navigationBar;
	bar.delegate=self;
}
 */
 



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];  //  132 0 33    //   58  0  18
	//self.navigationBar.tintColor = [commonUsedMethods getNavTintColor];
    //[self.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar_bg_portrait1"] forBarMetrics:UIBarMetricsDefault];
    
    
    if ([self.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
        {
        //[navBar setBackgroundImage:[UIImage imageNamed:@"navigation-bar-bg.png"] forBarMetrics:UIBarMetricsDefault];
            [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"navBlackImage"] forBarMetrics:UIBarMetricsDefault];
        }
    /*
    else
        {
            UIImageView *imageView = (UIImageView *)[self.navigationBar viewWithTag:kSCNavigationBarBackgroundImageTag];
            if (imageView == nil)
                {
                    imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navbar_bg_portrait1"]];
                    [imageView setTag:kSCNavigationBarBackgroundImageTag];
                    [self.navigationBar insertSubview:imageView atIndex:0];
                    [imageView release];
                    }
        }*/
    
	
}
 
 


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    [AppDelegate clearAllCacheImage];
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    [super dealloc];
}
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
	NSLog(@"me here");
}


@end
