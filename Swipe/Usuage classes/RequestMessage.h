//
//  RequestMessage.h
//  ObjectiveC-CLIENT
//
//  Created by iPhone Station1 on 02/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RequestMessage : NSObject {

	NSMutableArray *parameter;
	NSString *returnType;
	NSString *serviceType;
	
	
}
-(id) init;

-(void) setParameter: (id) parameters;
-(id) getParameter; 
-(void)removeLastParameter;
-(void) setServiceType: (NSString *) serviceType1;
//-(NSString *) getServiceType;
-(void) setReturnType: (NSString *) returnType1;
-(NSString *) getReturnType;
-(NSDictionary *)getRequestDictionary;

-(NSDictionary *)getRequestDictionary1;


@end

