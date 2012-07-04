//
//  SliderCell.h
//  Posterboard
//
//  Created by Apptellect5 on 10/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SliderCell : UITableViewCell 
{
    IBOutlet UILabel *lblRadius;
    IBOutlet UISlider *slider;
}

@property(nonatomic,retain) IBOutlet UILabel *lblRadius;
@property(nonatomic,retain) IBOutlet UISlider *slider;

//-(IBAction)sliderChanged:(id)sender;

@end
