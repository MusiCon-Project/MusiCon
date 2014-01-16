//
//  FBHTTPManager.m
//  Modules
//
//  Created by JHLee on 11. 6. 12..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FBHTTPManager.h"

@implementation FBHTTPRequestOperation
@synthesize delegate;
@synthesize searchList;
@synthesize index;
@synthesize requestType;

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"Recieving1");
	[receivedData setLength:0]; 
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	NSLog(@"recevied Data");
	[receivedData appendData:data];
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection
{
	NSLog(@"Delegate:%@", [delegate description]);
	if(requestType == SuggestionListImageRequest)
	{
		[delegate giveImageResource:[UIImage imageWithData:[receivedData copy]] index:index searchList:(NSArray *)searchList requestType:requestType];		
	}
	else
	{
		[delegate giveImageResource:[UIImage imageWithData:receivedData]];	
	}
}
@end

@implementation FBHTTPManager
@synthesize delegate;
@synthesize searchList;
@synthesize index;
@synthesize requestType;
static FBHTTPManager * fbHttpManager;

+ (FBHTTPManager *)sharedObject
{
    @synchronized(self)
    {
        if (fbHttpManager == nil) {
            fbHttpManager = [[FBHTTPManager alloc] init];
        }
    }
    
    return fbHttpManager;
}

- (void) destroySharedObject
{
	[fbHttpManager release];
}

- (void)request:(NSString *)urlString query:(NSString *)query httpMethod:(NSString *)httpMethod
{
	FBHTTPRequestOperation * op = [[FBHTTPRequestOperation alloc] initWithRequest:urlString query:query httpMethod:httpMethod];
	[op setDelegate:delegate];
	[op setSearchList:searchList];
	[op setIndex:index];
	[op setRequestType:requestType];
	
	[operationQueue addOperation:op];
	[op release];
}

@end
