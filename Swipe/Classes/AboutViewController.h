//
//  settingViewController.h
//  Petstagram
//
//  Created by Awais Ahmad Qureshi on 5/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AboutViewController : UIViewController {
    IBOutlet UIWebView *helpView ; 
    NSString *htmlString;
		
	
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withText:(NSString *)_text;
@property (retain,nonatomic)  IBOutlet UIWebView *helpView;
@property (retain,nonatomic)  NSString *htmlString;
@end

