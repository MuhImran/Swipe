//
//  user.h
//  Petstagram
//
//  Created by Haris Jawaid on 4/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface tokeInfo : NSObject {
    
    NSString        *name,*userName,*password;
	NSNumber        *iden;
    NSString        *imgURL;
    NSString        *accessToken;
}

@property (nonatomic,retain) NSString *name,*userName,*password;
@property (nonatomic,retain) NSNumber *iden;
@property (nonatomic,retain) NSString *imgURL;
@property (nonatomic,retain) NSString *accessToken;

@end
