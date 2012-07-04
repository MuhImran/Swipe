//
//  ObjectList.m
//  GG Application
//
//  Created by Haris Jawaid on 12/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ObjectArrayList.h"


NSMutableDictionary *dataArray;
NSMutableArray *productArray;
NSMutableArray *recipiesArray;
NSMutableArray *categoriesArray;
NSMutableArray *storesArray;
NSMutableArray *couponArray;
int userID;
NSMutableArray *myCartArray;
@implementation ObjectArrayList
@synthesize detailItem;

+(void) setRemember:(BOOL)_value
{
	[[NSUserDefaults standardUserDefaults] setBool:_value forKey:@"REMEMBER"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}
+(BOOL) getRemember
{
	return [[NSUserDefaults standardUserDefaults]  boolForKey:@"REMEMBER"];
}
+(void) setuserName:(NSString *) _userName
{
	NSLog(@"%@",_userName);
	[[NSUserDefaults standardUserDefaults] setObject:_userName forKey:@"USERNAME"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}
+(NSString *) getUserName
{
	NSLog(@"%@",[[NSUserDefaults standardUserDefaults]  valueForKey:@"USERNAME"]);
	return [[NSUserDefaults standardUserDefaults]  valueForKey:@"USERNAME"];
	
}
+(void) setUserPassword:(NSString *)_password
{
	[[NSUserDefaults standardUserDefaults] setObject:_password forKey:@"PASSWORD"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}
+(NSString *) getUserPassword
{
	return [[NSUserDefaults standardUserDefaults]  valueForKey:@"PASSWORD"];
	
}
+(void) setEmail:(NSString *)_email
{
	[[NSUserDefaults standardUserDefaults] setObject:_email forKey:@"EMAIL"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	
}
+(NSString *) getEmail
{
	return [[NSUserDefaults standardUserDefaults]  valueForKey:@"EMAIL"];
}
+(void) setPhone:(NSString *)_phone
{
	[[NSUserDefaults standardUserDefaults] setObject:_phone forKey:@"PHONE"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	
}
+(NSString *) getPhone
{
	return [[NSUserDefaults standardUserDefaults]  valueForKey:@"PHONE"];
	
}


+(NSMutableArray *) getMyCartArray
{
	return myCartArray;
}

+(void) removeAllInventoryItem
{
	[myCartArray removeAllObjects];
	
}

+(void) check:(UILabel *) theLabel
{
	
	CGRect frame = [theLabel frame];
	CGSize size = [theLabel.text sizeWithFont:theLabel.font
							   constrainedToSize:CGSizeMake(frame.size.width, 80)
								   lineBreakMode:UILineBreakModeWordWrap];
	CGFloat delta = size.height - frame.size.height;
	if(delta > 0)
	{
		frame.size.height = size.height;
		[theLabel setFrame:frame];
		
	}
	
}
+(void) setDataArray: (NSMutableArray *) _Array:(NSString *) _key
{
	if(!dataArray)
	{
		dataArray=[[NSMutableDictionary alloc] init];
		[dataArray retain];
	}
	NSMutableArray *temp = [[NSMutableArray alloc] initWithArray:_Array];
	
	[dataArray setObject:temp forKey:_key];
	NSLog(@"Dictionary now set to %d",[dataArray count]);
	[temp release];
	
}
+(NSMutableArray *) getDataArray:(NSString *) _key
{
	if(dataArray)
	{
		if([dataArray valueForKey:_key])
		{
			NSMutableArray *temp= (NSMutableArray *) [dataArray valueForKey:_key];
			return temp;
		}
	}
	return 0;
	
}
+(BOOL) checkArray:(NSString *)_key
{
	if([dataArray valueForKey:_key])
		return TRUE;
	return FALSE;
	
}


+(void) setProductArray:(NSMutableArray *)_array
{
  if(!productArray)	
	  productArray = [[NSMutableArray alloc] init];
	else
		[productArray removeAllObjects];
	[productArray addObjectsFromArray:_array];
	NSLog(@"totoal products are  are %d" , [productArray count]);
	[productArray retain];
	
}
+(NSMutableArray *) getProductArray
{
	return productArray;
}
+(BOOL) hasProductArray
{
   if (productArray)
       return TRUE;
    return FALSE;
}

+(void) setRecipiesArray:(NSMutableArray *)_array
{
	if(!recipiesArray)	
		recipiesArray = [[NSMutableArray alloc] init];
	else
	[recipiesArray removeAllObjects];
	[recipiesArray addObjectsFromArray:_array];
	NSLog(@"totoal recipiesArray are  are %d" , [recipiesArray count]);
	[recipiesArray retain];
	
}
+(NSMutableArray *) getRecipiesArray
{
	return recipiesArray;
	
}
+(void) setCategoriesArray:(NSMutableArray *)_array
{
	if(!categoriesArray)	
		categoriesArray = [[NSMutableArray alloc] init];
	else
		[categoriesArray removeAllObjects];
	[categoriesArray addObjectsFromArray:_array];
	NSLog(@"totoal categoriesArray are  are %d" , [categoriesArray count]);
	[recipiesArray retain];
	
}
+(NSMutableArray *) getCategoriesArray
{
	return categoriesArray;
	
}
+(void) setAllStoreArray:(NSMutableArray *)_array
{
	if(!storesArray)	
		storesArray = [[NSMutableArray alloc] init];
	else
		[storesArray removeAllObjects];
	[storesArray addObjectsFromArray:_array];
	NSLog(@"totoal storesArray are  are %d" , [storesArray count]);
	[recipiesArray retain];
	
}
+(NSMutableArray *) getAllStoreArray
{
	return storesArray;
}

+(void) setUserID:(int)_userID
{
	
		userID= _userID;
		
}
+(void) setCouponArray:(NSMutableArray *)_array
{
	if(!couponArray)	
		couponArray = [[NSMutableArray alloc] init];
	else
		[couponArray removeAllObjects];
	[couponArray addObjectsFromArray:_array];
	NSLog(@"totoal storesArray are  are %d" , [couponArray count]);
	[couponArray retain];
	
}
+(NSMutableArray *) getCouponArray
{
	return couponArray;
	
}

+(int) getUserID
{
	return userID;
	//return @"18";
}
+(NSString *) getRequestFormat
{
	
  return  [NSString stringWithFormat:
	 @"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"	
	 "<soap:Body>\n" 
	 "<XXXX xmlns=\"http://tempuri.org/\">\n"
	 "</XXXX>\n"
	 "</soap:Body>\n"
	 "</soap:Envelope>\n"];
	
}
+(NSString *) getParameterRequestFormat
{
	
	return  [NSString stringWithFormat:
			 @"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"	
			 "<soap:Body>\n" 
			 "<XXXX xmlns=\"http://tempuri.org/\">\n"
			 "YYYY"
			 "</XXXX>\n"
			 "</soap:Body>\n"
			 "</soap:Envelope>\n"];
	
}
+(NSString *) getRequestFormat2
{
    return  [NSString stringWithFormat:
			 @"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns=\"com.cellfire.webservice.QFinderService\">\n"	
			 "<soap:Body><getActiveCouponIds></getActiveCouponIds></soap:Body></soap:Envelope>\n"];
}
	@end
