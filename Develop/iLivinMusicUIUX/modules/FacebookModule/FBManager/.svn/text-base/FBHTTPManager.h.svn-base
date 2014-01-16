//
//  FBHTTPManager.h
//  Modules
//
//  Created by JHLee on 11. 6. 12..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTPManager.h"
typedef enum
{
	ProfileInterestRequest,
	SuggestionListImageRequest,
}ImageRequestType;

@protocol FBHTTPManagerDelegate <NSObject>
@optional
- (void)giveImageResource:(UIImage *)image index:(NSInteger)index searchList:(NSArray *)searchList requestType:(NSInteger)requestType;
- (void)giveImageResource:(UIImage *)image; 
@end


@interface FBHTTPRequestOperation : HTTPRequestOperation {
	id<FBHTTPManagerDelegate>	delegate;	
	NSArray * searchList;
	NSInteger					index;
	NSInteger					requestType;
}
@property(nonatomic, retain)	id<FBHTTPManagerDelegate> delegate;
@property(nonatomic, retain)	NSArray					* searchList;
@property(readwrite)			NSInteger				  index;
@property(readwrite)			NSInteger				  requestType;
@end


@interface FBHTTPManager : HTTPManager {
	id<FBHTTPManagerDelegate>	delegate;
	NSArray * searchList;
	NSInteger					index;
	NSInteger					requestType;
}
@property(nonatomic, retain)	id<FBHTTPManagerDelegate> delegate;
@property(nonatomic, retain)	NSArray					* searchList;
@property(readwrite)			NSInteger				  index;
@property(readwrite)			NSInteger				  requestType;
+ (FBHTTPManager *)sharedObject;
- (void) destroySharedObject;
@end
