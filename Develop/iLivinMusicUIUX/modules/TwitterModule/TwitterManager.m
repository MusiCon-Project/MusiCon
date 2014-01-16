//
//  TwitterManager.m
//  iLivinMusicUIUX
//
//  Created by jaehoon lee on 7/2/12.
//  Copyright (c) 2012 Kaist. All rights reserved.
//

#import "TwitterManager.h"
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>
@implementation TwitterManager
static TwitterManager * twManager;
+ (TwitterManager *)sharedObject 
{
    @synchronized(self)
    {
        if(twManager == nil)
        {
            twManager = [[TwitterManager alloc] init];
        }
    }
    return twManager;
}

- (void)destroySharedObject
{
    if(twManager)
        [twManager release];
}

- (id)init
{
    if((self = [super init]))
    {
        
		
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

#pragma mark - Twitter API
- (void)getAccounts
{
    ACAccountStore * accountStore = [[ACAccountStore alloc] init];
    ACAccountType * accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [accountStore requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError * error){
        if(granted){
            NSArray * accounts = [accountStore accountsWithAccountType:accountType];
            for(ACAccount * account in accounts)
            {
                NSLog(@"twitter account:%@ %@", account.username, account.description);
            }
        }
    }];
}

- (void)updateTweetWithText:(NSString *)text image:(UIImage *)image
{
    ACAccountStore * accountStore = [[ACAccountStore alloc] init];
    ACAccountType * accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [accountStore requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError * error){
        if(granted){
            NSArray * accounts = [accountStore accountsWithAccountType:accountType];
            ACAccount * account = [accounts objectAtIndex:0];
            
            NSString * urlString = @"https://upload.twitter.com/1/statuses/update_with_media.json";
            
            TWRequest * request = [[TWRequest alloc] initWithURL:[NSURL URLWithString:urlString] parameters:nil requestMethod:TWRequestMethodPOST];
            [request setAccount:account];
            
            //Image & Text & Place
            NSData * imageData = UIImagePNGRepresentation(image);
            NSString * latPayLoad = @"37.7821120598956";
            NSString * longPayLoad = @"-122.400612831116";
            NSString * placeID = @"df51dec6f4ee2b2c";
                
            [request addMultiPartData:imageData withName:@"media[]" type:@"multipart/form-data"];
            [request addMultiPartData:[text dataUsingEncoding:NSUTF8StringEncoding] withName:@"status" type:@"multipart/form-data"];
            [request addMultiPartData:[latPayLoad dataUsingEncoding:NSUTF8StringEncoding] withName:@"lat" type:@"multipart/form-data"];
            [request addMultiPartData:[longPayLoad dataUsingEncoding:NSUTF8StringEncoding] withName:@"long" type:@"multipart/form-data"];
            [request addMultiPartData:[placeID dataUsingEncoding:NSUTF8StringEncoding] withName:@"place_id" type:@"multipart/form-data"];
            
            
            NSLog(@"Absolute:%@", request);
            
            
//            [request performRequestWithHandler:^(NSData * responseData, NSHTTPURLResponse * urlResponse, NSError * error)
//             {
//                 if(urlResponse.statusCode == 200)
//                 {
//                     NSLog(@"Message Uploaded");
//                 }else {
//                     NSLog(@"Twitter Error : %@", [error localizedDescription]);
//                 }
//             }];
        }
    }];}
@end
