//
//  Friend.h
//  EpicRewards
//
//  Created by Eugene Woo on 10-11-12.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Friend : NSObject {
	NSString *name;
	NSString *iden;
}

@property (nonatomic,retain) NSString *name;
@property (nonatomic,retain) NSString *iden;


@end
