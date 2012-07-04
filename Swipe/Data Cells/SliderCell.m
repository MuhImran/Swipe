//
//  SliderCell.m
//  Posterboard
//
//  Created by Apptellect5 on 10/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SliderCell.h"
#import "commonUsedMethods.h"

@implementation SliderCell

@synthesize lblRadius;
@synthesize slider;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//-(IBAction)sliderChanged:(id)sender
//{
//    UISlider *slider1 = (UISlider *)sender;
//    int value = (int)slider1.value;
//    value = value * 50 +1500;
//    [commonUsedMethods setDefaultRadius:[NSString stringWithFormat:@"%d",value]];
//    //[settingTable reloadData];
//}

- (void)dealloc
{
    [lblRadius release];
    [slider release];
    [super dealloc];
}

@end
