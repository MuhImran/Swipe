//
//  Main_Json.m
//  Client
//
//  Created by iPhone Dev on 14/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Main_Json.h"

#import"RequestMessage.h"
#import "settingValues.h"



@implementation Main_Json


-(id) init
{
	json = [[SBJSON alloc]init];
	
	return self;
	
}

-(NSString *) returnJsonString: (RequestMessage *)request_obj: (NSString*)temp
{
		return 0;
	
}
/*
 +(NSString *) getlogin;
 +(NSString *) getRegistration;
 +(NSString *) getForget;
 
 */



/*
//  main.m
//  test
//
//  Created by Muhammad Amir Pervaiz on 24/09/2009.
//  Copyright Archimedes Services  2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import<Foundation/Foundation.h>
#import "rootobject.h"
#import "object.h"
#import "JSON.h"

int main(int argc, char *argv[]) {
    
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	//   int retVal = UIApplicationMain(argc, argv, nil, nil);
	//   [pool release];
	//  return retVal;
	
	object *obj= [[object alloc]init];
	
	[obj setFirstname:@"ahmad"];
	[obj setLastname:@"imtiaz"];	
	[obj setAge:22];	
	[obj setGender:@"male"];	
	[obj setAddress:@"lahore"];
	
	
	object *obj2=[[object alloc]init];
	
	[obj2 setFirstname:@"amir"];
	[obj2 setLastname:@"pervaiz"];	
	[obj2 setAge:22];	
	[obj2 setGender:@"female"];	
	[obj2 setAddress:@"lahore"];
	
	
	
	rootobject *root=[[rootobject alloc]init];
	
	[root setCount:2];
	[root addInArray: obj];
	[root addInArray: obj2];
	//	[root cout];
	
	
	SBJSON *json = [[SBJSON alloc]init];
	
	
	NSDictionary * test =[root getrootDictionary];
	
	
	for(id key in test)
		NSLog(@"key:%@,value:%@",key,[test objectForKey:key]);
	
	NSString *jsonString = [json stringWithObject:test error:nil];
	
	[obj release];
	[obj2 release];
	[root release];	
	
	
	NSLog (jsonString);
	
	[json release];	
	
	
	NSLog (@"MAIN RUNNING FINE");
		
	SBJSON *json2 = [[SBJSON alloc]init];*/
	/*	NSArray *jsonArray = [json objectWithString:jsonString error:nil];
	 
	 for (int i=0; i&lt;[jsonArray count]; i++) {
	 id tmp = [jsonArray objectAtIndex:i];
	 Person *p = [[Person alloc] initWithName:[tmp valueForKey:@"name"] andAge: [[tmp valueForKey:@"age"] intValue]];
	 NSLog(@"%@ is %i years old.", [p name], [p age]);
	 [p release];
	 }
	 ///////////////
	NSString *sample = @"{\"list\":[{\"gender\":\"Male\",\"age\":22,\"lastname\":\"Almas\",\"firstname\":\"Muhammad\",\"address\":\"Hasil Pur Bahawal Pur\"},{\"gender\":\"Male\",\"age\":25,\"lastname\":\"Sohaib\",\"firstname\":\"Mohammad\",\"address\":null}],\"Count\":45}";
	NSLog(sample);
	
	
	id temp = [json2 objectWithString:sample error:nil];	
	rootobject *retrived_object = [[rootobject alloc] init];
	
	[retrived_object setCount: [[temp valueForKey:@"Count"] intValue]];
	//	NSLog(@"Count = %i", [retrived_object getCount]);
	
	NSMutableArray *temp_array = [temp valueForKey:@"list"]; 
	
	//NSLog(@"array size = %i",[temp_array count]);
	
	for(int x=0; x<[temp_array count]; x++)
	{
		id temp2 = [temp_array objectAtIndex:x];
		object *temp_object= [[object alloc]init];
		[temp_object setFirstname: [temp2 valueForKey:@"firstname"]];
		[temp_object setLastname: [temp2 valueForKey:@"lastname"]];
		[temp_object setGender: [temp2 valueForKey:@"gender"]];
		[temp_object setAddress: [temp2 valueForKey:@"address"]];
		[temp_object setAge: [[temp2 valueForKey:@"age"] intValue]];
		
		//		NSLog([temp_object getFirstname]);	
		[retrived_object addInArray: temp_object];
	}	
	
	NSLog(@"%i",[retrived_object getCount]);
	
	
	[json2 release];
	[retrived_object release];
	
	//	[jsonData release];
	

	
	[pool release];
	return 0;
}
*/

@end
