//
//  DataModel.m
//  Petstagram
//
//  Created by Awais Ahmad Qureshi on 5/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DataModel.h"
#import "domainClasses.h"
#import "SingletonClass.h"
#import "commonUsedMethods.h"
#import "userProfile.h"

#define FEED_TAB			@"FEED"
#define POPULAR_TAB			@"POPULAR"
#define NEARBY_TAB			@"NEARBY"
#define ACTIVITY_TAB		@"ACTIVITY"
#define SEARCH_TAB			@"SEARCH"
#define USERPROFILE_TAB		@"USERPROFILE"
#define PHOTO_DETAIL_TAB	@"PHOTODETAIL"
#define PERSONALPROFILE_TAB @"PERSONALPROFILE"
#define SPOTTED_TAB         @"SPOTTED"
#define NEARBYMAP_TAB         @"NEARBYMAP"


NSMutableArray *feedArray;
NSMutableArray *userprofileArray;
NSMutableDictionary *dataDictionary;

@implementation DataModel

+(void )setDataInDictionary:(NSMutableArray *)_userArray:(int)_tab
{
    
    if([_userArray count] > 0)
    {
        NSLog(@"count : %d",[_userArray count]);
        if(!dataDictionary)
        {
            dataDictionary = [[NSMutableDictionary alloc] init];
            [dataDictionary retain];
        }
        if(_tab == 6)
        {
            userProfile *user = [_userArray objectAtIndex:0];
            user.email = [commonUsedMethods getUserNameFromDefault];
        }
        [dataDictionary setObject:_userArray forKey:[self keyValueOfTab:_tab]];
    }
    
	
}
+(NSMutableArray *) getDataInDictionary:(int)_tab
{
	if(![dataDictionary valueForKey:[self keyValueOfTab:_tab]])
         return 0;
    NSLog(@"Retun Array count: %d",[(NSArray *)[dataDictionary valueForKey:[self keyValueOfTab:_tab]] count]);
   
    if(_tab == 6)
        return [dataDictionary valueForKey:[self keyValueOfTab:_tab]];
    else
    {
        if(_tab == 4)
        {
            
            NSMutableArray *arry = [self applyFilters:[dataDictionary valueForKey:[self keyValueOfTab:_tab]]];
                                    return [self setSortArray:arry];
        }
        else
                                    
        {
           return  [self applyFilters:[dataDictionary valueForKey:[self keyValueOfTab:_tab]]];
        }
                                    
    }
             /*
    
    if(_tab == 4)
          return [self setSortArray:[dataDictionary valueForKey:[self keyValueOfTab:_tab]]];
     else    
         return [dataDictionary valueForKey:[self keyValueOfTab:_tab]];*/
	return 0;
	
}
+(NSMutableArray *) applyFilters:(NSMutableArray *)_array
{
    
    FeedData *feed = [_array objectAtIndex:0];
    if(_array)
    {
        FeedData *feed = [_array objectAtIndex:0];
        if([feed.photoArray count] == 0)
        
        return _array;
    }
    FeedData *newFeed = [[FeedData alloc] init];
    newFeed.offset = feed.offset;
    newFeed.blocksize= feed.blocksize;
    
    NSMutableArray *newArray = [[[NSMutableArray alloc] init] autorelease];
    NSString *kindString = NSLocalizedStringFromTable(@"KIND",@"All_topics", @"TOPIC_KIND");
    NSLog(@"%@",kindString);
  //  NSArray *topicArray = [NSArray  arrayWithArray:[kindString componentsSeparatedByString:@","]];
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    
    for (int i =0 ; i < [feed.photoArray count]; i ++)
        
    {
        PhotoData *photo = [feed.photoArray objectAtIndex:i];
        if (photo.tag == NULL)
        {
            photo.tag = @"Announcements";
        }
        NSLog(@"Tag=%@ id=%d Title=%@",photo.tag,[photo.iden intValue],photo.title);
        if([commonUsedMethods getTopicOption:photo.tag])
            {
                [tempArray addObject:photo];
            }
    }
    newFeed.photoArray = tempArray;
    [tempArray  release];
    [newArray addObject:newFeed];
    
   return newArray;
    /*
    NSMutableArray *groupArray = [[[NSMutableArray alloc] init] autorelease];
    NSString *kindString = NSLocalizedStringFromTable(@"KIND",@"All_topics", @"TOPIC_KIND");
    NSLog(@"%@",kindString);
     NSArray *topicArray = [NSArray  arrayWithArray:[kindString componentsSeparatedByString:@","]];
        
    for (int i = 0; i < [topicArray count]; i++)
    {
	  if([commonUsedMethods getTopicOption:[topicArray objectAtIndex:i]])
      {
        FeedData *feed = [_array objectAtIndex:0];
       NSMutableArray *tempArray = [[[NSMutableArray alloc] initWithArray:feed.photoArray] copy];
       NSLog(@"%d",[tempArray count]);
	   NSPredicate *predicate = [NSPredicate predicateWithFormat:@"tag=%@",[topicArray objectAtIndex:i]];
	   [tempArray filterUsingPredicate:predicate];	
	    if([tempArray count] > 0)
	     { 
		[groupArray addObjectsFromArray:tempArray];
	     }
         [tempArray release];
      }
        
    }
    FeedData *feed = [_array objectAtIndex:0];
    feed.photoArray = groupArray;
    NSMutableArray *returnArray = [[[NSMutableArray alloc] init] autorelease];
    [returnArray addObject:feed];
    
		return returnArray ;*/
}

+(NSMutableArray *) setSortArray:(NSMutableArray *)_feedArray
{
    FeedData *feed = [_feedArray objectAtIndex:0];
    if(feed)
    {
    NSSortDescriptor *sorter;
	sorter=[[NSSortDescriptor alloc] initWithKey:@"supporters" ascending:FALSE];
	NSArray* sortDescriptors = [NSArray arrayWithObject: sorter];
  //  NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:feed.photoArray];
    [feed.photoArray sortUsingDescriptors:sortDescriptors];
    //                             feed.photoArray = tempArray;
      //                           [tempArray release];
	[sorter release];
    }
    return _feedArray;

}
+(BOOL ) hasDataInDictionary:(int)_tab
{
	if([dataDictionary valueForKey:[self keyValueOfTab:_tab]])
	  return TRUE;
	return FALSE;
	
}
+(void )   upDateDataInDictionary:(NSMutableArray *)_Array:(int)_tab
{
	NSMutableArray *array = [self getDataInDictionary:_tab];
	
    if(_tab == 1 )
    {
        NSMutableArray *photoArray = [[NSMutableArray alloc] init];
        FeedData *oldFeed =      [array objectAtIndex:0];
        FeedData *newFeed =     [_Array objectAtIndex:0];
        
        oldFeed.offset = newFeed.offset;
        oldFeed.blocksize = newFeed.blocksize;
        [photoArray addObjectsFromArray:oldFeed.photoArray];
        [photoArray addObjectsFromArray:newFeed.photoArray];
        oldFeed.photoArray = photoArray;
        [photoArray release];
    }
	else  if(_tab == 2)
	 {
		 NSMutableArray *photoArray = [[NSMutableArray alloc] init];
		 FeedData *feed =     [array objectAtIndex:0];
		 FeedData *tempFeed = [_Array objectAtIndex:0];
		 feed.offset = tempFeed.offset;
		 feed.blocksize = tempFeed.blocksize;
		 [photoArray addObjectsFromArray:feed.photoArray];
		 [photoArray addObjectsFromArray:tempFeed.photoArray];
		 feed.photoArray = photoArray;
		 [array replaceObjectAtIndex:0 withObject:feed];
		 [self setDataInDictionary:array:_tab];
		 [photoArray release];
	 }
	 else  if(_tab == 4)
	 {
         NSMutableArray *photoArray = [[NSMutableArray alloc] init];
		 FeedData *feed =     [array objectAtIndex:0];
		 FeedData *tempFeed = [_Array objectAtIndex:0];
		 feed.offset = tempFeed.offset;
		 feed.blocksize = tempFeed.blocksize;
		 [photoArray addObjectsFromArray:feed.photoArray];
		 [photoArray addObjectsFromArray:tempFeed.photoArray];
		 feed.photoArray = photoArray;
		 [array replaceObjectAtIndex:0 withObject:feed];
		 [self setDataInDictionary:array:_tab];
		 [photoArray release];
	 }
	
}

+(BOOL)   updateNearByData:(NSMutableArray *)_Array:(int)_tab
{
	NSMutableArray *array = [self getDataInDictionary:_tab];
	BOOL success = FALSE;
    if( _tab == 3)
    {
        
        FeedData *feed =     [array objectAtIndex:0];
        FeedData *tempFeed = [_Array objectAtIndex:0];
        NSMutableSet *set = [NSMutableSet setWithArray:feed.photoArray];
        for (id arrayItem in tempFeed.photoArray)
        {
            id setItem = [[set filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"iden.intValue = %d", [[arrayItem valueForKey:@"iden"] intValue]]] anyObject];
            if (setItem != nil)
            {
                [set removeObject:setItem];
                [set addObject:arrayItem];
            }
            else
            {
                success = TRUE;
                [set addObject:arrayItem]; 
            }
        }
        if(success)
        {
            feed.photoArray =  (NSMutableArray *)[set allObjects];
            NSLog(@"WOW-->photo is now %d %d",[set count],[feed.photoArray count]);
           // [array replaceObjectAtIndex:0 withObject:feed];
            [self setDataInDictionary:array:_tab];
            
        }
       // NSLog(@"WOW-->photo is now %d",[set count]);
       // feed.photoArray =  (NSMutableArray *)[set allObjects];
    }
  return success;
	
}

+(void)deletePhotoData:(int)_iden:(int)_tab
{
    NSMutableArray *array = [self getDataInDictionary:_tab];
    if( _tab == 3)
    {
        FeedData *feed =     [array objectAtIndex:0];
        NSMutableArray *fotoArray = [[NSMutableArray alloc] initWithArray:feed.photoArray];
        for(int i = 0; i < [fotoArray count]; i++)
        {
            PhotoData *item = [fotoArray objectAtIndex:i];
            
            if([item.iden intValue] == _iden)
            {
                NSLog(@"photo id %d, array photo id %d", _iden,[item.iden intValue]);
                [fotoArray removeObjectAtIndex:i];
                feed.photoArray = fotoArray;
                break;
            }
        }
        
        [fotoArray release];
    }
    
    if( _tab == 4)
    {
        FeedData *feed =     [array objectAtIndex:0];
        NSMutableArray *fotoArray = [[NSMutableArray alloc] initWithArray:feed.photoArray];
        for(int i = 0; i < [fotoArray count]; i++)
        {
            PhotoData *item = [fotoArray objectAtIndex:i];
            
            if([item.iden intValue] == _iden)
            {
                NSLog(@"photo id %d, array photo id %d", _iden,[item.iden intValue]);
                [fotoArray removeObjectAtIndex:i];
                feed.photoArray = fotoArray;
                break;
            }
        }
        [fotoArray release];
    }
    else if(_tab == 6)
    {
        userProfile *userprofile = [array objectAtIndex:0];
        NSMutableArray *fotoArray = [[NSMutableArray alloc] initWithArray:userprofile.photoFeed.photoArray];
        for(int i = 0; i < [fotoArray count]; i++)
        {
            PhotoData *photodata = [fotoArray objectAtIndex:i];
            if([photodata.iden intValue] == _iden)
            {
                NSLog(@"photo id %d, array photo id %d", _iden,[photodata.iden intValue]);
                [fotoArray removeObjectAtIndex:i];
                userprofile.photoFeed.photoArray = fotoArray;
                break;
            }
        }
        [fotoArray release];
    }
    
    if( _tab == 10)
    {
        FeedData *feed =     [array objectAtIndex:0];
        NSMutableArray *fotoArray = [[NSMutableArray alloc] initWithArray:feed.photoArray];
        for(int i = 0; i < [fotoArray count]; i++)
        {
            PhotoData *item = [fotoArray objectAtIndex:i];
            
            if([item.iden intValue] == _iden)
            {
                NSLog(@"photo id %d, array photo id %d", _iden,[item.iden intValue]);
                [fotoArray removeObjectAtIndex:i];
                feed.photoArray = fotoArray;
                break;
            }
        }
        [fotoArray release];
    }
    
    [self setDataInDictionary:array:_tab];
    
}


+(NSString *) keyValueOfTab:(int)_tab
{
	switch (_tab) {
		case 1:
			return FEED_TAB;
			break;
		case 2:
			return POPULAR_TAB;
			break;
		case 3:
			return NEARBY_TAB;
			break;
		case 4:
			return ACTIVITY_TAB;
			break;
		case 5:
			return SEARCH_TAB;
			break;
		case 6:
			return USERPROFILE_TAB;
			break;
		case 7:
			return PHOTO_DETAIL_TAB;
			break;
		case 8:
			return PERSONALPROFILE_TAB;
			break;
        case 9:
			return SPOTTED_TAB;
			break;
        case 10:
			return NEARBYMAP_TAB;
			break;
		default:
			break;
	}
	return 0;
}

+(void )   setUserProfileArray:(NSMutableArray *)_userProfileArray
{
	if(!userprofileArray)
    {
        userprofileArray = [[NSMutableArray alloc] init];
        [userprofileArray retain];
    }
    [userprofileArray removeAllObjects];
    [userprofileArray addObjectsFromArray:_userProfileArray];

}
+(NSMutableArray *) getUserProfileArray;
{
	return userprofileArray;
}

+(void )   setUserFeedArray:(NSMutableArray *)_feedArray
{
    if(!feedArray)
    {
        feedArray = [[NSMutableArray alloc] init];
        [feedArray retain];
    }
    [feedArray removeAllObjects];
    [feedArray addObjectsFromArray:_feedArray];
	
}
+(NSMutableArray *) getUserFeedArray
{
    return feedArray;
    
}

+(void)   updateCommentProperty:(NSNumber *)_iden:(NSString *)text:(int)selectedIndex
{
	if(selectedIndex == 7)
		[self updateCommentInSingleDetailPhoto:_iden:text:selectedIndex];
	else
		[self updateCommentInPhotoArray:_iden:text:selectedIndex];
	
	/*NSMutableArray *array = [self getDataInDictionary:selectedIndex];
	FeedData *feed  = [array objectAtIndex:0];
	NSMutableArray *dataArray =feed.photoArray;
	BOOL success = FALSE;
	PhotoData *photo;
	for (int i = 0; i < [dataArray count]; i++) {
		
		photo = [dataArray objectAtIndex:i];
		if([photo.iden intValue] == [_iden intValue])
		{
			success = TRUE;
			break;	
		}
	}
	if (success) {
		 int total = [photo.commentdata.count intValue];
		 total ++;
		photo.commentdata.count = [NSNumber numberWithInt:total];
		photo.hasComment = TRUE;
		[photo.commentdata.commentsInfo insertObject:[self createUserObject:text] atIndex:0];
	}*/
}
+(void) updateCommentInPhotoArray:(NSNumber *)_iden:(NSString *)text:(int)selectedIndex
{
	FeedData *feed;
    NSMutableArray *array = [self getDataInDictionary:selectedIndex];
    if(selectedIndex == 1)
    {
    userProfile *user = [array objectAtIndex:0];
	feed  = user.photoFeed;
    }
    else
    feed  = [array objectAtIndex:0];
	NSMutableArray *dataArray =feed.photoArray;
	BOOL success = FALSE;
	PhotoData *photo;
	for (int i = 0; i < [dataArray count]; i++) {
		
		photo = [dataArray objectAtIndex:i];
		if([photo.iden intValue] == [_iden intValue])
		{
			success = TRUE;
			break;	
		}
	}
	if (success) {
		photo.hasComment = TRUE;
		[photo.commentArray  insertObject:[self createUserObject:text] atIndex:0];
	}
}
+(void)   updateCommentInSingleDetailPhoto:(NSNumber *)_iden:(NSString *)text:(int)selectedIndex
{
	NSMutableArray *array = [self getDataInDictionary:selectedIndex];
	PhotoData *photo  = [array objectAtIndex:0];
	//photo.commentdata.count = [NSNumber numberWithInt:total];
	photo.hasComment = TRUE;
	[photo.commentArray insertObject:[self createUserObject:text] atIndex:0];
}



+(void)   updateLikeProperty:(NSNumber *)_iden:(int)selectedIndex
{
	if(selectedIndex != 7)
		[self updateLikePropertyInPhotoArray:_iden:selectedIndex];
	else
		[self updateLikePropertyInSinglePhoto:_iden:selectedIndex];
	
	/*
	NSMutableArray *array = [self getDataInDictionary:selectedIndex];
	FeedData *feed  = [array objectAtIndex:0];
	NSMutableArray *dataArray =feed.photoArray;
	BOOL success = FALSE;
	PhotoData *photo;
	for (int i = 0; i < [dataArray count]; i++) {
		
		photo = [dataArray objectAtIndex:i];
		if([photo.iden intValue] == [_iden intValue])
		{
			success = TRUE;
			break;	
		}
	}
	
	if (success) {
		
		int total = [photo.likedata.count intValue];
		total ++;
		photo.likedata.count = [NSNumber numberWithInt:total];
		photo.hasLike = TRUE;
		//NSLog(@"Before Comment data is %d",[photo.likedata.userArray count]);
		[photo.likedata.userArray insertObject:[self createUserObject2] atIndex:0];
		//NSLog(@"After Comment data is %d",[photo.likedata.userArray count]);
	}
	
	*/
}
+(void)   updateLikePropertyInPhotoArray:(NSNumber *)_iden:(int)selectedIndex
{
	NSMutableArray *array = [self getDataInDictionary:selectedIndex];
	FeedData *feed  = [array objectAtIndex:0];
	NSMutableArray *dataArray =feed.photoArray;
	BOOL success = FALSE;
	PhotoData *photo;
	for (int i = 0; i < [dataArray count]; i++) {
		
		photo = [dataArray objectAtIndex:i];
		if([photo.iden intValue] == [_iden intValue])
		{
			success = TRUE;
			break;	
		}
	}
	
	if (success) {
		
		int total = [photo.supporterArray count];
		total ++;
		//photo.likedata.count = [NSNumber numberWithInt:total];
		photo.hasLike = TRUE;
		//NSLog(@"Before Comment data is %d",[photo.likedata.userArray count]);
		[photo.supporterArray insertObject:[self createUserObject2] atIndex:0];
		//NSLog(@"After Comment data is %d",[photo.likedata.userArray count]);
	}
	
	
}
+(void)   updateLikePropertyInSinglePhoto:(NSNumber *)_iden:(int)selectedIndex
{
	NSMutableArray *array = [self getDataInDictionary:selectedIndex];
	PhotoData *photo  = [array objectAtIndex:0];
	//int total = [photo.likedata.count intValue];
	//total ++;
	//photo.likedata.count = [NSNumber numberWithInt:total];
	photo.hasLike = TRUE;
	//NSLog(@"Before Comment data is %d",[photo.likedata.userArray count]);
	[photo.supporterArray insertObject:[self createUserObject2] atIndex:0];
	//NSLog(@"After Comment data is %d",[photo.likedata.userArray count]);	
	
}

+(CommentsData *) createUserObject:(NSString *)_str
{
	
	CommentsData *e3 = [[[CommentsData alloc] init] autorelease];
	e3.textData=_str;
	
	userProfile *user = [[userProfile alloc] init];
	tokeInfo *tokeninfo = [[SingletonClass sharedInstance] getTokenInformation];
	user.iden = tokeninfo.iden;
	user.imgURL = tokeninfo.imgURL;
	user.userName = tokeninfo.name;
	e3.user = user;
	NSDateFormatter* df = [[NSDateFormatter alloc]init];
	[df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS-HH:mm"];
	e3.createdDate = [df stringFromDate:[NSDate date]];
    
	[user release];
	[df release];
	return e3;

}
+(likeData *) createUserObject2
{
	
	likeData *e3 = [[[likeData alloc] init] autorelease];
	
	userProfile *user = [[userProfile alloc] init];
	tokeInfo *tokeninfo = [[SingletonClass sharedInstance] getTokenInformation];
	user.iden = tokeninfo.iden;
	user.imgURL = tokeninfo.imgURL;
	user.userName = tokeninfo.name;
    e3.user = user;
    [user release];

	return e3;
}
+(void) removeAllStoreData
{
	[dataDictionary removeAllObjects];
    NSLog(@"%@",dataDictionary.descriptionInStringsFileFormat);
}

+(PhotoData *)  getPhotoDataWithIdentity:(NSNumber *)_iden:(int)selectedIndex
{
	NSMutableArray *array = [self getDataInDictionary:selectedIndex];
	PhotoData *photo;
	if(selectedIndex==7)
	{
		photo = [array objectAtIndex:0];
		return photo;
	}
	else
	{
	FeedData *feed  = [array objectAtIndex:0];
	NSMutableArray *dataArray =feed.photoArray;
	PhotoData *photo;
	for (int i = 0; i < [dataArray count]; i++) {
		
		photo = [dataArray objectAtIndex:i];
		if([photo.iden intValue] == [_iden intValue])
		{
			return photo;		
		}
	}
	}
	
	return 0;
	
	
}
+(void)   updateCommentProperty2:(NSNumber *)_iden:(NSString *)text:(int)selectedIndex
{
	NSMutableArray *array = [self getDataInDictionary:selectedIndex];
	PhotoData *photo  = [array objectAtIndex:0];
		int total = [photo.commentArray count];
		total ++;
		//photo.commentdata.count = [NSNumber numberWithInt:total];
		photo.hasComment = TRUE;
		[photo.commentArray insertObject:[self createUserObject:text] atIndex:0];
}
+(void)   updateLikeProperty2:(NSNumber *)_iden:(int)selectedIndex
{
	NSMutableArray *array = [self getDataInDictionary:selectedIndex];
	PhotoData *photo  = [array objectAtIndex:0];
	//int total = [photo.likedata.count intValue];
	//	total ++;
		//photo.likedata.count = [NSNumber numberWithInt:total];
		photo.hasLike = TRUE;
		//NSLog(@"Before Comment data is %d",[photo.likedata.userArray count]);
		[photo.supporterArray insertObject:[self createUserObject2] atIndex:0];
		//NSLog(@"After Comment data is %d",[photo.likedata.userArray count]);	
	
}
+(void) addUploadedPhotoInDictionary:(PhotoData *)_photoData
{
    //NSMutableArray *array = [self getDataInDictionary:1];// it was feed data and changer to 3 for nearby data 23/09/2011
    NSMutableArray *array = [self getDataInDictionary:3];
    FeedData *feed = [array objectAtIndex:0];
    NSMutableArray *photoArray = [[NSMutableArray alloc] initWithArray:feed.photoArray];
    if([photoArray count] > 0)
    {
        //[feed.photoArray insertObject:_photoData atIndex:0];
        [photoArray insertObject:_photoData atIndex:0];
        feed.photoArray = photoArray;
        //[self setDataInDictionary:array :1];// it was feed data and changer to 3 for nearby data 23/09/2011
        [self setDataInDictionary:array :3];
    }
    else
        feed.photoArray = [[NSMutableArray alloc] initWithObjects:_photoData, nil];
    
         //[photoArray addObject:_photoData];
    NSLog(@"TOTAL FEED IS:%d",[feed.photoArray count]);
    
    // adding the photo in user profile 
    if([self hasDataInDictionary:6])
    {
        NSMutableArray *profileArray = [self getDataInDictionary:6];
        userProfile *uProfilr = [profileArray objectAtIndex:0];
        if([uProfilr.photoFeed.photoArray count] > 0)
        {
            NSMutableArray *tempArray = [[NSMutableArray alloc] initWithObjects:_photoData, nil];
            [tempArray addObjectsFromArray:uProfilr.photoFeed.photoArray];
            //[uProfilr.photoFeed.photoArray insertObject:_photoData atIndex:0];
            uProfilr.photoFeed.photoArray = tempArray;
            uProfilr.post = uProfilr.post + 1;
            [tempArray release];
            [self setDataInDictionary:profileArray :6];
        }
    }
}


+(BOOL )  upDateExistingDataWithNewData:(NSMutableArray *)_Array:(int)_tab
{
	NSMutableArray *array = [self getDataInDictionary:_tab];
	BOOL success = FALSE;
    if(_tab == 1 )
    {
        // To DO
    }
	else  if(_tab == 2 || _tab == 4)
    {
      //  NSMutableArray *photoArray = [[NSMutableArray alloc] init];
        FeedData *feed =     [array objectAtIndex:0];
        FeedData *tempFeed = [_Array objectAtIndex:0];
        
        NSMutableSet *set = [NSMutableSet setWithArray:feed.photoArray];
        for (id arrayItem in tempFeed.photoArray)
        {
            id setItem = [[set filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"iden.intValue = %d", [[arrayItem valueForKey:@"iden"] intValue]]] anyObject];
            if (setItem != nil)
            {
                [set removeObject:setItem];
                [set addObject:arrayItem];
            }
            else
            {
                success = TRUE;
                [set addObject:arrayItem]; 
            }
        }
         
         NSLog(@"WOW-->photo is now %d",[set count]);
        feed.photoArray =  (NSMutableArray *)[set allObjects];
        }
    return success;
	
}

+(BOOL)updateProfileData:(NSMutableArray *)_Array:(int)_tab
{
	NSMutableArray *array = [self getDataInDictionary:_tab];
	BOOL success = FALSE;
    if( _tab == 6)
    {
        
        userProfile *feed =     [array objectAtIndex:0];
        userProfile *tempFeed = [_Array objectAtIndex:0];
        NSMutableSet *set = [NSMutableSet setWithArray:feed.photoFeed.photoArray];
        for (id arrayItem in tempFeed.photoFeed.photoArray)
        {
            id setItem = [[set filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"iden.intValue = %d", [[arrayItem valueForKey:@"iden"] intValue]]] anyObject];
            if (setItem != nil)
            {
                [set removeObject:setItem];
                [set addObject:arrayItem];
            }
            else
            {
                success = TRUE;
                [set addObject:arrayItem]; 
            }
        }
        if(success)
        {
            feed.photoFeed.photoArray =  (NSMutableArray *)[set allObjects];
            NSLog(@"WOW-->photo is now %d photoArray %d",[set count],[feed.photoFeed.photoArray count]);
            // [array replaceObjectAtIndex:0 withObject:feed];
            [self setDataInDictionary:array:_tab];
            
        }
        // NSLog(@"WOW-->photo is now %d",[set count]);
        // feed.photoArray =  (NSMutableArray *)[set allObjects];
    }
    return success;
	
}



@end
