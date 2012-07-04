#import <UIKit/UIKit.h>
#import "CaptureSessionManager.h"
#import "headerfiles.h"

@protocol AROverlayProtocolDelegate <NSObject>

@optional
-(void)didCancelAROverlayViewController;
-(void)didFinishPickingImageAROverlayViewController:(UIImage *)_img;
-(void)didFinishPickingLibraryImageAROverlayViewController:(UIImage *)_img;
@end


@interface AROverlayViewController : UIViewController <UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    
}
@property (nonatomic, retain) id <AROverlayProtocolDelegate>delegate;
@property (retain) CaptureSessionManager *captureManager;
@property (nonatomic, retain) IBOutlet UIBarButtonItem          *torchBtn;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView  *indicator;
@property (nonatomic, retain) IBOutlet UISlider     *slider;
@property (nonatomic, retain) IBOutlet UIView    *takePhotoBar;
@property (nonatomic, retain) IBOutlet UIView    *retakePhotoBar;
@property (nonatomic, retain) IBOutlet UIView    *libraryButtonBar;
@property (nonatomic, retain) IBOutlet UIImageView  *imageView;
@property (nonatomic, retain) IBOutlet UIButton *btnFlipCamera1;
@property (nonatomic, retain) IBOutlet UIButton *btnFlipCamera2;
@property (nonatomic, retain) IBOutlet UIButton *btnflash1;
@property (nonatomic, retain) IBOutlet UIButton *btnflash2;
@property (nonatomic, retain) IBOutlet UIButton *btnflash3;
@property (nonatomic, assign) BOOL isFrontCamera;
@property (nonatomic, assign) BOOL isFlashAuto;
@property (nonatomic, assign) BOOL isFlashOn;
@property (nonatomic, assign) BOOL isFlashOff;
@property (nonatomic, retain) IBOutlet UIView    *flashButtonView;
@property (nonatomic, retain) IBOutlet UIView    *flipCameraView;
@property (nonatomic, retain) UIImage *croppedAndResizedImage;
 
-(IBAction)sliderValueChanged:(id)sender;
-(IBAction)takePhoto:(id)sender;
-(IBAction)retakePhoto:(id)sender;
//-(IBAction)addMorePhoto:(id)sender;
//-(IBAction)cameraTorch:(id)sender;
-(IBAction)finishCamera:(id)sender;
-(IBAction)cancelCamera:(id)sender;
-(void)bringSubViewsToFront;
//-(void)turnON;
//-(void)turnOFF;
-(IBAction)FlipCameraView:(id)sender;
-(IBAction)FlipCameraView2:(id)sender;

-(IBAction)libraryMethod:(id)sender;
-(IBAction)flash1Method:(id)sender;
-(IBAction)flash2Method:(id)sender;
-(IBAction)flash3Method:(id)sender;
//-(IBAction)libraryMethod:(id)sender;

-(void)cameraCanSwap;
-(void)switchFlashModeAuto:(BOOL)_isAuto On:(BOOL)_isOn Off:(BOOL)_isOff;

@end
