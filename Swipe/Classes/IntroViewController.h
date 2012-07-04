//
//  IntroViewController.h
//  Posterboard
//
//  Created by Apptellect5 on 9/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface IntroViewController : UIViewController <UIScrollViewDelegate>
{
    IBOutlet UIScrollView *scrollview;
    IBOutlet UIPageControl *pageControl;
    NSMutableArray *controllers;
    IBOutlet UINavigationBar *toolbar;
    // To be used when scrolls originate from the UIPageControl
    BOOL pageControlUsed;
}

@property (nonatomic,retain) IBOutlet UIScrollView *scrollview;
@property (nonatomic,retain) IBOutlet UIPageControl *pageControl;
@property (nonatomic,retain) NSMutableArray *controllers;
@property (nonatomic,retain) IBOutlet UINavigationBar *toolbar;
- (IBAction)changePage:(id)sender;
- (IBAction)DonePrssed:(id)sender;

@end
