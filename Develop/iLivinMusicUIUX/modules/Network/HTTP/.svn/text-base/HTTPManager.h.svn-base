//
//  HTTPManager.h
//  XML
//
//  Created by JHLee on 11. 6. 15..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HTTPRequestOperation : NSOperation 
{
	NSMutableData * receivedData;
	NSString * escapedUrl;
	NSURLConnection * connection;
}
- (id)initWithRequest:(NSString *)urlString query:(NSString *)queryInst httpMethod:(NSString *)httpMethodInst;
@end


@interface HTTPManager : NSObject 
{
	NSOperationQueue * operationQueue;
}
+ (HTTPManager *)sharedObject;
- (void) destroySharedObject;

- (void)removeOperationInQueue;
- (BOOL)OperationExistInQueue;

- (void)request:(NSString *)urlString query:(NSString *)query httpMethod:(NSString *)httpMethod;
@end
