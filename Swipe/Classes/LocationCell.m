//
//  LocationCell.m
//  Posterboard
//
//  Created by Apptellect5 on 9/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LocationCell.h"


@implementation LocationCell

@synthesize lblLoc_Name,lblLoc_Address;

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

- (void)dealloc
{
    [lblLoc_Name release];
    [lblLoc_Address release];
    [super dealloc];
}

@end
