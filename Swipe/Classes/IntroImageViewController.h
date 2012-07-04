//
//  IntroImageViewController.h
//  Posterboard
//
//  Created by Apptellect5 on 9/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface IntroImageViewController : UIViewController 
{
    IBOutlet UIImageView *imageView;
    int pageNumber;
}

@property (nonatomic,retain) IBOutlet UIImageView *imageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withPageNumber:(int)_page;

@end
