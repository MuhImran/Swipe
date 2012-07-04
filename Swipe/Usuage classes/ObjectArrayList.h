//
//  ObjectList.h
//  GG Application
//
//  Created by Haris Jawaid on 12/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ProductObject;

@interface ObjectArrayList : NSObject {
	
	ProductObject *detailItem;

}
@property (nonatomic,retain) ProductObject *detailItem;
+(void) setRemember:(BOOL)_value;
+(BOOL) getRemember;
+(void) setuserName:(NSString *) _userName;
+(NSString *) getUserName;
+(void) setUserPassword:(NSString *)_password;
+(NSString *) getUserPassword;
+(void) setEmail:(NSString *)_email;
+(NSString *) getEmail;
+(void) setPhone:(NSString *)_phone;
+(NSString *) getPhone;


+(void) check:(UILabel *) theLabel;
+(void) setDataArray: (NSMutableArray *) _Array:(NSString *) _key;
+(NSMutableArray *) getDataArray:(NSString *) _key;
+(BOOL) checkArray:(NSString *)_key;




+(NSString *) getRequestFormat;
+(NSString *) getParameterRequestFormat;


+(void) setProductArray:(NSMutableArray *)_array;
+(NSMutableArray *) getProductArray;
+(BOOL) hasProductArray;


+(void) setCategoriesArray:(NSMutableArray *)_array;
+(NSMutableArray *) getCategoriesArray;

+(void) setAllStoreArray:(NSMutableArray *)_array;
+(NSMutableArray *) getAllStoreArray;


+(void) setRecipiesArray:(NSMutableArray *)_array;
+(NSMutableArray *) getRecipiesArray;


+(void) setCouponArray:(NSMutableArray *)_array;
+(NSMutableArray *) getCouponArray;

+(void) setUserID:(int)_userID;
+(int) getUserID;


//+(void) addProductToCart:(ProductObject *)_productObject;
+(NSMutableArray *) getMyCartArray;
+(void) removeAllInventoryItem;

@end
