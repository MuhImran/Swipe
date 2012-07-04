//
//  addFilterViewController.h
//  Petstagram
//
//  Created by Awais Ahmad Qureshi on 5/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class shareViewController;
@interface addFilterViewController : UIViewController {
	
	IBOutlet UIImageView		*imageView;
	UIImage						*Image;
	shareViewController         *SVC;

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil wtihImage:(UIImage *)_image;
@property (retain,nonatomic) IBOutlet UIImageView *imageView;
@property (retain,nonatomic) UIImage *Image;
@property (retain,nonatomic) shareViewController  *SVC;
-(void) setCameraImage:(UIImage *)_image;
- (UIImage*)imageWithBorderFromImage:(UIImage*)source;
-(IBAction) addBorderPressed:(id)sender;
//-(UIImage *)imageWithImage:(UIImage*)image:(CGSize)newSize;
@end
