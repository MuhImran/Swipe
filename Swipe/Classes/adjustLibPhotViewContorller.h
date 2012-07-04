//
//  adjustLibraryImageViewContorller.h
//  Petstagram
//
//  Created by Awais Ahmad Qureshi on 5/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#define ZOOM_STEP 1.25
#define STANDARD 54
@protocol libraryPhotoDelegate <NSObject>

-(void) libraryPitureAdjusted:(UIImage *)_image;

@end

@interface adjustLibPhotViewContorller : UIViewController<UIScrollViewDelegate> {

	IBOutlet UIImageView		*picImageView,*overlayImageView;
    UIImage                     *image;
    IBOutlet UIScrollView       *scrollView;
    id<libraryPhotoDelegate>    delegate;

}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withImage:(UIImage *)_image withDelegate:_delegate;
@property (retain,nonatomic) IBOutlet UIScrollView     *scrollView;
@property (retain,nonatomic) UIImage                     *image;
@property (retain,nonatomic) IBOutlet UIImageView		*picImageView,*overlayImageView;
@property (retain,nonatomic) id<libraryPhotoDelegate>   delegate;
-(void) setCameraImage:(UIImage *)_image:(id)_delegate;
-(IBAction) buttonPressed:(id)sender;
-(UIImage *) makeCropImage;
@end
