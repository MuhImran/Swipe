//
//  ReaderSampleViewController.h
//  ReaderSample
//
//  Created by spadix on 8/4/10.
//

#import <UIKit/UIKit.h>

@class OverlayView;
@class addFilterViewController;
@class adjustLibPhotViewContorller;

@protocol cameraViewDelegate <NSObject>
@optional
-(void) pictureHasTaken:(UIImage *)_image:(NSNumber *)num;
-(void) showFilterView:(UIImage *)_image;
@end
@interface cameraViewController: UIViewController<UIScrollViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>

{
     OverlayView					*overlay;
    IBOutlet UIImageView			*picImageView;
    BOOL							isfreshPicture,isRetakePicture;
    UIImage							*image;
	addFilterViewController			*AFVC;
	adjustLibPhotViewContorller     *ALIVC;
	IBOutlet UIButton               *flushButton,*cameraButton;
    BOOL							isFlushOn,isFrontOn,enableCrossButton,hasPhoto;
    int                             option;
    UIImagePickerController         *imgPicker;
	
	
	
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withOption:(int)_option;
@property (nonatomic, retain) UIImagePickerController *imgPicker;
@property int option;
@property (retain,nonatomic) IBOutlet UIView *helpView;
@property (retain,nonatomic) IBOutlet UIImageView *picImageView;
@property (retain,nonatomic)  UIImage *image;
@property (retain,nonatomic) OverlayView *overlay;
@property (retain,nonatomic)  IBOutlet UIButton *takePic;
@property (retain,nonatomic) addFilterViewController  *AFVC;
@property (retain,nonatomic) adjustLibPhotViewContorller *ALIVC;
@property (retain,nonatomic) IBOutlet UIButton *flushButton,*cameraButton;
-(IBAction) getLibraryPicture:(id)sender;
-(IBAction) getCameraPicture:(id)sender;
-(void) openCameraView;
//-(IBAction) showShareView:(id)sender;
-(void) displayImage:(UIImage *)_image;
//-(IBAction) flushOptionchange:(id)sender;
//-(IBAction) cameraOptionchange:(id)sender;
-(IBAction) removeThisView:(id)sender;
-(void) callNewViewBaseOnPhoto;
-(void) setCameraSetting;
-(void) loadAlertView:(NSString *)_msg;
@end
