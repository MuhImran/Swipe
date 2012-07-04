//
//  Main_Json.h
//  Client
//
//  Created by iPhone Dev on 14/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestMessage.h"
#import "JSON.h"
@interface Main_Json : NSObject {

		SBJSON *json;
}


-(NSString *) returnJsonString: (RequestMessage *) request_obj: (NSString*)temp;
//-(NSString *) returnJsonSuperDeal:(RequestMessage*)request_obj;


@end
