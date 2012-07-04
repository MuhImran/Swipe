//
//  NearbyLocationObject.h
//  Posterboard
//
//  Created by Apptellect5 on 9/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NearbyLocationObject : NSObject 
{
    double loc_lat;
    double loc_long;
    NSString *loc_id;
    NSString *loc_name;
    NSString *loc_vicinity;
    
}

@property double loc_lat;
@property double loc_long;
@property (nonatomic,retain) NSString *loc_id;
@property (nonatomic,retain) NSString *loc_name;
@property (nonatomic,retain) NSString *loc_vicinity;



@end
