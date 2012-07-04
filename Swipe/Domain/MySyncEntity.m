//
//  EmailAddressData.m
//  Posterboard
//
//  Created by Apptellect5 on 9/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MySyncEntity.h"
#import "PhoneList.h"
#import "User.h"
#import "EmailList.h"
#import "ContactBook.h"
#import "EnvetFinderDelegate.h"
#import "SocialData.h"



@implementation MySyncEntity
@synthesize AddressBookArray;

static MySyncEntity *_sharedInstance;
+(MySyncEntity *) getLocalAddressBook
{
    @synchronized([MySyncEntity class])
    {
        if(!_sharedInstance)
        {
            [[self alloc] init];
            return _sharedInstance;
        }
    }
    return  _sharedInstance;
}
+(id)alloc
{
    @synchronized([MySyncEntity class])
    {
        NSAssert(_sharedInstance == nil, @"Attempted for 2nd instance of singlton class");
        _sharedInstance = [super alloc];
        return  _sharedInstance;
    }
    return nil;
}
- (id)init
{
    self = [super init];
    if (self) {
        self.AddressBookArray = [self printAddressBook];
    }
    
    return self;
}
- (NSArray*) printAddressBook   
{
    
    if (managedObjectContext == nil) 
    { 
        managedObjectContext = [(EnvetFinderDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]; 
        NSLog(@"After managedObjectContext: %@",  managedObjectContext);
    }  
    NSMutableArray *mutableData = [NSMutableArray new];
    ABAddressBookRef addressBook = ABAddressBookCreate();
    NSArray *arrayOfAllPeople = (__bridge_transfer NSArray *) ABAddressBookCopyArrayOfAllPeople(addressBook);
    NSUInteger peopleCounter = 0; 
    
    for (peopleCounter = 0;peopleCounter < [arrayOfAllPeople count]; peopleCounter++){
        ABRecordRef thisPerson = (__bridge ABRecordRef) [arrayOfAllPeople objectAtIndex:peopleCounter];
        NSString *name = (__bridge_transfer NSString *) ABRecordCopyCompositeName(thisPerson);
        NSLog(@"First Name = %@", name);  
        ContactBook *user = (ContactBook *)[NSEntityDescription insertNewObjectForEntityForName:@"ContactBook" inManagedObjectContext:managedObjectContext];
        user.firstName = name;
        
        user.jobTitle = (NSString *)ABRecordCopyValue(thisPerson, kABPersonJobTitleProperty);
        user.companyName = (NSString *)ABRecordCopyValue(thisPerson, kABPersonOrganizationProperty);
        user.dept = (NSString *)ABRecordCopyValue(thisPerson, kABPersonDepartmentProperty);
        user.dob = (NSDate *)ABRecordCopyValue(thisPerson, kABPersonBirthdayProperty);
        if( ABPersonHasImageData( thisPerson ) ) {
            //record has an image
            user.imageData = (NSData *) ABPersonCopyImageData( thisPerson ) ;
        } 
        
        //  user.imageData =  (NSData*)ABPersonCopyImageDataWithFormat([thisPerson objectAtIndex:0], kABPersonImageFormatThumbnail);
        
        NSMutableArray *phoneArray = [[NSMutableArray alloc] init];
        ABMultiValueRef *phones = ABRecordCopyValue(thisPerson, kABPersonPhoneProperty);
        
        
        for(CFIndex j = 0; j < ABMultiValueGetCount(phones); j++)
        {
            PhoneList *phone = (PhoneList *)[NSEntityDescription insertNewObjectForEntityForName:@"PhoneList" inManagedObjectContext:managedObjectContext];
            
            CFStringRef phoneNumberRef = ABMultiValueCopyValueAtIndex(phones, j);
            CFStringRef locLabel = ABMultiValueCopyLabelAtIndex(phones, j);
            phone.phoneNo= (NSString *)phoneNumberRef;
            phone.phoneTitle = (NSString*) ABAddressBookCopyLocalizedLabel(locLabel);
            
            CFRelease(phoneNumberRef);
            CFRelease(locLabel);
            // NSLog(@"  - %@ (%@)", phoneNumber, phoneLabel);
            [phoneArray addObject:phone];
            // [phoneNumber release];
        }
        
        ABMultiValueRef emails = ABRecordCopyValue(thisPerson, kABPersonEmailProperty);
        
        NSMutableArray *emailArray = [[NSMutableArray alloc] init];
        for (NSUInteger emailCounter = 0; emailCounter < ABMultiValueGetCount(emails); emailCounter++)
        {
            NSString *email = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(emails, emailCounter);
            CFStringRef locLabel = ABMultiValueCopyLabelAtIndex(emails, emailCounter);
            EmailList *emailObject = (EmailList *)[NSEntityDescription insertNewObjectForEntityForName:@"EmailList" inManagedObjectContext:managedObjectContext];
            emailObject.email = email;
            emailObject.emailTitle = (NSString*) ABAddressBookCopyLocalizedLabel(locLabel);
            [emailArray addObject:emailObject];
        }
        ABMultiValueRef multi = ABRecordCopyValue(thisPerson, kABPersonSocialProfileProperty);
        if(ABMultiValueGetCount(multi) > 0)
        {
            SocialData *social = (SocialData *)[NSEntityDescription insertNewObjectForEntityForName:@"SocialData" inManagedObjectContext:managedObjectContext];   
            for (CFIndex i = 0; i < ABMultiValueGetCount(multi); i++) 
            {
                
                NSDictionary* personalDetails = [NSDictionary dictionaryWithDictionary:(NSDictionary*)ABMultiValueCopyValueAtIndex(multi, i)];
                NSLog(@"%@",personalDetails);
                
                if([[personalDetails valueForKey:@"service"] isEqualToString:@"linkedin"])
                {
                    social.linkedIn = [personalDetails valueForKey:@"username"];
                    social.linkedInURL = [personalDetails valueForKey:@"url"];   
                }
                if([[personalDetails valueForKey:@"service"] isEqualToString:@"twitter"])
                {
                    social.twitter = [personalDetails valueForKey:@"username"];
                    social.twitterURL = [personalDetails valueForKey:@"url"];   
                }
                if([[personalDetails valueForKey:@"service"] isEqualToString:@"facebook"])
                {
                    social.facebook = [personalDetails valueForKey:@"username"];
                    social.facebookURL = [personalDetails valueForKey:@"url"];   
                }
                if([[personalDetails valueForKey:@"service"] isEqualToString:@"flickr"])
                {
                    social.flicker = [personalDetails valueForKey:@"username"];
                    social.flickerURL = [personalDetails valueForKey:@"url"];   
                }
                if([[personalDetails valueForKey:@"service"] isEqualToString:@"myspace"])
                {
                    social.mySpace = [personalDetails valueForKey:@"username"];
                    social.mySpaceURL = [personalDetails valueForKey:@"url"];   
                }
            }
            user.userSocial = social;
        }
        if([emailArray count] > 0)  
            [user addUserEmails:[NSSet setWithArray:emailArray]];
        if([phoneArray count] > 0)  
            [user addPhones:[NSSet setWithArray:phoneArray]];
        
        
        [mutableData addObject:user];
        [emailArray release];
        [phoneArray release];
        NSLog(@"User:%@",user);
        
    } 
    CFRelease(addressBook);
    return [NSArray arrayWithArray:mutableData];
}


@end
