//
//  IntroViewController.m
//  Posterboard
//
//  Created by Apptellect5 on 9/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import "IntroViewController.h"
#import "IntroImageViewController.h"
#import "headerfiles.h"
#import "EnvetFinderDelegate.h"



static NSUInteger kNumberOfPages = 5;

@interface IntroViewController (PrivateMethods)

- (void)loadScrollViewWithPage:(int)page;
- (void)scrollViewDidScroll:(UIScrollView *)sender;

@end

@implementation IntroViewController

@synthesize scrollview;
@synthesize pageControl;
@synthesize controllers;
@synthesize toolbar;
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
    [scrollview release];
    [controllers release];
    [pageControl release];
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
;
- (void)viewDidLoad
{
    
   // [self.toolbar setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"navbar_bg_portrait1"]]];
   // [self.toolbar setBackgroundImage:[UIImage imageNamed:@"navbar_bg_portrait1"] forBarMetrics:UIBarMetricsDefault];
  
    if ([self.toolbar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
        //[navBar setBackgroundImage:[UIImage imageNamed:@"navigation-bar-bg.png"] forBarMetrics:UIBarMetricsDefault];
        [self.toolbar setBackgroundImage:[UIImage imageNamed:@"navbar_bg_portrait1"] forBarMetrics:UIBarMetricsDefault];
    }
    
    UINavigationItem *item = [self.toolbar.items objectAtIndex:0];
    item.titleView =  [commonUsedMethods navigationlogoView];
    
    item.rightBarButtonItem = [commonUsedMethods navigationButtonWithText:@"Skip":FALSE];
    UIButton* rightButton = (UIButton*)item.rightBarButtonItem.customView;
    [rightButton addTarget:self action:@selector(DonePrssed:) forControlEvents:UIControlEventTouchUpInside];

    NSMutableArray *controllers1 = [[NSMutableArray alloc] init];
    for (unsigned i = 0; i < kNumberOfPages; i++) {
        [controllers1 addObject:[NSNull null]];
    }
    self.controllers = controllers1;
    [controllers1 release];
    
    //self.toolbar.frame = CGRectMake(0, 20, 320, 44);
	
    // a page is the width of the scroll view
    scrollview.pagingEnabled = YES;
    scrollview.frame = CGRectMake(0, 20, 320, 460);
    scrollview.contentSize = CGSizeMake(scrollview.frame.size.width * kNumberOfPages, scrollview.frame.size.height);
    scrollview.showsHorizontalScrollIndicator = NO;
    scrollview.showsVerticalScrollIndicator = NO;
    scrollview.scrollsToTop = NO;
    scrollview.delegate = self;
	
    
    pageControl.numberOfPages = kNumberOfPages;
    pageControl.currentPage = 0;
	
    // pages are created on demand
    // load the visible page
    // load the page on either side to avoid flashes when the user starts scrolling
    [self loadScrollViewWithPage:0];
    [self loadScrollViewWithPage:1];
}

- (void)storeAction:(id)sender
{
    [[[[UIAlertView alloc] initWithTitle:@"Store"
                                 message:nil
                                delegate:nil
                       cancelButtonTitle:nil 
                       otherButtonTitles:NSLocalizedString(@"OK", nil), nil] autorelease] show];
}

- (IBAction)DonePrssed:(id)sender
{
    [self.view removeFromSuperview];
    EnvetFinderDelegate *appDelegate = (EnvetFinderDelegate *)[[UIApplication sharedApplication] delegate];
	[appDelegate performSelector:@selector(removeAllViews) withObject:nil afterDelay:0.0];
}

- (void)loadScrollViewWithPage:(int)page {
    if (page < 0) return;
    if (page >= kNumberOfPages) return;
	
    // replace the placeholder if necessary
    IntroImageViewController *controller = [controllers objectAtIndex:page];
    if ((NSNull *)controller == [NSNull null]) {
        controller = [[IntroImageViewController alloc] initWithNibName:@"IntroImageViewController" bundle:nil withPageNumber:page];
        [controllers replaceObjectAtIndex:page withObject:controller];
        [controller release];
    }
	
    // add the controller's view to the scroll view
    if (nil == controller.view.superview) {
        CGRect frame = scrollview.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        controller.view.frame = frame;
        [scrollview addSubview:controller.view];
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    // We don't want a "feedback loop" between the UIPageControl and the scroll delegate in
    // which a scroll event generated from the user hitting the page control triggers updates from
    // the delegate method. We use a boolean to disable the delegate logic when the page control is used.
    if (pageControlUsed) {
        // do nothing - the scroll was initiated from the page control, not the user dragging
        return;
    }
	
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = scrollview.frame.size.width;
    int page = floor((scrollview.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
	
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
	
    // A possible optimization would be to unload the views+controllers which are no longer visible
}

// At the begin of scroll dragging, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    pageControlUsed = NO;
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    pageControlUsed = NO;
}

- (IBAction)changePage:(id)sender {
    int page = pageControl.currentPage;
	
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
	// update the scroll view to the appropriate page
    CGRect frame = scrollview.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [scrollview scrollRectToVisible:frame animated:YES];
    
	// Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
    pageControlUsed = YES;
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

@end
