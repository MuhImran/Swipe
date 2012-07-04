//
//  spotDataObject.h
//  Petstagram
//
//  Created by Awais Ahmad Qureshi on 5/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface spotDataObject : NSObject {
    
    
    NSString        *media;
	NSNumber        *iden;
    NSString        *pictureUrl,*URLString,*titleString,*textString;
  	NSMutableArray  *photoArray;
    
    
}
@property (nonatomic,retain) NSMutableArray  *photoArray;
@property (nonatomic,retain) NSString *media;
@property (nonatomic,retain) NSNumber *iden;
@property (nonatomic,retain) NSString        *pictureUrl,*URLString,*titleString,*textString;
@end