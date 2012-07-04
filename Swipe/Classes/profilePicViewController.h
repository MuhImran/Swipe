//
//  ReaderSampleViewController.h
//  ReaderSample
//
//  Created by spadix on 8/4/10.
//

#import <UIKit/UIKit.h>
#import "AROverlayViewController.h"

@class OverlayView;
@class addFilterViewController;
@class adjustLibPhotViewContorller;

@protocol profilePictureDelegate <NSObject>
-(void) pictureHasTaken:(UIImage *)_image;
@end


@interface profilePicViewController: UIViewController<UINavigationControllerDelegate, AROverlayProtocolDelegate>

{
 
    IBOutlet UIImageView			*picImageView;
    BOOL							isfreshPicture,isRetakePicture,hasPhoto;
    UIImage							*image;
    BOOL							isFlushOn,isFrontOn,enableCrossButton;
    id<profilePictureDelegate>      delegate;
	IBOutlet UIActivityIndicatorView  *profileActivity;
    IBOutlet UIButton               *flushButton,*cameraButton;
    // UIImagePickerController         *imgPicker;
	AROverlayViewController *arCameraOverlay;
    
	
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withDelegate:(id)_delegate withPic:(UIImage *)_image;
//@property (retain,nonatomic) UIImagePickerController         *imgPicker;
@property (retain,nonatomic) id<profilePictureDelegate>   delegate;
@property (retain,nonatomic) IBOutlet UIImageView *picImageView;
@property (retain,nonatomic)  UIImage *image;
@property (retain,nonatomic)  IBOutlet UIActivityIndicatorView  *profileActivity;
@property (retain,nonatomic)  IBOutlet UIButton  *flushButton,*cameraButton;
@property (nonatomic,retain) AROverlayViewController *arCameraOverlay;

-(IBAction) getLibraryPicture:(id)sender;
-(IBAction) getCameraPicture:(id)sender;
-(void) openCameraView;
//-(IBAction) showShareView:(id)sender;
-(void) displayImage:(UIImage *)_image;
-(IBAction) flushOptionchange:(id)sender;
-(IBAction) cameraOptionchange:(id)sender;
-(IBAction) removeThisView:(id)sender;
//-(void) callNewViewBaseOnPhoto;
-(void) loadAlertView:(NSString *)_msg;
@end
