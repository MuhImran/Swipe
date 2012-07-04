//
//  GPS_Object.h
//  Night life
//
//  Created by Ahmad on 24/03/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol GPXDelegate <NSObject>
@optional
-(void) newGPXPoints:(NSNumber*)_boolValue:(CLLocation *)_newlocation;

@end

@interface GPS_Object : NSObject <CLLocationManagerDelegate> {
	
            CLLocationManager           *manager1;
                CLLocation              *testingLocation; 
              id<GPXDelegate>             delegate;
    
}
@property (retain,nonatomic) id<GPXDelegate>  delegate;
@property (retain,nonatomic) CLLocation *testingLocation;
@property (retain,nonatomic) CLLocationManager *manager1;
//+(GPS_Object*)sharedMyGPX;
+ (GPS_Object*)sharedInstance;
-(void) startUpdatingLocating:(id)_delegate;
-(void) stopUpdatingLocating;
//-(void) setDelegateInvalid;
- (void) setCallBack;

@end
