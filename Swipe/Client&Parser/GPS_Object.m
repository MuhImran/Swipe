//
//  GPS_Object.m
//  Night life
//
//  Created by Ahmad on 24/03/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GPS_Object.h"
#import "clientObject.h"
#import "SingletonClass.h"


@implementation GPS_Object
@synthesize testingLocation;
@synthesize manager1;
@synthesize delegate;

//static GPS_Object *sharedInstance = nil;

static GPS_Object *sharedInstance = nil;

// Get the shared instance and create it if necessary.
+ (GPS_Object*)sharedInstance {
    if (sharedInstance == nil) {
        sharedInstance = [[super allocWithZone:NULL] init];
		
    }
	
    return sharedInstance;
}

/*
+(id)alloc
{
	@synchronized([GPS_Object class])
	{
		NSAssert(_sharedGPX == nil, @"Attempted to allocate a second instance of a singleton.");
		_sharedGPX = [super alloc];
		return _sharedGPX;
	}
    
	return nil;
}*/

-(id)init {
	self = [super init];
	if (self != nil) {
		// initialize stuff here
        CLLocationManager *location = [[CLLocationManager alloc] init];
        self.manager1 = location;
	}
    
	return self;
}
// We don't want to allocate a new instance, so return the current one.
+ (id)allocWithZone:(NSZone*)zone {
    return [[self sharedInstance] retain];
}

// Equally, we don't want to generate multiple copies of the singleton.
- (id)copyWithZone:(NSZone *)zone {
    return self;
}

// Once again - do nothing, as we don't have a retain counter for this object.
- (id)retain {
    return self;
}

// Replace the retain counter so we can never release this object.
- (NSUInteger)retainCount {
    return NSUIntegerMax;
}
/*
// This function is empty, as we don't want to let the user release this object.
- (void)release {
	
}
*/



/*
// Get the shared instance and create it if necessary.
+ (GPS_Object*)sharedInstance {
    if (sharedInstance == nil) {
        sharedInstance = [[super allocWithZone:NULL] init];
		
    }
	
    return sharedInstance;
}

-(id)init {
	if ((self = [super init])) {
        
            CLLocationManager *location = [[CLLocationManager alloc] init];
            self.manager1 = location;
		
	}
	
	return self;
}
// We don't want to allocate a new instance, so return the current one.
+ (id)allocWithZone:(NSZone*)zone {
    return [[self sharedInstance] retain];
}

// Equally, we don't want to generate multiple copies of the singleton.
- (id)copyWithZone:(NSZone *)zone {
    return self;
}

// Once again - do nothing, as we don't have a retain counter for this object.
- (id)retain {
    return self;
}

// Replace the retain counter so we can never release this object.
- (NSUInteger)retainCount {
    return NSUIntegerMax;
}

// This function is empty, as we don't want to let the user release this object.
- (void)release {
	
}


//Do nothing, other than return the shared instance - as this is expected from autorelease.
- (id)autorelease {
    return self;
}
 */

- (void) setCallBack
{
	//Latitude = 40.8856, Longitude = -73.8956
     
     
	if(!testingLocation)
		testingLocation = [[CLLocation alloc] initWithLatitude:40.8856 longitude:-73.8956];
    
    testingLocation = [[CLLocation alloc] initWithLatitude:40.8856 longitude:-73.8956];
	
    if(delegate && [delegate respondsToSelector:@selector(newGPXPoints::)])
		[delegate performSelector:@selector(newGPXPoints::) withObject:[NSNumber numberWithBool:TRUE] withObject:testingLocation];
	
}
- (void)cleanUp {
	//taskInProgress = NO;
	
	self.delegate = nil;
}
-(void) stopUpdatingLocating
{
	//if(manager1)
		[self.manager1 stopUpdatingLocation];
        self.delegate=nil;
		
}
-(void) startUpdatingLocating:(id)_delegate
{
	self.delegate = _delegate;
	
	if(!self.manager1)
		self.manager1 = [[CLLocationManager alloc] init];
	
	if ([CLLocationManager locationServicesEnabled] ) 
	{
		NSLog(@"start update location");
		[self.manager1 setDelegate:self];
        self.manager1.desiredAccuracy = kCLLocationAccuracyBest;
		[self.manager1 startUpdatingLocation];
		[self.manager1 startUpdatingHeading];
		
	}
	else {
		NSLog(@"Location service disabled");
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Location service is disabled" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
	}
}


#pragma mark Location Manager Interactions 

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation 
{
    NSLog(@"new location : %@",newLocation);
    //[[SingletonClass sharedInstance] setMyCurrentLocation:newLocation];
    if(delegate && [delegate respondsToSelector:@selector(newGPXPoints::)])
		[delegate performSelector:@selector(newGPXPoints::) withObject:[NSNumber numberWithBool:TRUE] withObject:newLocation];
    [self stopUpdatingLocating];
}
    /*
    if(!testingLocation)
    testingLocation = [[CLLocationManager alloc] init];
    
    
    NSLog(@"location timestamp: %@",newLocation.timestamp);
    NSLog(@"location timestamp: %f",[newLocation.timestamp timeIntervalSinceReferenceDate]);
    NSLog(@"current time: %f",[NSDate timeIntervalSinceReferenceDate]);
    NSLog(@"difference between location timestamp and current time: %f",[NSDate timeIntervalSinceReferenceDate] - [newLocation.timestamp timeIntervalSinceReferenceDate]);
    NSLog(@"NEW LOCATION: %f, %f",newLocation.coordinate.latitude,newLocation.coordinate.longitude);
    
    
    if ([NSDate timeIntervalSinceReferenceDate] - [newLocation.timestamp timeIntervalSinceReferenceDate] > 60){
        NSLog(@"is greater than 60");
        manager.delegate = nil; 
        [manager startUpdatingLocation];
        [manager stopUpdatingLocation];
        [manager autorelease];
   
            testingLocation = newLocation;
    }else{
        NSLog(@"is less than 60");
            testingLocation = newLocation;
    }
    
    
	if(newLocation)
        [(id) targetForExecution performSelector:methodForExecution withObject:testingLocation withObject:TRUE];
    else
        [(id) targetForExecution performSelector:methodForExecution withObject:nil withObject:FALSE];
	
    
    
    
    */
	/*
	if(!oldLocation)
	{
	
		
		if(!hasGPX)
			[(id) targetForExecution performSelector:methodForExecution withObject:testingLocation withObject:TRUE];
		hasGPX = TRUE;
		
	}  
	else
	{
		[(id) targetForExecution performSelector:methodForExecution withObject:testingLocation withObject:TRUE];
		
	}
  */

	 
//	[self displayAlertTest];
    
    
    
    
    
    
	
//}
/*
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	
#ifdef TARGET_IPHONE_SIMULATOR
    // Cupertino
    CLLocation *simulatorLocation = [[CLLocation alloc] initWithLatitude:51.500152 longitude:-0.126236];
    [self locationManager:manager didUpdateToLocation:simulatorLocation fromLocation:nil];
    [simulatorLocation release];
#else
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ErrorNotification"  object:NSLocalizedString(@"GPS-coordinates could not be detected",@"")];
#endif
	
}
*/

- (void)locationManager: (CLLocationManager *)manager didFailWithError: (NSError *)error
{
	
    
    //[manager1 stopUpdatingLocation];
	//[self stopUpdatingLocating];
	NSLog(@"error%@",error);
	switch([error code])
	{
		case kCLErrorNetwork: // general, network-related error
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Unable to determine your position" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Relocate", nil];
			[alert show];
			[alert release];
		}
			break;
		case kCLErrorDenied:
        {
            NSLog(@"Location service denied");
//			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Unable to determine your position" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Relocate", nil];
//			[alert show];
//			[alert release];
		}
			break;
		default:
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Unable to determine your position" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Relocate", nil];
			[alert show];
			[alert release];
		}
			break;
	}
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	
	if(buttonIndex == 1)
	 {
		 [self startUpdatingLocating:self.delegate];
	 }
	else
    {
		if(delegate && [delegate respondsToSelector:@selector(newGPXPoints::)])
            [delegate performSelector:@selector(newGPXPoints::) withObject:[NSNumber numberWithBool:FALSE] withObject:nil];
        [self stopUpdatingLocating];

    }
}

@end
