//
//  HTTPManager.m
//  XML
//
//  Created by JHLee on 11. 6. 15..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HTTPManager.h"

@implementation HTTPRequestOperation

- (id)initWithRequest:(NSString *)urlString query:(NSString *)query httpMethod:(NSString *)httpMethod
{
	if((self = [super init]))
	{
		//Need URL Encoding
        if([httpMethod isEqualToString:@"GET"])
            urlString = [NSString stringWithFormat:@"%@/%@", urlString, query];
        
		escapedUrl = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		
		NSURL * url = [NSURL URLWithString:escapedUrl];
		NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0];
		
		//TODO(JHLee)Query URL Encoding
		NSData * postData = [query dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
		
		[request setHTTPMethod:httpMethod];
        
        
        if([httpMethod isEqualToString:@"POST"])
            [request setHTTPBody:postData];
		
		connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
	}
	return self;
}

- (void)main
{
	//iOS4 bug fix
//	if(![NSThread isMainThread])
//	{
//		[self performSelectorOnMainThread:@selector(main) withObject:nil waitUntilDone:NO];
//		return;
//	}
	
	
	[connection scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode]; //Schedule in mainRunLoop (have to work in main Thread runloop)
	[connection start];
	
    if(connection)
    {
        if(receivedData)
            [receivedData release];
        receivedData = [[NSMutableData alloc] init];
    }
	
}

- (void)dealloc
{
	if(receivedData)
        [receivedData release];
	
	[super dealloc];
}

#pragma mark -
#pragma NSURLConnectionDelegate

//Sent when the connection has received sufficient data to construct the URL response for its request.
- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"Recieving");
}

//Sent as a connection loads data incrementally.
- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [receivedData appendData:data];
    NSString * test = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"ReceivedString:%@", test);
}

//Sent when a connection fails to load its request successfully.
- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Failed to access");
}

//Sent when a connection has finished loading successfully.
- (void) connectionDidFinishLoading:(NSURLConnection *)connection
{
	
}

@end



static HTTPManager * httpManager;
@implementation HTTPManager
+ (HTTPManager *)sharedObject
{
    @synchronized(self)
    {
        if (httpManager == nil) {
            httpManager = [[HTTPManager alloc] init];
        }
    }
    
    return httpManager;
}

- (id)init
{
    if((self = [super init]))
    {
		operationQueue = [[NSOperationQueue alloc] init];
		[operationQueue setMaxConcurrentOperationCount:1];
    }
    return self;
}

- (void) dealloc
{
	[operationQueue cancelAllOperations];
	[operationQueue release];
    [super dealloc];
}

- (void) destroySharedObject
{
	[httpManager release];
}

#pragma mark - OperationQueue Method
- (void)removeOperationInQueue
{
	[operationQueue	cancelAllOperations];
}

- (BOOL)OperationExistInQueue
{
	if([operationQueue operationCount] != 0)
		return YES;
	
	return NO;
}

#pragma mark - RequestMethod
- (void)request:(NSString *)urlString query:(NSString *)query httpMethod:(NSString *)httpMethod
{
	HTTPRequestOperation * op = [[HTTPRequestOperation alloc] initWithRequest:urlString query:query httpMethod:httpMethod];
	[operationQueue addOperation:op];
	[op release];
}

@end
