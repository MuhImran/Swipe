//
//  RequestMessage.m
//  ObjectiveC-CLIENT
//
//  Created by iPhone Station1 on 02/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import"RequestMessage.h"


@implementation RequestMessage

-(id) init
{
	parameter = [[NSMutableArray alloc]init];
	returnType = @"null";

	return self;
}


-(void) setParameter: (id) parameters
{
	[self->parameter addObject:parameters];
	
}




-(id) getParameter
{
	//not implemented yet
	return parameter;
}


-(void)removeLastParameter
{
	[parameter removeLastObject];
}


-(void) setServiceType: (NSString *) serviceType1
{
	self->serviceType = serviceType1;
}

/*-(ServiceType *) getServiceType;
{
	return serviceType;
}
*/
-(void) setReturnType: (NSString *) returnType1;
{
	self->returnType = returnType1;
}

-(NSString *) getReturnType;
{
	return returnType;
}

-(NSDictionary *)getRequestDictionary
{
//	return [NSDictionary dictionaryWithObjectsAndKeys:self->serviceType, @"serviceType",[self->parameter objectAtIndex:0], @"username", [self->parameter objectAtIndex:1], @"password", nil];

	return [NSDictionary dictionaryWithObjectsAndKeys:self->serviceType, @"serviceType",self->parameter,@"parameters",self->returnType,@"returnType",nil];

}

-(NSDictionary *)getRequestDictionary1
{
	//	return [NSDictionary dictionaryWithObjectsAndKeys:self->serviceType, @"serviceType",[self->parameter objectAtIndex:0], @"username", [self->parameter objectAtIndex:1], @"password", nil];
	
	return [NSDictionary dictionaryWithObjectsAndKeys:self->serviceType, @"serviceType",self->parameter,@"parameters",self->returnType,@"returnType",nil];
	
}



@end



