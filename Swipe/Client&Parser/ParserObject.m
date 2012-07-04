//
//  ParserObject.m
//  GG Application
//
//  Created by Haris Jawaid on 12/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ParserObject.h"
#import "TouchXML.h"
#import "headerfiles.h"


@implementation ParserObject
@synthesize delegate;
@synthesize isPull;
-(id) init
{
	json2 = [[SBJSON alloc]init];
    return self;	
	
}

-(void) grabRSSFeed:(NSString *)blogAddress {
	
    // Initialize the blogEntries MutableArray that we declared in the header
    blogEntries = [[NSMutableArray alloc] init];	
	
    // Convert the supplied URL string into a usable URL object
    NSURL *url = [NSURL URLWithString: blogAddress];
	
    // Create a new rssParser object based on the TouchXML "CXMLDocument" class, this is the
    // object that actually grabs and processes the RSS data
    CXMLDocument *rssParser = [[[CXMLDocument alloc] initWithContentsOfURL:url options:0 error:nil] autorelease];
	
    // Create a new Array object to be used with the looping of the results from the rssParser
    NSArray *resultNodes = NULL;
	
    // Set the resultNodes Array to contain an object for every instance of an  node in our RSS feed
    resultNodes = [rssParser nodesForXPath:@"//item" error:nil];
	
    // Loop through the resultNodes to access each items actual data
    for (CXMLElement *resultElement in resultNodes) {
		
        // Create a temporary MutableDictionary to store the items fields in, which will eventually end up in blogEntries
        NSMutableDictionary *blogItem = [[NSMutableDictionary alloc] init];
		
        // Create a counter variable as type "int"
        int counter;
		
        // Loop through the children of the current  node
        for(counter = 0; counter < [resultElement childCount]; counter++) {
			
            // Add each field to the blogItem Dictionary with the node name as key and node value as the value
            [blogItem setObject:[[resultElement childAtIndex:counter] stringValue] forKey:[[resultElement childAtIndex:counter] name]];
        }
		
        // Add the blogItem to the global blogEntries Array so that the view can access it.
        [blogEntries addObject:[blogItem copy]];
    }
}
-(void) loginStringParse:(NSString *)_string
{
   // NSLog(@"In parser:%@",_string);
	NSMutableDictionary *temp = [json2 objectWithString:_string error:nil];
	//[temp retain];
	//NSLog(@"%@",temp.descriptionInStringsFileFormat);
    NSMutableDictionary *errorData= [temp valueForKey:@"response"];
    if(![[NSNull null] isEqual:[errorData valueForKey:@"status"]] && ![[errorData valueForKey:@"status"] isEqualToString:@"OK"])
    {
        NSMutableArray *errorArray = [errorData valueForKey:@"errors"];
        if( delegate && [delegate respondsToSelector:@selector(errorResponseData:)])
            [delegate performSelector:@selector(errorResponseData:) withObject:[errorArray objectAtIndex:0]];
        return;
    }
	
	NSMutableDictionary *tempData= [temp valueForKey:@"data"];
	NSMutableDictionary *temp2= [tempData valueForKey:@"user_token"]; 
    
   // NSLog(@"%@",temp2.descriptionInStringsFileFormat);
    tokeInfo *e1 = [[tokeInfo alloc] init];
    
    if ([temp2 valueForKey:@"id"])
        e1.iden=[temp2 valueForKey:@"id"];
    if ([temp2 valueForKey:@"profile_picture"])
    {
        e1.imgURL=[temp2 valueForKey:@"profile_picture"];
        [self getProfileImageURL:[temp2 valueForKey:@"profile_picture"]];
    }
    if ([temp2 valueForKey:@"assess_token"])
        e1.accessToken=[temp2 valueForKey:@"assess_token"];
    if ([temp2 valueForKey:@"username"])
    {
        e1.name=[temp2 valueForKey:@"username"];
        e1.userName=[temp2 valueForKey:@"username"];
        //e1.fu=[temp2 valueForKey:@"username"];
    }
   // if ([temp2 valueForKey:@"username"])
     //   e1.=[temp2 valueForKey:@"username"];
    
    
    [[SingletonClass sharedInstance] setTokenInformation:e1];
    if( delegate && [delegate respondsToSelector:@selector(loginResponse:)])
        [delegate performSelector:@selector(loginResponse:) withObject:[NSNumber numberWithBool:TRUE]];
   
    
}
-(void) registrationStringParse:(NSString  *)_string
{
    NSMutableDictionary *temp = [json2 objectWithString:_string error:nil];
	//[temp retain];
	//NSLog(@"%@",temp.descriptionInStringsFileFormat);
    NSMutableDictionary *errorData= [temp valueForKey:@"response"];
    if(![[NSNull null] isEqual:[errorData valueForKey:@"status"]] && ![[errorData valueForKey:@"status"] isEqualToString:@"OK"])
    {
        NSMutableArray *errorArray = [errorData valueForKey:@"errors"];
        if( delegate && [delegate respondsToSelector:@selector(errorResponseData:)])
            [delegate performSelector:@selector(errorResponseData:) withObject:[errorArray objectAtIndex:0]];
        return;
    }
	NSMutableDictionary *tempData= [temp valueForKey:@"data"];
	NSMutableDictionary *temp2= [tempData valueForKey:@"user_token"]; 
    tokeInfo *e1 = [[tokeInfo alloc] init];
    
    
    if ([temp2 valueForKey:@"id"])
        e1.iden=[temp2 valueForKey:@"id"];
    if ([temp2 valueForKey:@"profile_picture"] && [[temp2 valueForKey:@"profile_picture"] length])
    {
        e1.imgURL=[temp2 valueForKey:@"profile_picture"];
        [self getProfileImageURL:[temp2 valueForKey:@"profile_picture"]];
    }
    if ([temp2 valueForKey:@"assess_token"])
        e1.accessToken=[temp2 valueForKey:@"assess_token"];
    if ([temp2 valueForKey:@"username"])
    {
        e1.name=[temp2 valueForKey:@"username"];
        e1.userName=[temp2 valueForKey:@"username"];
        //e1.fu=[temp2 valueForKey:@"username"];
    }

    
    [[SingletonClass sharedInstance] setTokenInformation:e1];
    
    if( delegate && [delegate respondsToSelector:@selector(loginResponse:)])
        [delegate performSelector:@selector(loginResponse:) withObject:[NSNumber numberWithBool:TRUE]];
    [e1 release];
}
-(void) userProfileStringParse:(NSString *)_string
{
   
	NSMutableDictionary *temp = [json2 objectWithString:_string error:nil];
   // NSLog(@"%@",temp.descriptionInStringsFileFormat);
    NSMutableDictionary *errorData= [temp valueForKey:@"response"];
    if(![[NSNull null] isEqual:[errorData valueForKey:@"status"]] && ![[errorData valueForKey:@"status"] isEqualToString:@"OK"])
    {
        NSMutableArray *errorArray = [errorData valueForKey:@"errors"];
        if( delegate && [delegate respondsToSelector:@selector(errorResponseData:)])
            [delegate performSelector:@selector(errorResponseData:) withObject:[errorArray objectAtIndex:0]];
        return;
    }
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
	NSMutableDictionary *tempData= [temp valueForKey:@"data"];
    NSLog(@"%@",tempData.descriptionInStringsFileFormat);
	NSMutableDictionary *temp2= [tempData valueForKey:@"user_profile"]; 
	
    userProfile *e1 = [[userProfile alloc] init];
    userProfile *user = [[userProfile alloc] init];
    
    if ([temp2 valueForKey:@"id"])
    {
        e1.iden=[temp2 valueForKey:@"id"];
        user.iden=[temp2 valueForKey:@"id"];
        
    }
    if ([temp2 valueForKey:@"profile_picture"])
    {
        e1.imgURL=[temp2 valueForKey:@"profile_picture"];
         user.imgURL=[temp2 valueForKey:@"profile_picture"];
        if([[temp2 valueForKey:@"url"] length] > 0)
            [self requestForImageDownload:[temp2 valueForKey:@"profile_picture"]];
    }
    
    if ([temp2 valueForKey:@"assess_token"])
        e1.accessToken=[temp2 valueForKey:@"assess_token"];
    if ([temp2 valueForKey:@"username"] && [[temp2 valueForKey:@"username"] length]>0)
    {
        e1.userName=[temp2 valueForKey:@"username"];
        user.userName=[temp2 valueForKey:@"username"];
    }
    if ([temp2 valueForKey:@"full_name"] && [[temp2 valueForKey:@"full_name"] length]>0)
        e1.fullName=[temp2 valueForKey:@"full_name"];
    if ([temp2 valueForKey:@"posts"])
        e1.post=[[temp2 valueForKey:@"posts"] intValue];
    if ([temp2 valueForKey:@"comments"])
        e1.comments=[[temp2 valueForKey:@"comments"] intValue];
    if ([temp2 valueForKey:@"supporter"])
        e1.supporter=[[temp2 valueForKey:@"supporter"] intValue];
    if ([temp2 valueForKey:@"photos"])
        e1.photos=[temp2 valueForKey:@"photos"];
   
    if ([tempData valueForKey:@"post_feed"])
	{
        FeedData *e3 = [[FeedData alloc] init];
        NSMutableArray *temp5  = [tempData valueForKey:@"post_feed"];
     
        /////////   DUMMUY VALUE  /////////////
       // FeedData *feed = [[DataModel getDataInDictionary:1] objectAtIndex:0];
       // e3.photoArray = feed.photoArray;
        ///////////////////////////
        
        if ([temp5 count] > 0)
        {
           e3.photoArray = [self getPhotoArray2:temp5:user];
           
        }
        e1.photoFeed = e3;
        [e3 release];
        [user release];
	}
    [dataArray addObject:e1];
    [e1 release];
    
//    if(!isPull)   /// for first time data fetching 
//	{
//		[DataModel setDataInDictionary:dataArray:3];
//		if( delegate && [delegate respondsToSelector:@selector(ParserArraylist:)])
//			[delegate performSelector:@selector(ParserArraylist:) withObject:dataArray];
//	}
//	else    /// is used for pulling function
    
    if( delegate && [delegate respondsToSelector:@selector(ParserArraylist:)])
        [delegate performSelector:@selector(ParserArraylist:) withObject:dataArray];
     [dataArray release];
}


// new addition

-(void) userNearByLocationParse:(NSString *)_string
{
    
	NSMutableDictionary *temp = [json2 objectWithString:_string error:nil];
    // NSLog(@"%@",temp.descriptionInStringsFileFormat);
  //  NSMutableDictionary *errorData= [temp valueForKey:@"response"];
    if(![[NSNull null] isEqual:[temp valueForKey:@"status"]] && ![[temp valueForKey:@"status"] isEqualToString:@"OK"])
    {
        NSMutableDictionary *dic = [[[NSMutableDictionary alloc] init] autorelease];
        [dic setObject:[temp valueForKey:@"status"] forKey:@"message"];
      //  NSMuableArray *errorArray = [temp valueForKey:@"errors"];
        if( delegate && [delegate respondsToSelector:@selector(errorResponseData:)])
            [delegate performSelector:@selector(errorResponseData:) withObject:dic];
        return;
    }
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
	NSMutableArray *tempData= [temp valueForKey:@"results"];
    for (int i = 0  ; i < [tempData count]; i++)
     {
    
         if([[tempData objectAtIndex:i] isKindOfClass:[NSMutableDictionary class]])
         {
             NSMutableDictionary *temp2= [tempData objectAtIndex:i];	
             NearbyLocationObject *e1 = [[NearbyLocationObject alloc] init];
   
    
             if ([temp2 valueForKey:@"id"])
             {
                 e1.loc_id  = [temp2 valueForKey:@"id"];
             }
             if ([temp2 valueForKey:@"name"])
             {
                 e1.loc_name  = [temp2 valueForKey:@"name"];
             }
             if ([temp2 valueForKey:@"vicinity"])
             {
                 e1.loc_vicinity  = [temp2 valueForKey:@"vicinity"];
             }
             
             if([temp2 objectForKey:@"geometry"])
             {
                 NSMutableDictionary *temp3 = [temp2 objectForKey:@"geometry"];
                 if([temp3 objectForKey:@"location"])
                 {
                     NSMutableDictionary *temp4 = [temp3 objectForKey:@"location"];
                     
                     if ([temp4 valueForKey:@"lat"])
                    {
                        e1.loc_lat  = [[temp4 valueForKey:@"lat"] doubleValue];
                    }
                     if ([temp4 valueForKey:@"lng"])
                    {
                        e1.loc_long  = [[temp4 valueForKey:@"lng"] doubleValue];
                    }
                 }
                 
             }
             
             [dataArray addObject:e1];
             [e1 release];
         }
     }
     
    
    if( delegate && [delegate respondsToSelector:@selector(ParserArraylist:)])
        [delegate performSelector:@selector(ParserArraylist:) withObject:dataArray];
    [dataArray release];
}

//


-(void) getUserPostDeleteData:(NSString *)_string
{
    NSMutableDictionary *temp = [json2 objectWithString:_string error:nil];
    // NSLog(@"%@",temp.descriptionInStringsFileFormat);
    NSMutableDictionary *errorData= [temp valueForKey:@"response"];
    if(![[NSNull null] isEqual:[errorData valueForKey:@"status"]] && ![[errorData valueForKey:@"status"] isEqualToString:@"OK"])
    {
        NSMutableArray *errorArray = [errorData valueForKey:@"errors"];
        if( delegate && [delegate respondsToSelector:@selector(errorResponseData:)])
            [delegate performSelector:@selector(errorResponseData:) withObject:[errorArray objectAtIndex:0]];
        return;
    }
    
    
    else
    {
        if(delegate && [delegate respondsToSelector:@selector(loginResponse:)])
            [delegate performSelector:@selector(loginResponse:) withObject:[NSNumber numberWithInt:333]];
    }
}
-(void) getUserPostFlagData:(NSString *)_string
{
    NSMutableDictionary *temp = [json2 objectWithString:_string error:nil];
    // NSLog(@"%@",temp.descriptionInStringsFileFormat);
    NSMutableDictionary *errorData= [temp valueForKey:@"response"];
    if(![[NSNull null] isEqual:[errorData valueForKey:@"status"]] && ![[errorData valueForKey:@"status"] isEqualToString:@"OK"])
    {
        NSMutableArray *errorArray = [errorData valueForKey:@"errors"];
        if( delegate && [delegate respondsToSelector:@selector(errorResponseData:)])
            [delegate performSelector:@selector(errorResponseData:) withObject:[errorArray objectAtIndex:0]];
        return;
    }
    
    else
    {
        if( delegate && [delegate respondsToSelector:@selector(loginResponse:)])
            [delegate performSelector:@selector(loginResponse:) withObject:[NSNumber numberWithInt:555]];
    }
}


-(void)getThingsTagsData:(NSString *)_string
{
    NSMutableDictionary *temp = [json2 objectWithString:_string error:nil];
    // NSLog(@"%@",temp.descriptionInStringsFileFormat);
    NSMutableDictionary *errorData= [temp valueForKey:@"response"];
    if(![[NSNull null] isEqual:[errorData valueForKey:@"status"]] && ![[errorData valueForKey:@"status"] isEqualToString:@"OK"])
    {
        NSMutableArray *errorArray = [errorData valueForKey:@"errors"];
        if( delegate && [delegate respondsToSelector:@selector(errorResponseData:)])
            [delegate performSelector:@selector(errorResponseData:) withObject:[errorArray objectAtIndex:0]];
        return;
    }
    
    else
    {
        NSMutableArray *dataArray = [[NSMutableArray alloc] init];
        
        NSMutableDictionary *dataDictionary = [temp objectForKey:@"data"];
        
        NSMutableArray *tempArray = [dataDictionary objectForKey:@"tags"];
        
        
        for (int i = 0  ; i < [tempArray count]; i++)
        {
            
            if([[tempArray objectAtIndex:i] isKindOfClass:[NSMutableDictionary class]])
            {
                NSMutableDictionary *temp2= [tempArray objectAtIndex:i];	
                ThingsData *e1 = [[ThingsData alloc] init];
                
                if ([temp2 valueForKey:@"id"])
                {
                    e1.iden  = [[temp2 valueForKey:@"id"] intValue];
                }
                if ([temp2 valueForKey:@"title"])
                {
                    e1.title  = [[temp2 valueForKey:@"title"] capitalizedString];
                }
                if ([temp2 valueForKey:@"counter"])
                {
                    e1.counter  = [[temp2 valueForKey:@"counter"] intValue];
                }
                
                [dataArray addObject:e1];
                [e1 release];
            }
        }

        
        
        if( delegate && [delegate respondsToSelector:@selector(ParserArraylist:)])
            [delegate performSelector:@selector(ParserArraylist:) withObject:dataArray];
    }
}


-(NSMutableArray *) getPhotoArray2:(NSMutableArray *)_array:(userProfile *)_user
{
    NSMutableArray *dataArray = [[NSMutableArray alloc] initWithCapacity:[_array count]]; 
    for(int i  = 0; i < [_array count]; i++)
    {
        NSMutableDictionary *_temp  = [_array objectAtIndex:i];
        PhotoData *e2 = [[PhotoData alloc] init];
        if ([_temp valueForKey:@"title"])
            e2.title=[_temp valueForKey:@"title"];
        if ([_temp valueForKey:@"comments"] && [(NSArray *)[_temp valueForKey:@"comments"] count] > 0)
        {
            e2.commentArray =  [self getCommentArray:[_temp valueForKey:@"comments"]];
            
        }
        if ([_temp valueForKey:@"created_time"])
            e2.createdDate=[_temp valueForKey:@"created_time"];
        if ([_temp valueForKey:@"supporters"])
            e2.supporters=[NSNumber numberWithInt:[[_temp valueForKey:@"supporters"] intValue]];
        if ([_temp valueForKey:@"id"])
            e2.iden=[_temp valueForKey:@"id"];
        /*  if ([_temp valueForKey:@"supporters"] && [[_temp valueForKey:@"supporters"] count]> 0)
         {
         e2.supporterArray =  [self getLikeData:[_temp valueForKey:@"supporters"]];
         }*/
        e2.user =  _user;
        if ([_temp valueForKey:@"location"])
        {
            e2.location =  [self getLocation:[_temp valueForKey:@"location"]];
        }
        if ([_temp valueForKey:@"low_resolution"])
        {
            e2.lowResolution =  [self getResolution:[_temp valueForKey:@"low_resolution"]:TRUE];
        }
        if ([_temp valueForKey:@"standard_resolution"])
        {
            e2.standResolution =  [self getResolution:[_temp valueForKey:@"standard_resolution"]:FALSE];
        }
        if ([_temp valueForKey:@"thumbnail"])
        {
            e2.thumbnail =  [self getResolution:[_temp valueForKey:@"thumbnail"]:TRUE];
        }
        if ([_temp valueForKey:@"tags"])
        {
            if([(NSArray *)[_temp valueForKey:@"tags"] count]> 0)
                e2.tag = [[_temp valueForKey:@"tags"] objectAtIndex:0] ;
            
        }
        if ([_temp valueForKey:@"description"])
        {
            e2.desc = [_temp valueForKey:@"description"];
            
        }
        if ([_temp valueForKey:@"post_page"])
        {
            e2.postPageUrl =  [_temp valueForKey:@"post_page"];
        }
        
        
        [dataArray addObject:e2];
        [e2 release];
    }
    return dataArray;
    
}
-(BOOL) checkNullValues:(NSString *)_string
{
    if([_string isEqualToString:@"(null)"])
        return FALSE;
    else if ([_string length] == 0)
        return FALSE;
    return TRUE;
}
-(void) userFeedStringParse:(NSString *)_string
{
    
	NSMutableDictionary *temp = [json2 objectWithString:_string error:nil];
    NSMutableDictionary *errorData= [temp valueForKey:@"response"];
    if(![[NSNull null] isEqual:[errorData valueForKey:@"status"]] && ![[errorData valueForKey:@"status"] isEqualToString:@"OK"])
    {
        NSMutableArray *errorArray = [errorData valueForKey:@"errors"];
        if( delegate && [delegate respondsToSelector:@selector(errorResponseData:)])
            [delegate performSelector:@selector(errorResponseData:) withObject:[errorArray objectAtIndex:0]];
        return;
    }
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
	NSMutableDictionary *tempData= [temp valueForKey:@"data"];
     NSLog(@"%@",tempData.descriptionInStringsFileFormat);
    if (tempData)
	{

     FeedData *e3 = [[FeedData alloc] init];
    if ([tempData valueForKey:@"blocksize"])
        e3.blocksize=[tempData valueForKey:@"blocksize"];
    if ([tempData valueForKey:@"offset"])
        e3.offset=[tempData valueForKey:@"offset"];
        NSMutableArray *temp5  = [tempData valueForKey:@"post_feed"];
        //     NSLog(@"%@",temp5.descriptionInStringsFileFormat);
     
        if ([temp5 count]>0)
        {
            e3.photoArray = [self getPhotoArray:temp5];
        }
        [dataArray addObject:e3];
        [e3 release];
	}
    
 
 
    if(!isPull)   /// for first time data fetching 
  {
     
       [DataModel setDataInDictionary:dataArray:1];
	  if( delegate && [delegate respondsToSelector:@selector(loginResponse:)])
        [delegate performSelector:@selector(loginResponse:) withObject:[NSNumber numberWithBool:TRUE]];
  }
	else    /// is used for pulling function
	{
		[DataModel upDateDataInDictionary:dataArray:1];   
		if( delegate && [delegate respondsToSelector:@selector(hasPullNewData:)])
			[delegate performSelector:@selector(hasPullNewData:) withObject:dataArray];
		
	}
   [dataArray release];
}

-(void) popularStringParse:(NSString *)_string
{
	//NSLog(@"%@",_string);
    NSMutableDictionary *temp = [json2 objectWithString:_string error:nil];
    NSMutableDictionary *errorData= [temp valueForKey:@"response"];
    if(![[NSNull null] isEqual:[errorData valueForKey:@"status"]] && ![[errorData valueForKey:@"status"] isEqualToString:@"OK"])
    {
        NSMutableArray *errorArray = [errorData valueForKey:@"errors"];
        if( delegate && [delegate respondsToSelector:@selector(errorResponseData:)])
            [delegate performSelector:@selector(errorResponseData:) withObject:[errorArray objectAtIndex:0]];
        return;
    }
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
	NSMutableDictionary *tempData= [temp valueForKey:@"data"];
    NSLog(@"%@",tempData.descriptionInStringsFileFormat);
        
        FeedData *e3 = [[FeedData alloc] init];
        if ([tempData valueForKey:@"blocksize"])
            e3.blocksize=[tempData valueForKey:@"blocksize"];
        if ([tempData valueForKey:@"offset"])
            e3.offset=[tempData valueForKey:@"offset"];
        if ([tempData valueForKey:@"photos"])
        {
            e3.photoArray = [self getPhotoArray:[tempData valueForKey:@"photos"]];
        }
       
        [dataArray addObject:e3];
        [e3 release];
    
    if(!isPull)   /// for first time data fetching 
	{
		[DataModel setDataInDictionary:dataArray:2];
		if( delegate && [delegate respondsToSelector:@selector(loginResponse:)])
			[delegate performSelector:@selector(loginResponse:) withObject:[NSNumber numberWithBool:TRUE]];
	}
	else    /// is used for pulling function
	{
		[DataModel upDateDataInDictionary:dataArray:2];   
		if( delegate && [delegate respondsToSelector:@selector(hasPullNewData)])
			[delegate performSelector:@selector(hasPullNewData)];
		
	}
    [dataArray release];
        
}
    
-(void) nearByStringParse:(NSString *)_string
{
	//NSLog(@"%@",_string);
    NSMutableDictionary *temp = [json2 objectWithString:_string error:nil];
    NSMutableDictionary *errorData= [temp valueForKey:@"response"];
    if(![[NSNull null] isEqual:[errorData valueForKey:@"status"]] && ![[errorData valueForKey:@"status"] isEqualToString:@"OK"])
    {
        NSMutableArray *errorArray = [errorData valueForKey:@"errors"];
        if( delegate && [delegate respondsToSelector:@selector(errorResponseData:)])
            [delegate performSelector:@selector(errorResponseData:) withObject:[errorArray objectAtIndex:0]];
        return;
    }
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
	NSMutableDictionary *tempData= [temp valueForKey:@"data"];
   // NSLog(@"%@",tempData.descriptionInStringsFileFormat);
    
    FeedData *e3 = [[FeedData alloc] init];
    if ([tempData valueForKey:@"blocksize"])
        e3.blocksize=[tempData valueForKey:@"blocksize"];
    if ([tempData valueForKey:@"offset"])
        e3.offset=[tempData valueForKey:@"offset"];
    if ([tempData valueForKey:@"post_feed"])
    {
        e3.photoArray = [self getPhotoArray:[tempData valueForKey:@"post_feed"]];
    }
    
    [dataArray addObject:e3];
    [e3 release];
    
    if(!isPull )//&& ![commonUsedMethods getIsRefreshData])   /// for first time data fetching 
	{
		[DataModel setDataInDictionary:dataArray:3];
		if( delegate && [delegate respondsToSelector:@selector(ParserArraylist:)])
			[delegate performSelector:@selector(ParserArraylist:) withObject:dataArray];
	}
	else    /// is used for pulling function
	{
		BOOL result = [DataModel updateNearByData:dataArray:3];   
        if( delegate && [delegate respondsToSelector:@selector(loginResponse:)])
            [delegate performSelector:@selector(loginResponse:) withObject:[NSNumber numberWithBool:result]];
        if( delegate && [delegate respondsToSelector:@selector(ParserArraylist:)])
			[delegate performSelector:@selector(ParserArraylist:) withObject:dataArray];
	}
    [dataArray release];
	
}
-(void) searchStringParse:(NSString *)_string
{
    NSMutableDictionary *temp = [json2 objectWithString:_string error:nil];
    NSMutableDictionary *errorData= [temp valueForKey:@"response"];
    if(![[NSNull null] isEqual:[errorData valueForKey:@"status"]] && ![[errorData valueForKey:@"status"] isEqualToString:@"OK"])
    {
        NSMutableArray *errorArray = [errorData valueForKey:@"errors"];
        if( delegate && [delegate respondsToSelector:@selector(errorResponseData:)])
            [delegate performSelector:@selector(errorResponseData:) withObject:[errorArray objectAtIndex:0]];
        return;
    }
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
	NSMutableDictionary *tempData= [temp valueForKey:@"data"];
    //NSLog(@"%@",tempData.descriptionInStringsFileFormat);
    
    FeedData *e3 = [[FeedData alloc] init];
    if ([tempData valueForKey:@"blocksize"])
        e3.blocksize=[tempData valueForKey:@"blocksize"];
    if ([tempData valueForKey:@"offset"])
        e3.offset=[tempData valueForKey:@"offset"];
    if ([tempData valueForKey:@"post_feed"])
    {
        e3.photoArray = [self getPhotoArray:[tempData valueForKey:@"post_feed"]];
    }
    
    [dataArray addObject:e3];
    [e3 release];
    
    if(!isPull)   /// for first time data fetching 
	{
		     [DataModel setDataInDictionary:dataArray:2];
        if( delegate && [delegate respondsToSelector:@selector(ParserArraylist:)])
			[delegate performSelector:@selector(ParserArraylist:) withObject:dataArray];
	}
	else    /// is used for pulling function
	{
          [DataModel upDateDataInDictionary:dataArray:2];
        if( delegate && [delegate respondsToSelector:@selector(hasPullNewData:)])
			[delegate performSelector:@selector(hasPullNewData:) withObject:dataArray];
		
	}
    [dataArray release];
}
-(void) TopFeedStringParse:(NSString *)_string
{
    NSMutableDictionary *temp = [json2 objectWithString:_string error:nil];
    NSMutableDictionary *errorData= [temp valueForKey:@"response"];
    if(![[NSNull null] isEqual:[errorData valueForKey:@"status"]] && ![[errorData valueForKey:@"status"] isEqualToString:@"OK"])
    {
        NSMutableArray *errorArray = [errorData valueForKey:@"errors"];
        if( delegate && [delegate respondsToSelector:@selector(errorResponseData:)])
            [delegate performSelector:@selector(errorResponseData:) withObject:[errorArray objectAtIndex:0]];
        return;
    }
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
	NSMutableDictionary *tempData= [temp valueForKey:@"data"];
     NSLog(@"%@",tempData.descriptionInStringsFileFormat);
    
    FeedData *e3 = [[FeedData alloc] init];
    if ([tempData valueForKey:@"blocksize"])
        e3.blocksize=[tempData valueForKey:@"blocksize"];
    if ([tempData valueForKey:@"offset"])
        e3.offset=[tempData valueForKey:@"offset"];
    if ([tempData valueForKey:@"post_feed"])
    {
        e3.photoArray = [self getPhotoArray:[tempData valueForKey:@"post_feed"]];
    }
    
    [dataArray addObject:e3];
    [e3 release];
    
	if(!isPull)   /// for first time data fetching 
	{
		 [DataModel setDataInDictionary:dataArray:4];
		if( delegate && [delegate respondsToSelector:@selector(loginResponse:)])
			[delegate performSelector:@selector(loginResponse:) withObject:[NSNumber numberWithBool:TRUE]];
	}
	else    /// is used for pulling function
	{
		[DataModel upDateDataInDictionary:dataArray:4];   
        if( delegate && [delegate respondsToSelector:@selector(hasPullNewData:)])
			[delegate performSelector:@selector(hasPullNewData:) withObject:dataArray];
	}
    [dataArray release];
}
-(userProfile *) getUser:(NSMutableDictionary *)_dictionary
{
    userProfile *e2 = [[userProfile alloc] init];
    
       
        if ([_dictionary valueForKey:@"id"])
            e2.iden=[_dictionary valueForKey:@"id"];
        if ([_dictionary valueForKey:@"profile_picture"] && [[_dictionary valueForKey:@"profile_picture"] length]> 0)
            e2.imgURL=[_dictionary valueForKey:@"profile_picture"];
        if ([_dictionary valueForKey:@"username"] && [[_dictionary valueForKey:@"username"] length]>0)
            e2.userName=[_dictionary valueForKey:@"username"];
       if ([_dictionary valueForKey:@"full_name"] && [[_dictionary valueForKey:@"full_name"] length]>0)
          e2.fullName=[_dictionary valueForKey:@"full_name"];
	if([[_dictionary valueForKey:@"profile_picture"] length] > 0)
	      [self requestForImageDownload:[_dictionary valueForKey:@"profile_picture"]];
        return e2;
    
}
-(NSMutableArray *) getPhotoArray:(NSMutableArray *)_array
{
    NSMutableArray *dataArray = [[NSMutableArray alloc] initWithCapacity:[_array count]]; 
    for(int i  = 0; i < [_array count]; i++)
    {
        NSMutableDictionary *_temp  = [_array objectAtIndex:i];
        PhotoData *e2 = [[PhotoData alloc] init];
        if ([_temp valueForKey:@"title"])
            e2.title=[_temp valueForKey:@"title"];
        if ([_temp valueForKey:@"comments"] && [(NSArray *)[_temp valueForKey:@"comments"] count] > 0)
        {
            e2.commentArray =  [self getCommentArray:[_temp valueForKey:@"comments"]];
           
        }
        if ([_temp valueForKey:@"created_time"])
            e2.createdDate=[_temp valueForKey:@"created_time"];
        if ([_temp valueForKey:@"supporters"])
            e2.supporters=[NSNumber numberWithInt:[[_temp valueForKey:@"supporters"] intValue]];
        if ([_temp valueForKey:@"id"])
            e2.iden=[_temp valueForKey:@"id"];
      /*  if ([_temp valueForKey:@"supporters"] && [[_temp valueForKey:@"supporters"] count]> 0)
        {
            e2.supporterArray =  [self getLikeData:[_temp valueForKey:@"supporters"]];
        }*/
        if ([_temp valueForKey:@"from"])
        {
            e2.user =  [self getUser:[_temp valueForKey:@"from"]];
        }
        if ([_temp valueForKey:@"location"])
        {
            e2.location =  [self getLocation:[_temp valueForKey:@"location"]];
        }
        if ([_temp valueForKey:@"low_resolution"])
        {
            e2.lowResolution =  [self getResolution:[_temp valueForKey:@"low_resolution"]:TRUE];
        }
        if ([_temp valueForKey:@"standard_resolution"])
        {
            e2.standResolution =  [self getResolution:[_temp valueForKey:@"standard_resolution"]:FALSE];
        }
        if ([_temp valueForKey:@"thumbnail"])
        {
            e2.thumbnail =  [self getResolution:[_temp valueForKey:@"thumbnail"]:TRUE];
        }
        if ([_temp valueForKey:@"post_page"])
        {
            e2.postPageUrl =  [_temp valueForKey:@"post_page"];
        }
        
        if ([_temp valueForKey:@"tags"])
        {
            if([(NSArray *)[_temp valueForKey:@"tags"] count]> 0)
            e2.tag = [[_temp valueForKey:@"tags"] objectAtIndex:0] ;
           
        }
        if ([_temp valueForKey:@"description"])
        {
            e2.desc = [_temp valueForKey:@"description"];
            
        }
        
        
        [dataArray addObject:e2];
        [e2 release];
    }
    return dataArray;
    
}
-(NSMutableArray *) getCommentArray:(NSMutableArray *)_commentArray
{
    if(!_commentArray || [_commentArray count] == 0)
        return 0;
    
    NSMutableArray *dataArray = [[[NSMutableArray alloc] init] autorelease];
    //  NSLog(@"%d",[_commentArray count]);
    for (int i = 0; i < [_commentArray count]; i++) 
    {
        CommentsData *e2 = [[CommentsData alloc] init];
        NSMutableDictionary *_dictionary = [_commentArray objectAtIndex:i];
        if ([_dictionary valueForKey:@"created_time"])
            e2.createdDate=[_dictionary valueForKey:@"created_time"];
        if ([_dictionary valueForKey:@"text"])
            e2.textData=[_dictionary valueForKey:@"text"];
        if ([_dictionary valueForKey:@"from"])
        {
            e2.user = [self getUser:[_dictionary valueForKey:@"from"]];
        }
        
        [dataArray addObject:e2];
        [e2 release];
    }
    return dataArray;
    
}
-(NSMutableArray *) getLikeData:(NSMutableArray *)_supporterArray
{
    if(!_supporterArray || [_supporterArray count] == 0)
        return 0;
    
    NSMutableArray *commentArray = [[[NSMutableArray alloc] init] autorelease];
 //   NSLog(@"%d",[_supporterArray count]);
    for (int i = 0; i < [_supporterArray count]; i++) 
    {
        likeData *e2 = [[likeData alloc] init];
        NSMutableDictionary *_dictionary = [_supporterArray objectAtIndex:i];
         e2.user = [self getUser:_dictionary];
        [commentArray addObject:e2];
        [e2 release];
       // if ([_dictionary valueForKey:@"count"])
          //  e2.count=[_dictionary valueForKey:@"count"];
       // if ([_dictionary valueForKey:@"from"])
       // {
          //  e2.user = [self getUser:_dictionary];
       // }
       
    }
    return commentArray;
}
-(locationData *) getLocation:(NSMutableDictionary *)_dictionary
{
    
    locationData *e1  = [[locationData alloc] init];
    if ([_dictionary valueForKey:@"id"])
        e1.iden=[[_dictionary valueForKey:@"id"] intValue];
    if ([_dictionary valueForKey:@"lat"] && [_dictionary valueForKey:@"lat"] != NULL)
        e1.latitude=[[_dictionary valueForKey:@"lat"] doubleValue];
    if ([_dictionary valueForKey:@"long"] && [_dictionary valueForKey:@"long"] != NULL)
        e1.longitude=[[_dictionary valueForKey:@"long"] doubleValue];
    if ([_dictionary valueForKey:@"location_name"])
    {
        e1.locName=[[_dictionary valueForKey:@"location_name"] stringByReplacingOccurrencesOfString:@",(null)" withString:@""];
    }
        
       return e1;
     
    
}
//-(ResolutionInfo *) getResolution:(NSMutableDictionary *)_dictionary:(BOOL)isDownloadAble
-(ResolutionInfo *) getResolution:(NSString *)_urlString:(BOOL)isDownloadAble
{
      if ([_urlString length] > 0)
      {
          
          ResolutionInfo *e1  = [[ResolutionInfo alloc] init];
          e1.url=_urlString;
	    if(isDownloadAble)
		[self requestForImageDownload:_urlString];
    return e1;
      }
    return 0;
}

-(void) requestForImageDownload:(NSString*)_url
{
	
}
-(void) likeStringPase:(NSString *)_string
{
	NSMutableDictionary *temp = [json2 objectWithString:_string error:nil];
  //  NSMutableDictionary *errorData= [temp valueForKey:@"response"];
 
        if( delegate && [delegate respondsToSelector:@selector(userFeedData:)])
            [delegate performSelector:@selector(userFeedData:) withObject:[temp valueForKey:@"response"]];
   
}
-(void) getPhotoDetail:(NSString *)_string
{
	NSMutableDictionary *temp = [json2 objectWithString:_string error:nil];
    NSMutableDictionary *errorData= [temp valueForKey:@"response"];
    if(![[NSNull null] isEqual:[errorData valueForKey:@"status"]] && ![[errorData valueForKey:@"status"] isEqualToString:@"OK"])
    {
        NSMutableArray *errorArray = [errorData valueForKey:@"errors"];
        if( delegate && [delegate respondsToSelector:@selector(errorResponseData:)])
            [delegate performSelector:@selector(errorResponseData:) withObject:[errorArray objectAtIndex:0]];
        return;
    }
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
	NSMutableDictionary *tempData1= [temp valueForKey:@"data"];
    //NSLog(@"%@",tempData.descriptionInStringsFileFormat);
    if ([tempData1 valueForKey:@"photo"])
    {
        NSMutableDictionary *tempData = [tempData1 valueForKey:@"photo"];
        PhotoData *e2 = [[PhotoData alloc] init];
        if ([tempData valueForKey:@"title"])
            e2.title=[tempData valueForKey:@"title"];
        if ([tempData valueForKey:@"comments"] && [(NSArray *)[tempData valueForKey:@"comments"] count] > 0)
            e2.commentArray =  [self getCommentArray:[tempData valueForKey:@"comments"]];
        if ([tempData valueForKey:@"created_time"])
            e2.createdDate=[tempData valueForKey:@"created_time"];
        if ([tempData valueForKey:@"supporters"])
            e2.supporters=[tempData valueForKey:@"supporters"];
        if ([tempData valueForKey:@"id"])
            e2.iden=[tempData valueForKey:@"id"];
        if ([tempData valueForKey:@"likes"] && [(NSArray *)[tempData valueForKey:@"likes"] count]> 0)
            e2.supporterArray =  [self getLikeData:[tempData valueForKey:@"likes"]];
        if ([tempData valueForKey:@"user"])
            e2.user =  [self getUser:[tempData valueForKey:@"user"]];
        if ([tempData valueForKey:@"location"])
            e2.location =  [self getLocation:[tempData valueForKey:@"location"]];
        if ([tempData valueForKey:@"low_resolution"])
            e2.lowResolution =  [self getResolution:[tempData valueForKey:@"low_resolution"]:TRUE];
        if ([tempData valueForKey:@"standard_resolution"])
            e2.standResolution =  [self getResolution:[tempData valueForKey:@"standard_resolution"]:FALSE];
        if ([tempData valueForKey:@"thumbnail"])
            e2.thumbnail =  [self getResolution:[tempData valueForKey:@"thumbnail"]:TRUE];
        if ([tempData valueForKey:@"tags"])
            e2.tag = [tempData valueForKey:@"tags"];
        if ([tempData valueForKey:@"post_page"])
        {
            e2.postPageUrl =  [tempData valueForKey:@"post_page"];
        }
        [dataArray addObject:e2];
        [e2 release];
    }
    if( delegate && [delegate respondsToSelector:@selector(ParserArraylist:)])
			[delegate performSelector:@selector(ParserArraylist:) withObject:dataArray];

	[dataArray release];
	
}
-(void) getPhotoUploadResponse:(NSString *)_string
{
    
	//NSLog(@"%@",_string);
    NSMutableDictionary *temp = [json2 objectWithString:_string error:nil];
    NSMutableDictionary *errorData= [temp valueForKey:@"response"];
    if(![[NSNull null] isEqual:[errorData valueForKey:@"status"]] && ![[errorData valueForKey:@"status"] isEqualToString:@"OK"])
    {
        NSMutableArray *errorArray = [errorData valueForKey:@"errors"];
        if( delegate && [delegate respondsToSelector:@selector(errorResponseData:)])
            [delegate performSelector:@selector(errorResponseData:) withObject:[errorArray objectAtIndex:0]];
        return;
    }
	NSMutableDictionary *tempData= [temp valueForKey:@"data"];
     NSLog(@"%@",tempData.descriptionInStringsFileFormat);
    
    PhotoData *e2 = [[PhotoData alloc] init];
    
    if ([tempData valueForKey:@"post"])
    {
        NSMutableDictionary *tempDic= [tempData valueForKey:@"post"];
         if ([tempDic valueForKey:@"title"])
            e2.title=[tempDic valueForKey:@"title"];
        if ([tempDic valueForKey:@"description"])
            e2.desc=[tempDic valueForKey:@"description"];
        if ([tempDic valueForKey:@"comments"] && [(NSArray *)[tempDic valueForKey:@"comments"] count] > 0 )
        {
            e2.commentArray =  [self getCommentArray:[tempDic valueForKey:@"comments"]];
            
        }
        if ([tempDic valueForKey:@"created_time"])
            e2.createdDate=[tempDic valueForKey:@"created_time"];
        if ([tempDic valueForKey:@"supporters"])
            e2.supporters=[tempDic valueForKey:@"supporters"];
        if ([tempDic valueForKey:@"id"])
            e2.iden=[tempDic valueForKey:@"id"];
        /*
        if ([tempDic valueForKey:@"supporters"])
        {
            // NSLog(@"%@",[_temp valueForKey:@"likes"]);
            e2.supporterArray =  [self getLikeData:[tempDic valueForKey:@"supporters"]];
        }*/
            e2.user =  [self getLoggedUser];
        
        if ([tempDic valueForKey:@"location"])
        {
            e2.location =  [self getLocation:[tempDic valueForKey:@"location"]];
        }
        if ([tempDic valueForKey:@"low_resolution"])
        {
            e2.lowResolution =  [self getResolution:[tempDic valueForKey:@"low_resolution"]:TRUE];
        }
        if ([tempDic valueForKey:@"standard_resolution"])
        {
            e2.standResolution =  [self getResolution:[tempDic valueForKey:@"standard_resolution"]:FALSE];
        }
        if ([tempDic valueForKey:@"thumbnail"])
        {
            e2.thumbnail =  [self getResolution:[tempDic valueForKey:@"thumbnail"]:TRUE];
        }
        if ([tempDic valueForKey:@"post_page"])
             e2.postPageUrl =  [tempDic valueForKey:@"post_page"];
            
        if ([tempDic valueForKey:@"tags"])
        {
            NSMutableArray *_tagArray = [tempDic valueForKey:@"tags"];
            if([_tagArray count] > 0)
            e2.tag = [_tagArray objectAtIndex:0];
            
        }

    }
    NSMutableArray *dataArray = [[NSMutableArray alloc] initWithObjects:e2, nil];
		[DataModel addUploadedPhotoInDictionary:e2];
     if( delegate && [delegate respondsToSelector:@selector(ParserArraylist:)])
            [delegate performSelector:@selector(ParserArraylist:) withObject:dataArray];
     [e2 release];
    [dataArray release];
}
-(userProfile *) getLoggedUser
{
    userProfile *user = [[[userProfile alloc] init] autorelease];
	tokeInfo *tokeninfo = [[SingletonClass sharedInstance] getTokenInformation];
	user.iden = tokeninfo.iden;
	user.imgURL = tokeninfo.imgURL;
    if(!tokeninfo.userName || [tokeninfo.userName length] == 0)
        user.userName = @"";
    else
        user.userName = tokeninfo.userName;
    if(tokeninfo.imgURL || [tokeninfo.imgURL length] > 0)
        user.imgURL = tokeninfo.imgURL;
	
    return user;
    
}
-(void) personalProfileStringParse:(NSString *)_string
{
	NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
	NSMutableDictionary *temp = [json2 objectWithString:_string error:nil];
	[temp retain];
	NSMutableDictionary *temp2= [temp valueForKey:@"user_profile"]; 
	
	userProfile *e1 = [[userProfile alloc] init];
    if (![[NSNull null] isEqual:[temp2 valueForKey:@"id"]])
        e1.iden=[temp2 valueForKey:@"id"];
    if (![[NSNull null] isEqual:[temp2 valueForKey:@"profile_picture"]])
        e1.imgURL=[temp2 valueForKey:@"profile_picture"];
    if (![[NSNull null] isEqual:[temp2 valueForKey:@"assess_token"]])
        e1.accessToken=[temp2 valueForKey:@"assess_token"];
    if (![[NSNull null] isEqual:[temp2 valueForKey:@"username"]])
        e1.userName=[temp2 valueForKey:@"username"];
    if (![[NSNull null] isEqual:[temp2 valueForKey:@"full_name"]])
        e1.fullName=[temp2 valueForKey:@"full_name"];
    if (![[NSNull null] isEqual:[temp2 valueForKey:@"badges"]])
        e1.badges=[temp2 valueForKey:@"badges"];
    if (![[NSNull null] isEqual:[temp2 valueForKey:@"followers"]])
        e1.followers=[temp2 valueForKey:@"followers"];
    if (![[NSNull null] isEqual:[temp2 valueForKey:@"follows"]])
        e1.follows=[temp2 valueForKey:@"follows"];
    if (![[NSNull null] isEqual:[temp2 valueForKey:@"photos"]])
        e1.photos=[temp2 valueForKey:@"photos"];
    
    if (![[NSNull null] isEqual:[temp2 valueForKey:@"pets"]])
	{
		NSMutableDictionary *_temp = [temp2 valueForKey:@"pets"];
        petsObject *e2 = [[petsObject alloc] init];
			if (![[NSNull null] isEqual:[_temp valueForKey:@"name"]])
                e2.petName=[_temp valueForKey:@"name"];
            if (![[NSNull null] isEqual:[_temp valueForKey:@"dob"]])
                e2.dob=[_temp valueForKey:@"dob"];
            if (![[NSNull null] isEqual:[_temp valueForKey:@"kind"]])
                e2.kind=[_temp valueForKey:@"kind"];
            if (![[NSNull null] isEqual:[_temp valueForKey:@"breed"]])
                e2.breed=[_temp valueForKey:@"breed"];
            if ([_temp valueForKey:@"id"])
            e2.iden=[_temp valueForKey:@"id"];
                if ([_temp valueForKey:@"sex"])
            e2.sex=[_temp valueForKey:@"sex"];
            if ([_temp valueForKey:@"tags"] && [(NSArray *)[_temp valueForKey:@"tags"] count]>0)
                e2.tagArray= [_temp valueForKey:@"tags"];
			[tempArray addObject:e2];
			[e2 release];
	}
	if ([temp2 valueForKey:@"relationship"])
	{
		e1.relationShip = [temp2 valueForKey:@"relationship"];
	}
    e1.petArray = tempArray;
    [tempArray release];
    [dataArray addObject:e1];
	[DataModel setDataInDictionary:dataArray:8];
    [e1 release];
    [dataArray release];
    
    if( delegate && [delegate respondsToSelector:@selector(loginResponse:)])
        [delegate performSelector:@selector(loginResponse:) withObject:[NSNumber numberWithBool:TRUE]];
	
}
-(void) userPhotoStringParse:(NSString *)_string
{
	NSMutableArray *dataArray = [[NSMutableArray alloc] init];
	NSMutableDictionary *temp = [json2 objectWithString:_string error:nil];
	[temp retain];
	NSMutableDictionary *temp2= [temp valueForKey:@"photo_feed"]; 
    FeedData *e1 = [[FeedData alloc] init];
    
    if (![[NSNull null] isEqual:[temp2 valueForKey:@"blocksize"]])
        e1.blocksize=[temp2 valueForKey:@"blocksize"];
    if (![[NSNull null] isEqual:[temp2 valueForKey:@"offset"]])
        e1.offset=[temp2 valueForKey:@"offset"];
    
    if (![[NSNull null] isEqual:[temp2 valueForKey:@"photos"]])
    {
        e1.photoArray = [self getPhotoArray:[temp2 valueForKey:@"photos"]];
    }
    [dataArray addObject:e1];
    [e1 release];
	if(!isPull)   /// for first time data fetching 
	{
		if( delegate && [delegate respondsToSelector:@selector(ParserArraylist:)])
			[delegate performSelector:@selector(ParserArraylist:) withObject:dataArray];
	}
	else    /// is used for pulling function
	{
		if( delegate && [delegate respondsToSelector:@selector(addPullDataInlist:)])
			[delegate performSelector:@selector(addPullDataInlist:) withObject:dataArray];
		
	}
	[dataArray release];
	
}
-(void) userFollowingStringParse:(NSString *)_string
{
    NSMutableDictionary *temp = [json2 objectWithString:_string error:nil];
    NSMutableDictionary *errorData= [temp valueForKey:@"response"];
    if(![[NSNull null] isEqual:[errorData valueForKey:@"status"]] && ![[errorData valueForKey:@"status"] isEqualToString:@"OK"])
    {
        NSMutableArray *errorArray = [errorData valueForKey:@"errors"];
        if( delegate && [delegate respondsToSelector:@selector(errorResponseData:)])
            [delegate performSelector:@selector(errorResponseData:) withObject:[errorArray objectAtIndex:0]];
        return;
    }
   	NSMutableDictionary *tempData= [temp valueForKey:@"data"];
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
	NSMutableArray *temp2= [tempData valueForKey:@"users"]; 
	for (int i = 0; i < [temp2 count]; i++) {
		[dataArray addObject:[self getUser:[temp2 objectAtIndex:i]]];
	}
	if( delegate && [delegate respondsToSelector:@selector(ParserArraylist:)])
		[delegate performSelector:@selector(ParserArraylist:) withObject:dataArray];
	[dataArray release];
	
}
-(void) userFollowedStringParse:(NSString *)_string
{
    NSMutableDictionary *temp = [json2 objectWithString:_string error:nil];
    //NSLog(@"%@",temp.descriptionInStringsFileFormat);
    NSMutableDictionary *errorData= [temp valueForKey:@"response"];
    if(![[NSNull null] isEqual:[errorData valueForKey:@"status"]] && ![[errorData valueForKey:@"status"] isEqualToString:@"OK"])
    {
        NSMutableArray *errorArray = [errorData valueForKey:@"errors"];
        if( delegate && [delegate respondsToSelector:@selector(errorResponseData:)])
            [delegate performSelector:@selector(errorResponseData:) withObject:[errorArray objectAtIndex:0]];
        return;
    }
   	NSMutableDictionary *tempData= [temp valueForKey:@"data"];
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
	NSMutableArray *temp2= [tempData valueForKey:@"users"]; 
	for (int i = 0; i < [temp2 count]; i++) {
		[dataArray addObject:[self getUser:[temp2 objectAtIndex:i]]];
	}
	if( delegate && [delegate respondsToSelector:@selector(ParserArraylist:)])
		[delegate performSelector:@selector(ParserArraylist:) withObject:dataArray];
	 
	[dataArray release];
}
-(void) relationStringParse:(NSString *)_string
{
    NSMutableDictionary *temp = [json2 objectWithString:_string error:nil];
    NSMutableDictionary *errorData= [temp valueForKey:@"response"];
    if(![[NSNull null] isEqual:[errorData valueForKey:@"status"]] && ![[errorData valueForKey:@"status"] isEqualToString:@"OK"])
    {
        NSMutableArray *errorArray = [errorData valueForKey:@"errors"];
        if( delegate && [delegate respondsToSelector:@selector(errorResponseData:)])
            [delegate performSelector:@selector(errorResponseData:) withObject:[errorArray objectAtIndex:0]];
        return;
    }
    if( delegate && [delegate respondsToSelector:@selector(loginResponse:)])
		[delegate performSelector:@selector(loginResponse:) withObject:[NSNumber numberWithBool:TRUE]];
}
-(void) addPetStringParse:(NSString *)_string
{
    BOOL success = FALSE;
    NSMutableDictionary *temp = [json2 objectWithString:_string error:nil];
    NSMutableDictionary *errorData= [temp valueForKey:@"response"];
    if(![[NSNull null] isEqual:[errorData valueForKey:@"status"]] && ![[errorData valueForKey:@"status"] isEqualToString:@"OK"])
    {
        NSMutableArray *errorArray = [errorData valueForKey:@"errors"];
        if( delegate && [delegate respondsToSelector:@selector(errorResponseData:)])
            [delegate performSelector:@selector(errorResponseData:) withObject:[errorArray objectAtIndex:0]];
        return;
    }
    NSMutableDictionary *temp2= [temp valueForKey:@"data"];
    if ([temp2 valueForKey:@"pet"])
	{
        success = TRUE;
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        NSMutableDictionary *_temp = [temp2 valueForKey:@"pet"];
        NSLog(@"%@",_temp.descriptionInStringsFileFormat);
        petsObject *e2 = [[petsObject alloc] init];
        if ([_temp valueForKey:@"name"] && [self checkNullValues:[_temp valueForKey:@"name"]])
            e2.petName=[_temp valueForKey:@"name"];
        if ([_temp valueForKey:@"dob"] && [self checkNullValues:[_temp valueForKey:@"dob"]])
            e2.dob=[_temp valueForKey:@"dob"];
        if ([_temp valueForKey:@"kind"] && [self checkNullValues:[_temp valueForKey:@"kind"]])
            e2.kind=[_temp valueForKey:@"kind"];
        if ([_temp valueForKey:@"breed"] && [self checkNullValues:[_temp valueForKey:@"breed"]])
            e2.breed=[_temp valueForKey:@"breed"];
        if ([_temp valueForKey:@"id"])
            e2.iden=[_temp valueForKey:@"id"];
        if ([_temp valueForKey:@"sex"])
            e2.sex=[_temp valueForKey:@"sex"];
        if ([_temp valueForKey:@"tags"] && [(NSArray *)[_temp valueForKey:@"tags"] count]>0)
            e2.tagArray= [_temp valueForKey:@"tags"];
         
        [tempArray addObject:e2];
         NSMutableArray *data = [DataModel getDataInDictionary:1];
        userProfile *user = [data objectAtIndex:0];
        user.petArray = tempArray;
        [e2 release];
        [tempArray release]; 
    } 
    if( delegate && [delegate respondsToSelector:@selector(loginResponse:)])
		[delegate performSelector:@selector(loginResponse:) withObject:[NSNumber numberWithBool:success]];
}
-(void) EditProfileStringParse:(NSString *)_string
{
    
    NSMutableDictionary *temp = [json2 objectWithString:_string error:nil];
    NSMutableDictionary *errorData= [temp valueForKey:@"response"];
    if(![[NSNull null] isEqual:[errorData valueForKey:@"status"]] && ![[errorData valueForKey:@"status"] isEqualToString:@"OK"])
    {
        NSMutableArray *errorArray = [errorData valueForKey:@"errors"];
        if( delegate && [delegate respondsToSelector:@selector(errorResponseData:)])
            [delegate performSelector:@selector(errorResponseData:) withObject:[errorArray objectAtIndex:0]];
        return;
    }
    if( delegate && [delegate respondsToSelector:@selector(loginResponse:)])
		[delegate performSelector:@selector(loginResponse:) withObject:[NSNumber numberWithBool:TRUE]];

}

-(void) userProfilePullData:(NSString *)_string
{
    NSMutableDictionary *temp = [json2 objectWithString:_string error:nil];
    NSMutableDictionary *errorData= [temp valueForKey:@"response"];
    if(![[NSNull null] isEqual:[errorData valueForKey:@"status"]] && ![[errorData valueForKey:@"status"] isEqualToString:@"OK"])
    {
        NSMutableArray *errorArray = [errorData valueForKey:@"errors"];
        if( delegate && [delegate respondsToSelector:@selector(errorResponseData:)])
            [delegate performSelector:@selector(errorResponseData:) withObject:[errorArray objectAtIndex:0]];
        return;
    }
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
	NSMutableDictionary *tempData= [temp valueForKey:@"data"];
    
    
    userProfile *e1 = [[userProfile alloc] init];
    if ([tempData valueForKey:@"photo_feed"])
	{
        FeedData *e3 = [[FeedData alloc] init];
        NSMutableDictionary *temp5  = [tempData valueForKey:@"photo_feed"];
        //     NSLog(@"%@",temp5.descriptionInStringsFileFormat);
        if ([temp5 valueForKey:@"blocksize"])
            e3.blocksize=[temp5 valueForKey:@"blocksize"];
        if ([temp5 valueForKey:@"offset"])
            e3.offset=[temp5 valueForKey:@"offset"];
        if ([temp5 valueForKey:@"photos"])
        {
            e3.photoArray = [self getPhotoArray:[temp5 valueForKey:@"photos"]];
        }
        e1.photoFeed = e3;
        [e3 release];
	}
    [dataArray addObject:e1];
    [e1 release];
    if( delegate && [delegate respondsToSelector:@selector(ParserArraylist:)])
        [delegate performSelector:@selector(ParserArraylist:) withObject:dataArray];
    
    [dataArray release];

}
-(void) guideStringParse:(NSString *)_string
{
	                       
	
}

-(void) updatePopularData:(NSString *)_string
{
    NSMutableDictionary *temp = [json2 objectWithString:_string error:nil];
    NSMutableDictionary *errorData= [temp valueForKey:@"response"];
    if(![[NSNull null] isEqual:[errorData valueForKey:@"status"]] && ![[errorData valueForKey:@"status"] isEqualToString:@"OK"])
    {
        NSMutableArray *errorArray = [errorData valueForKey:@"errors"];
        if( delegate && [delegate respondsToSelector:@selector(errorResponseData:)])
            [delegate performSelector:@selector(errorResponseData:) withObject:[errorArray objectAtIndex:0]];
        return;
    }
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
	NSMutableDictionary *tempData= [temp valueForKey:@"data"];
    NSLog(@"%@",tempData.descriptionInStringsFileFormat);
    
    FeedData *e3 = [[FeedData alloc] init];
    if ([tempData valueForKey:@"blocksize"])
        e3.blocksize=[tempData valueForKey:@"blocksize"];
    if ([tempData valueForKey:@"offset"])
        e3.offset=[tempData valueForKey:@"offset"];
    if ([tempData valueForKey:@"photos"])
    {
        e3.photoArray = [self getPhotoArray:[tempData valueForKey:@"photos"]];
    }
    
    [dataArray addObject:e3];
    [e3 release];
  
    if([DataModel upDateExistingDataWithNewData:dataArray:2])
    { 
        if( delegate && [delegate respondsToSelector:@selector(hasPullNewData:)])
            [delegate performSelector:@selector(hasPullNewData:) withObject:dataArray];
    }
        [dataArray release];

    
}
-(void) updateNearByData:(NSString *)_string
{
    NSMutableDictionary *temp = [json2 objectWithString:_string error:nil];
    NSMutableDictionary *errorData= [temp valueForKey:@"response"];
    if(![[NSNull null] isEqual:[errorData valueForKey:@"status"]] && ![[errorData valueForKey:@"status"] isEqualToString:@"OK"])
    {
        NSMutableArray *errorArray = [errorData valueForKey:@"errors"];
        if( delegate && [delegate respondsToSelector:@selector(errorResponseData:)])
            [delegate performSelector:@selector(errorResponseData:) withObject:[errorArray objectAtIndex:0]];
        return;
    }
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
	NSMutableDictionary *tempData= [temp valueForKey:@"data"];
    NSLog(@"%@",tempData.descriptionInStringsFileFormat);
    
    FeedData *e3 = [[FeedData alloc] init];
    if ([tempData valueForKey:@"blocksize"])
        e3.blocksize=[tempData valueForKey:@"blocksize"];
    if ([tempData valueForKey:@"offset"])
        e3.offset=[tempData valueForKey:@"offset"];
    if ([tempData valueForKey:@"photos"])
    {
        e3.photoArray = [self getPhotoArray:[tempData valueForKey:@"photos"]];
    }
    
    [dataArray addObject:e3];
    [e3 release];
    
    if([DataModel upDateExistingDataWithNewData:dataArray:3])
    {
        if( delegate && [delegate respondsToSelector:@selector(hasPullNewData)])
            [delegate performSelector:@selector(hasPullNewData)];
    }
    [dataArray release];
    
}
-(void) updateActivityData:(NSString *)_string
{
    //NSLog(@"%@",_string);
    NSMutableDictionary *temp = [json2 objectWithString:_string error:nil];
    NSMutableDictionary *errorData= [temp valueForKey:@"response"];
    if(![[NSNull null] isEqual:[errorData valueForKey:@"status"]] && ![[errorData valueForKey:@"status"] isEqualToString:@"OK"])
    {
        NSMutableArray *errorArray = [errorData valueForKey:@"errors"];
        if( delegate && [delegate respondsToSelector:@selector(errorResponseData:)])
            [delegate performSelector:@selector(errorResponseData:) withObject:[errorArray objectAtIndex:0]];
        return;
    }
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
	NSMutableDictionary *tempData= [temp valueForKey:@"data"];
    // NSLog(@"%@",tempData.descriptionInStringsFileFormat);
    ActivityController *e1 = [[ActivityController alloc] init];
	NSMutableArray *temp3=  [tempData valueForKey:@"activity"];
    if ([temp3 valueForKey:@"blocksize"])
        e1.blocksize=[temp3 valueForKey:@"blocksize"];
    if ([temp3 valueForKey:@"offset"])
        e1.offset=[temp3 valueForKey:@"offset"];
    if ([temp3 valueForKey:@"activity"])
    {
        NSMutableArray *_activityArray = [[NSMutableArray alloc] init]; 
        NSMutableArray *temp2 = [temp3 valueForKey:@"activity"];
        for (int i = 0 ; i < [temp2 count]; i++) 
        {
            NSMutableDictionary *_activityDictionary = [temp2 objectAtIndex:i];
            ActivityData1 *e2 = [[ActivityData1 alloc] init];
            
            if ([_activityDictionary valueForKey:@"id"])
                e2.iden=[_activityDictionary valueForKey:@"id"];
            if ([_activityDictionary valueForKey:@"photo_id"])
                e2.photoId=[_activityDictionary valueForKey:@"photo_id"];
            if ([_activityDictionary valueForKey:@"type"])
                e2.typeString=[_activityDictionary valueForKey:@"type"];
            if ([_activityDictionary valueForKey:@"text"])
                e2.textString=[_activityDictionary valueForKey:@"text"];
            if ([_activityDictionary valueForKey:@"thumbnail"])
            {
                NSDictionary *thumbDict = [_activityDictionary valueForKey:@"thumbnail"];
                e2.thumbnail = [self getResolution:[thumbDict valueForKey:@"url"]:TRUE];
            }
            if ([_activityDictionary valueForKey:@"user"])
            {
                
                e2.user = [self getUser:[_activityDictionary valueForKey:@"user"]];
            }
            [_activityArray addObject:e2];
            [e2 release];
            
        }
        e1.activityArray = _activityArray;
        [_activityArray release];
        
    }
    [dataArray addObject:e1];
    [e1 release];
    
	
		if([DataModel upDateExistingDataWithNewData:dataArray:4])
        {
		if( delegate && [delegate respondsToSelector:@selector(hasPullNewData)])
			[delegate performSelector:@selector(hasPullNewData)];
        }
    [dataArray release];

    
}
-(void) getProfileImageURL:(NSString *)_string
{
     NSMutableDictionary *temp = [json2 objectWithString:_string error:nil];
    if ([temp isKindOfClass:[NSDictionary class]])
    {
    if( delegate && [delegate respondsToSelector:@selector(userFeedData:)])
        [delegate performSelector:@selector(userFeedData:) withObject:temp];
    }
    else
    {
        if( delegate && [delegate respondsToSelector:@selector(loginResponse:)])
            [delegate performSelector:@selector(loginResponse:) withObject:[NSNumber numberWithBool:FALSE]];
    }
    NSLog(@"in parser object%@",temp.descriptionInStringsFileFormat);
    
}


@end
