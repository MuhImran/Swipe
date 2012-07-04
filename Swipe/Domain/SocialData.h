//
//  SocialData.h
//  Swipe
//
//  Created by imran on 6/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SocialData : NSManagedObject

@property (nonatomic, retain) NSString * facebook;
@property (nonatomic, retain) NSString * facebookURL;
@property (nonatomic, retain) NSString * flicker;
@property (nonatomic, retain) NSString * flickerURL;
@property (nonatomic, retain) NSString * linkedIn;
@property (nonatomic, retain) NSString * linkedInURL;
@property (nonatomic, retain) NSString * mySpace;
@property (nonatomic, retain) NSString * mySpaceURL;
@property (nonatomic, retain) NSString * twitter;
@property (nonatomic, retain) NSString * twitterURL;

@end
