//
//  iLMHTTPManager.m
//  iLivinMusicUIUX
//
//  Created by jaehoon lee on 6/19/12.
//  Copyright (c) 2012 Kaist. All rights reserved.
//

#import "iLMHTTPManager.h"
@implementation iLMHTTPRequestOperation
@synthesize delegate;
- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"Recieving11");
    [receivedData setLength:0];
}

//Sent as a connection loads data incrementally.
- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [receivedData appendData:data];
}

//Sent when a connection fails to load its request successfully.
- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Failed to access");
}

//Sent when a connection has finished loading successfully.
- (void) connectionDidFinishLoading:(NSURLConnection *)connection
{
    UIImage * image = [[UIImage alloc] initWithData:receivedData];
    [delegate getImage:image];
}
@end

@implementation iLMHTTPManager
static iLMHTTPManager * httpManager;
@synthesize delegate;
+ (iLMHTTPManager *)sharedObject
{
    if(httpManager == nil)
    {
        httpManager = [[iLMHTTPManager alloc] init];
    }
    return httpManager;
}

- (void)request:(NSString *)urlString query:(NSString *)query httpMethod:(NSString *)httpMethod
{
    iLMHTTPRequestOperation * op = [[iLMHTTPRequestOperation alloc] initWithRequest:urlString query:query httpMethod:httpMethod];
	[op setDelegate:delegate];
	[operationQueue addOperation:op];
	[op release];
}
@end
