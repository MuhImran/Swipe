//
//  locationData.h
//  Petstagram
//
//  Created by Haris Jawaid on 4/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface locationData : NSObject {
      
    double                   latitude;
    double                   longitude;
    NSString                *locName;
    int                      iden;
    NSString                *locationName;
    
}
@property (nonatomic,retain) NSString                *locationName;
@property double latitude;
@property double longitude;
@property (nonatomic,retain) NSString        *locName;
@property int iden;

@end
