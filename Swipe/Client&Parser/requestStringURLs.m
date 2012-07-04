//
//  requestStringURLs.m
//  Petstagram
//
//  Created by Awais Ahmad Qureshi on 5/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "requestStringURLs.h"
#import "domainClasses.h"
#import "headerfiles.h"
#import "tokeInfo.h"
#import "petsObject.h"
#import "GPS_Object.h"


@implementation requestStringURLs

+(NSString *) getUserSearchRequest:(NSString *)_searchText :(BOOL)isPull
{
    
    tokeInfo *tokeninfo = [[SingletonClass sharedInstance] getTokenInformation];
    
    NSMutableString *url = [[[NSMutableString alloc] init] autorelease];
    [url setString:kServerIp];
    [url appendFormat:@"/posts/search"];
    //[url appendString:_searchText];
    [url appendString:@"?access_token="];
    [url appendString:tokeninfo.accessToken];
	[url appendString:[NSString stringWithFormat:@"&keyword=%@",_searchText]];
    if(isPull && [DataModel hasDataInDictionary:2])
	{
		NSMutableArray *array = [DataModel getDataInDictionary:2];
		FeedData *feed = [array objectAtIndex:0];
		[url appendString:[NSString stringWithFormat:@"&blocksize=%d&offset=%d",[feed.blocksize intValue],[feed.offset intValue]+1]];
	}
	NSLog(@"%@",url);
    return url;
    
}

+(NSString *) getUserPopularRequest:(BOOL)isPull
{
	
    tokeInfo *tokeninfo = [[SingletonClass sharedInstance] getTokenInformation];
    
    NSMutableString *url = [[[NSMutableString alloc] init] autorelease];
    [url setString:kServerIp];
    [url appendFormat:@"/photo/popular"];
    [url appendString:@"?access_token="];
    [url appendString:tokeninfo.accessToken];
	
	if(isPull && [DataModel hasDataInDictionary:2])
	{
		NSMutableArray *array = [DataModel getDataInDictionary:2];
		FeedData *feed = [array objectAtIndex:0];
		[url appendString:[NSString stringWithFormat:@"&blocksize=%d&offset=%d",[feed.blocksize intValue],[feed.offset intValue]+1]];
	}
    
    NSLog(@"%@",url);
    
    return url;
    
}

+(NSString *) getUserNearByRequest:(CLLocation *)_newlocation :(BOOL)isPull :(int)_offset
{
    tokeInfo *tokeninfo = [[SingletonClass sharedInstance] getTokenInformation];
    
    NSMutableString *url = [[[NSMutableString alloc] init] autorelease];
    [url setString:kServerIp];
    [url appendFormat:@"/posts/nearby?"];
    [url appendString:@"access_token="];
    [url appendString:tokeninfo.accessToken];
    [url appendFormat:@"&lat=%f&long=%f",_newlocation.coordinate.latitude,_newlocation.coordinate.longitude];
    [url appendFormat:@"&radius=%@",[commonUsedMethods getDefaultRadius]];
	
//    /posts/nearby?access_token=42a07163dc1598d1a832126af23bf10c&blocksize=&offset=&lat=31.56203514&long=74.33502086&radius=1500
    
	if(isPull && [DataModel hasDataInDictionary:3])
	{
		NSMutableArray *array = [DataModel getDataInDictionary:3];
		FeedData *feed = [array objectAtIndex:0];
		[url appendString:[NSString stringWithFormat:@"&blocksize=%d&offset=%d",[feed.blocksize intValue],_offset]];
	}
	
    NSLog(@"%@",url);
    return url;
    
}

+(NSString *) getUserFeedRequest:(BOOL)isPull
{
    tokeInfo *tokeninfo = [[SingletonClass sharedInstance] getTokenInformation];
    
    NSMutableString *url = [[[NSMutableString alloc] init] autorelease];
    [url setString:kServerIp];
    [url appendFormat:@"/posts"];
   // [url appendString:[NSString stringWithFormat:@"%d",[tokeninfo.iden intValue]]];
   // [url appendString:@"/feed?access_token="];   
     [url appendString:@"/recent?access_token="];
    [url appendString:tokeninfo.accessToken];//combinedFeed
	
    if(isPull && [DataModel hasDataInDictionary:1])
	{
		NSMutableArray *array = [DataModel getDataInDictionary:1];
        FeedData *feed = [array objectAtIndex:0];
        [url setString:@""];
        [url setString:kServerIp];
        [url appendFormat:@"/posts"];
      //  [url appendString:[NSString stringWithFormat:@"%d",[tokeninfo.iden intValue]]];
        [url appendString:@"/recent?access_token="];
        [url appendString:tokeninfo.accessToken];
		[url appendString:[NSString stringWithFormat:@"&blocksize=%d&offset=%d",[feed.blocksize intValue],[feed.offset intValue]+1]];
	}
    
    NSLog(@"%@",url);
    
    return url;
    
}
+(NSString *) getTopFeedRequest:(BOOL)isPull
{
    tokeInfo *tokeninfo = [[SingletonClass sharedInstance] getTokenInformation];
    
    NSMutableString *url = [[[NSMutableString alloc] init] autorelease];
    [url setString:kServerIp];
    [url appendFormat:@"/posts"];
    // [url appendString:[NSString stringWithFormat:@"%d",[tokeninfo.iden intValue]]];
    // [url appendString:@"/feed?access_token="];   
    [url appendString:@"/top?access_token="];
    [url appendString:tokeninfo.accessToken];//combinedFeed
	
    if(isPull && [DataModel hasDataInDictionary:4])
	{
		NSMutableArray *array = [DataModel getDataInDictionary:4];
        FeedData *feed = [array objectAtIndex:0];
        [url setString:@""];
        [url setString:kServerIp];
        [url appendFormat:@"/posts"];
        //  [url appendString:[NSString stringWithFormat:@"%d",[tokeninfo.iden intValue]]];
        [url appendString:@"/top?access_token="];
        [url appendString:tokeninfo.accessToken];
		[url appendString:[NSString stringWithFormat:@"&blocksize=%d&offset=%d",[feed.blocksize intValue],[feed.offset intValue]+1]];
	}
    
    NSLog(@"%@",url);
    
    return url;
    
}

+(NSString *) getUserActivityRequest:(BOOL)isPull
{
    tokeInfo *tokeninfo = [[SingletonClass sharedInstance] getTokenInformation];
    
    NSMutableString *url = [[[NSMutableString alloc] init] autorelease];
    [url setString:kServerIp];
    [url appendFormat:@"/users/"];
    [url appendString:[NSString stringWithFormat:@"%d",[tokeninfo.iden intValue]]];
	[url appendFormat:@"/incomingActivity"];//incomingActivity
    [url appendString:@"?access_token="];
    [url appendString:tokeninfo.accessToken];
    if(isPull && [DataModel hasDataInDictionary:4])
	{
		NSMutableArray *array = [DataModel getDataInDictionary:4];
		ActivityController *feed = [array objectAtIndex:0];
		[url appendString:[NSString stringWithFormat:@"&blocksize=%d&offset=%d",[feed.blocksize intValue],[feed.offset intValue]+1]];
	}
    
    NSLog(@"%@",url);
    
    return url;
}

+(NSString *) getUserProfileRequest:(NSNumber *)_iden :(int)_blockSize :(int)_offset
{
   tokeInfo *tokeninfo = [[SingletonClass sharedInstance] getTokenInformation];
    NSMutableString *url = [[[NSMutableString alloc] init] autorelease];
    [url setString:kServerIp];
    [url appendFormat:@"/users/detail"];
    //[url appendString:[NSString stringWithFormat:@"%d",[_iden intValue]]];
    [url appendString:@"?access_token="];
    [url appendString:tokeninfo.accessToken];
    [url appendString:[NSString stringWithFormat:@"&userid=%d",[_iden intValue]]];
    //[url appendString:[commonUsedMethods getClientSecret]];
//    if(_isPull && [DataModel hasDataInDictionary:6])
//	{
//		NSMutableArray *array = [DataModel getDataInDictionary:6];
//		ActivityController *feed = [array objectAtIndex:0];
//		[url appendString:[NSString stringWithFormat:@"&blocksize=%d&offset=%d",/*[feed.blocksize intValue],*/[feed.offset intValue]+1]];
//	}
//    else
//        [url appendString:@"&blocksize=24&offset=0"];
    [url appendString:[NSString stringWithFormat:@"&blocksize=%d&offset=%d",_blockSize,_offset]];
    
    NSLog(@"%@",url);
    
    return url;
    
}

+(NSString *) getUserSupportRequest:(NSNumber *)_iden :(BOOL)_value  //posts/support
{
	tokeInfo *tokeninfo = [[SingletonClass sharedInstance] getTokenInformation];
    NSMutableString *url = [[[NSMutableString alloc] init] autorelease];
    [url setString:kServerIp];
    [url appendFormat:@"/posts"];
   // [url appendString:[NSString stringWithFormat:@"%d",[_iden intValue]]];
    if(_value)
    [url appendString:@"/support?postid="];
    else
      [url appendString:@"/unsupport?postid="];   
   // [url appendString:[NSString stringWithFormat:@"%d",[tokeninfo.iden intValue]]];
    [url appendString:[NSString stringWithFormat:@"%d",[_iden intValue]]];
    [url appendString:@"&access_token="];
    [url appendString:tokeninfo.accessToken];
    //[url appendString:[commonUsedMethods getClientSecret]];
    
    NSLog(@"%@",url);
    
    return url;
    
}
+(NSString *) getLoginRequest
{
 
    NSMutableString *url = [[[NSMutableString alloc] init] autorelease];
    [url setString:kServerIp];
    [url appendFormat:@"/login?email="];
    [url appendString:[commonUsedMethods getUserNameFromDefault]];
    [url appendString:@"&password="];
    [url appendString:[commonUsedMethods getUserPassFromDefault]];
    //[url appendString:@"&client_secret="];
    [url appendString:@"&client_secret="];
    NSString *clientSecrect = [NSString stringWithFormat:@"%@%@%@",[commonUsedMethods getSalt],[commonUsedMethods getUserNameFromDefault],[commonUsedMethods getUserPassFromDefault]];
    
   // [url appendString:[commonUsedMethods getClientSecret]];returnMD5Hash
    [url appendString:[commonUsedMethods returnMD5Hash:clientSecrect]];
	url = [[url stringByReplacingOccurrencesOfString:@" " withString:@"%20"] mutableCopy];
	NSLog(@"%@",url);
    return url;
    
}
+(NSString *) getUserCommentsRequest:(NSNumber *)_iden :(NSString *)_comments
{
	tokeInfo *tokeninfo = [[SingletonClass sharedInstance] getTokenInformation];
    //CLLocation *currentLoc = [[SingletonClass sharedInstance] getCurrentLocation];
	NSMutableString *url = [[[NSMutableString alloc] init] autorelease];
    [url setString:kServerIp];
    [url appendFormat:@"/posts/comment"];
	[url appendString:@"?postid="];
    [url appendString:[NSString stringWithFormat:@"%d",[_iden intValue]]];
   // [url appendString:[NSString stringWithFormat:@"%d",[tokeninfo.iden intValue]]];
	[url appendString:@"&comments="];
     [url appendString:_comments];
   /* if(currentLoc)
    {
    [url appendString:[NSString stringWithFormat:@"&lat=%f",currentLoc.coordinate.latitude]];
    [url appendString:[NSString stringWithFormat:@"&long=%f",currentLoc.coordinate.longitude]]; 
        
    }*/
   
    [url appendString:@"&access_token="];
    [url appendString:tokeninfo.accessToken];
    //[url appendString:[commonUsedMethods getClientSecret]];
    NSLog(@"%@",url);
	url = [[url stringByReplacingOccurrencesOfString:@" " withString:@"%20"] mutableCopy];
     NSLog(@"%@",url);
    return url;
	
}
+(NSString *) getPhotoDetailRequest:(NSNumber *)_iden
{
	tokeInfo *tokeninfo = [[SingletonClass sharedInstance] getTokenInformation];
	NSMutableString *url = [[[NSMutableString alloc] init] autorelease];
    [url setString:kServerIp];
    [url appendFormat:@"/photo/"];
    [url appendString:[_iden stringValue]];
    [url appendString:@"?access_token="];
    [url appendString:tokeninfo.accessToken];
    //[url appendString:[commonUsedMethods getClientSecret]];
	NSLog(@"%@",url);
    return url;
}

+(NSString *) getPhotoUploadURL:(NSString *)_sharingDta
{
	tokeInfo *tokeninfo = [[SingletonClass sharedInstance] getTokenInformation];
    NSMutableString *url = [[[NSMutableString alloc] init] autorelease];
    [url setString:kServerIp];
    [url appendFormat:@"/users/"];
    [url appendString:[NSString stringWithFormat:@"%d",[tokeninfo.iden intValue]]];
	[url appendFormat:@"/postPhoto?"];
	[url appendString:@"lat=43.343434343&lng=-23.3434234&caption=abc&filter=Lomo"];
    [url appendString:@"&access_token="];
    [url appendString:tokeninfo.accessToken];
    [url appendString:@"&fb_token=166942940015970tc0ooRAAQrWcDm_84h307NN729DM&tw_token=JvyS7DO2qd6NNTsXJ4E7zA&email_address=airfl@devexperts.com"];
    [url appendString:tokeninfo.accessToken];
    [url appendString:@"&name=photo"];
	//NSLog(@"%@",url);
    NSLog(@"%@",[NSString stringWithFormat:@"http://www.devexpertsteam.com/petstagram/web/api.php/postPhoto?lat=112.34&tags=pet&access_token=%@&caption=abc&lng=-34.434&%@&name=photo",tokeninfo.accessToken,@"&fb_token=166942940015970tc0ooRAAQrWcDm_84h307NN729DM&tw_token=JvyS7DO2qd6NNTsXJ4E7zA&email_address=airfl@devexperts.com"]);
   // return url;
	return [NSString stringWithFormat:@"http://www.devexpertsteam.com/petstagram/web/api.php/postPhoto?lat=112.34&tags=pet&access_token=%@&caption=abc&lng=-34.434&%@&name=photo",tokeninfo.accessToken,@"&fb_token=166942940015970tc0ooRAAQrWcDm_84h307NN729DM&tw_token=JvyS7DO2qd6NNTsXJ4E7zA&email_address=airfl@devexperts.com"];
}
/*
+(NSString *) getPhotoUploadURL:(NSString *)_sharingDta
{
	tokeInfo *tokeninfo = [[SingletonClass sharedInstance] getTokenInformation];
    NSMutableString *url = [[[NSMutableString alloc] init] autorelease];
    [url setString:kServerIp];
    [url appendFormat:@"/users/"];
    [url appendString:[NSString stringWithFormat:@"%d",[tokeninfo.iden intValue]]];
	[url appendFormat:@"/postPhoto?"];
	[url appendString:@"lat=43.343434343&lng=-23.3434234"];
    [url appendString:_sharingDta];
    [url appendString:@"&access_token="];
    [url appendString:tokeninfo.accessToken];
    //[url appendString:@"&fb_token=166942940015970tc0ooRAAQrWcDm_84h307NN729DM&tw_token=JvyS7DO2qd6NNTsXJ4E7zA&email_address=airfl//@devexperts.com"];
    [url appendString:tokeninfo.accessToken];
    [url appendString:@"&name=photo"];
	NSLog(@"%@",url);
     return url;
    //NSLog(@"%@",[NSString stringWithFormat:@"http://www.devexpertsteam.com/petstagram/web/api.php/postPhoto?lat=112.34&tags=pet&//access_token=%@&caption=abc&lng=-34.434&photo=name",tokeninfo.accessToken]);
    // return url;
//	return [NSString stringWithFormat:@"http://www.devexpertsteam.com/petstagram/web/api.php/postPhoto?lat=112.34&tags=pet&////access_token=%@&caption=abc&lng=-34.434&name=photo",tokeninfo.accessToken];
}
*/

+(NSString *) getUserGuideURL
{
	tokeInfo *tokeninfo = [[SingletonClass sharedInstance] getTokenInformation];
    NSMutableString *url = [[[NSMutableString alloc] init] autorelease];
    [url setString:kServerIp];
    [url appendFormat:@"/guide/articles"];
    [url appendString:@"?access_token="];
    [url appendString:tokeninfo.accessToken];
	NSLog(@"%@",url);
    
    return url;
	
}
+(NSString *) getPersonalProfileData
{
	tokeInfo *tokeninfo = [[SingletonClass sharedInstance] getTokenInformation];
    NSMutableString *url = [[[NSMutableString alloc] init] autorelease];
    [url setString:kServerIp];
    [url appendFormat:@"/users/"];
    [url appendString:[NSString stringWithFormat:@"%d",[tokeninfo.iden intValue]]];
    [url appendString:@"?access_token="];
    [url appendString:tokeninfo.accessToken];
    //[url appendString:[commonUsedMethods getClientSecret]];
    
    NSLog(@"%@",url);
    
    return url;
	
}

+(NSString *) getUserPhotoRequest:(userProfile *)_user
{
	tokeInfo *tokeninfo = [[SingletonClass sharedInstance] getTokenInformation];
    
    NSMutableString *url = [[[NSMutableString alloc] init] autorelease];
    [url setString:kServerIp];
    [url appendFormat:@"/users/"];
    [url appendString:[NSString stringWithFormat:@"%d",[_user.iden intValue]]];
    [url appendString:@"/photos?access_token="];
    [url appendString:tokeninfo.accessToken];
	[url appendString:[NSString stringWithFormat:@"&blocksize=%d&offset=%d",[_user.photoFeed.blocksize intValue],[_user.photoFeed.offset intValue]+1]];
    NSLog(@"%@",url);
    return url;
	
}
+(NSString *) getRelationShipRequest:(NSNumber *)_iden :(BOOL)_action
{
    tokeInfo *tokeninfo = [[SingletonClass sharedInstance] getTokenInformation];
    NSMutableString *url = [[[NSMutableString alloc] init] autorelease];
    [url setString:kServerIp];
    [url appendFormat:@"/users/"];
     [url appendString:[NSString stringWithFormat:@"%d",[_iden intValue]]];
   // [url appendString:[NSString stringWithFormat:@"%d",[tokeninfo.iden intValue]]];
	//[url appendFormat:@"/set_relationship?target_user_id="];
    [url appendFormat:@"/set_relationship?action_type="];
   // [url appendString:[NSString stringWithFormat:@"%d",[_iden intValue]]];
    //[url appendFormat:@"&action="];
    if(_action)
     [url appendString:@"follow"];
    else
     [url appendString:@"unfollow"];
    [url appendString:@"&access_token="];
    [url appendString:tokeninfo.accessToken];
	NSLog(@"%@",url);
    
    return url;
}
//http://174.143.155.231:8080/CurryCloud/api/users/23/follows?access_token=703967.f59def8.f76da97d65bb4d7ea1334cc242a4fc23
+(NSString *) getUserFollowingThisRequest:(NSNumber *)_iden
{
	tokeInfo *tokeninfo = [[SingletonClass sharedInstance] getTokenInformation];
    NSMutableString *url = [[[NSMutableString alloc] init] autorelease];
    [url setString:kServerIp];
    [url appendFormat:@"/users/"];
    [url appendString:[NSString stringWithFormat:@"%d",[_iden intValue]]];
	[url appendFormat:@"/follows"];
    [url appendString:@"?access_token="];
    [url appendString:tokeninfo.accessToken];
	NSLog(@"%@",url);
    
    return url;
	
}
//http://174.143.155.231:8080/CurryCloud/api/users/23/followed-by?access_token=703967.f59def8.f76da97d65bb4d7ea1334cc242a4fc23
+(NSString *) getUserFollowedThisRequest:(NSNumber *)_iden
{
	
	tokeInfo *tokeninfo = [[SingletonClass sharedInstance] getTokenInformation];
    NSMutableString *url = [[[NSMutableString alloc] init] autorelease];
    [url setString:kServerIp];
    [url appendFormat:@"/users/"];
   [url appendString:[NSString stringWithFormat:@"%d",[_iden intValue]]];
	[url appendFormat:@"/followed-by"];
    [url appendString:@"?access_token="];
    [url appendString:tokeninfo.accessToken];
	NSLog(@"%@",url);
    
    return url;
	
}
//http://174.143.155.231:8080/CurryCloud/api/users/15/pets?pet_name=Hoppy&tags=dog,jackrussell,black&access_token=703967.f59def8.f76da97d65bb4d7ea1334cc242a4fc23
+(NSString *) getAddPetRequest:(NSString *)_dataString
{
	tokeInfo *tokeninfo = [[SingletonClass sharedInstance] getTokenInformation];
    NSMutableString *url = [[[NSMutableString alloc] init] autorelease];
    [url setString:kServerIp];
    [url appendFormat:@"/users/"];
   [url appendString:[NSString stringWithFormat:@"%d",[tokeninfo.iden intValue]]];
	[url appendFormat:@"/pets?"];
	[url appendString:_dataString];
    [url appendString:@"&access_token="];
    [url appendString:tokeninfo.accessToken];
	NSLog(@"%@",url);
    
    return url;
	
}
//http://174.143.155.231:8080/CurryCloud/api/users/15/pets?pet_name=Hoppy&tags=dog,jackrussell,black&access_token=703967.f59deff76da97d65bb4d7ea1334cc242a4fc23
+(NSString *) getPetInfo:(petsObject *)_pet
{
    tokeInfo *tokeninfo = [[SingletonClass sharedInstance] getTokenInformation];
    NSMutableString *url = [[[NSMutableString alloc] init] autorelease];
    [url setString:kServerIp];
    //[url appendFormat:@"/users/"];
    //[url appendString:[NSString stringWithFormat:@"%d",[tokeninfo.iden intValue]]];
	[url appendFormat:@"/pet?"];
	[url appendString:[NSString stringWithFormat:@"name=%@",_pet.petName]];
    if(_pet.tagArray && [_pet.tagArray count]>0)
    [url appendString:[NSString stringWithFormat:@"&tags=%@",[[_pet.tagArray  valueForKey:@"description"] componentsJoinedByString:@","]]];
    // [url appendString:[NSString stringWithFormat:@"&tags=tag1"]];
    if(_pet.dob)
     [url appendString:[NSString stringWithFormat:@"&dob=%@",_pet.dob]];
    if(_pet.kind)
     [url appendString:[NSString stringWithFormat:@"&kind=%@",_pet.kind]];
    if(_pet.breed)
     [url appendString:[NSString stringWithFormat:@"&breed=%@",_pet.breed]];
    if(_pet.sex)
     [url appendString:[NSString stringWithFormat:@"&sex=%@",_pet.sex]];
    else
     [url appendString:[NSString stringWithFormat:@"&sex=%@",[commonUsedMethods getDefaultSex]]]; 
    if(_pet.iden)
     [url appendString:[NSString stringWithFormat:@"&pet_id=%d",[_pet.iden intValue]]];   
    [url appendString:@"&access_token="];
    [url appendString:tokeninfo.accessToken];
    url = [[url stringByReplacingOccurrencesOfString:@" " withString:@"%20"] mutableCopy];
	NSLog(@"%@",url);
    
    return url;
}
+(NSString *) getPersonalProfileURL
{
    return @"";
    /*
    tokeInfo *tokeninfo = [[SingletonClass sharedInstance] getTokenInformation];
    NSMutableString *url = [[[NSMutableString alloc] init] autorelease];
    [url setString:kServerIp];
    [url appendFormat:@"/users/"];
    [url appendString:[NSString stringWithFormat:@"%d",[tokeninfo.iden intValue]]];
	[url appendFormat:@"/pets?"];
	[url appendString:[NSString stringWithFormat:@"pet_name=%@",_pet.petName]];
    // [url appendString:[NSString stringWithFormat:@"&tags=%@",[[_pet.tagArray  valueForKey:@"description"] componentsJoinedByString:@","]]];
    [url appendString:[NSString stringWithFormat:@"&tags=tag1"]];
    [url appendString:[NSString stringWithFormat:@"&dob=34545433"]];
    [url appendString:[NSString stringWithFormat:@"&kind=%@",_pet.kind]];
    // [url appendString:[NSString stringWithFormat:@"&breed=%@",_pet.breed]];
    [url appendString:[NSString stringWithFormat:@"&breed=asdfdsa"]];
    [url appendString:[NSString stringWithFormat:@"&sex=male"]];
    [url appendString:@"&access_token="];
    [url appendString:tokeninfo.accessToken];
	NSLog(@"%@",url);
    
    return url;*/
    
}
+(NSString *) getProfileImageURL:(NSMutableDictionary *)_dictionary
{
    
    
    NSMutableString *url = [[[NSMutableString alloc] init] autorelease];
    [url setString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/?fields=picture&type=large",[_dictionary objectForKey:@"id"]]];
    NSLog(@"%@",url);
    
    return url;
    
}
+(NSString *) getProfileImageData:(NSMutableDictionary *)_dictionary
{
    NSMutableString *url = [[[NSMutableString alloc] init] autorelease];
    if([_dictionary objectForKey:@"picture"])
        [url setString:[NSString stringWithFormat:@"%@",[_dictionary objectForKey:@"picture"]]];
    else
        [url setString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture",[_dictionary objectForKey:@"id"]]]; 
    NSLog(@"%@",url);
    return url;
    
}
+(NSString *) UpdateProfileURL
{
    tokeInfo *tokeninfo = [[SingletonClass sharedInstance] getTokenInformation];
    NSMutableDictionary *dic = [[SingletonClass sharedInstance] getFbDictionary];
    NSMutableString *url = [[[NSMutableString alloc] init] autorelease];
    [url setString:kServerIp];
	[url appendString:@"/updateAccount?"];
    [url appendFormat:@"email="];
    [url appendString:[dic objectForKey:@"email"]];
    [url appendString:[NSString stringWithFormat:@"&username=%@",[dic valueForKey:@"name"]]];
    [url appendString:[NSString stringWithFormat:@"&access_token=%@",tokeninfo.accessToken]];
    [url appendString:@"&name=user_photo"];
    url = [[url stringByReplacingOccurrencesOfString:@" " withString:@"%20"] mutableCopy];
    NSLog(@"%@",url);
    return url;
    
    
    
//    tokeInfo *tokeninfo = [[SingletonClass sharedInstance] getTokenInformation];
//    NSMutableString *url = [[[NSMutableString alloc] init] autorelease];
//    [url setString:kServerIp];
//    //[url appendString:@"/users/"];
//    //[url appendString:[NSString stringWithFormat:@"%d",[tokeninfo.iden intValue]]];
//	[url appendString:@"/updateAccount?"];
//    if(userprofile.email && [userprofile.email length] > 0)
//        [url appendString:[NSString stringWithFormat:@"email=%@",userprofile.email]];
//    if(userprofile.userName && [userprofile.userName length] > 0)
//        [url appendString:[NSString stringWithFormat:@"&username=%@",userprofile.userName]];
//    if(userprofile.password && [userprofile.password length] > 0)
//        [url appendString:[NSString stringWithFormat:@"&password=%@",userprofile.password]];
//    //if(userprofile.email && [userprofile.email length] > 0)
//    //   [url appendString:[NSString stringWithFormat:@"&email=%@",userprofile.email]];
//    [url appendString:[NSString stringWithFormat:@"&access_token=%@",tokeninfo.accessToken]];
//    [url appendString:[NSString stringWithFormat:@"&receive_push_for_supports=%@&receive_push_for_comments=%@",[commonUsedMethods getSupportNotification] ? @"yes":@"no", [commonUsedMethods getCommentNotification] ? @"yes":@"no"]];
//    if(isNewPhoto)
//        [url appendString:@"&name=user_photo"];
//    url = [[url stringByReplacingOccurrencesOfString:@" " withString:@"%20"] mutableCopy];
//    NSLog(@"%@",url);
//    return url;


}

@end
