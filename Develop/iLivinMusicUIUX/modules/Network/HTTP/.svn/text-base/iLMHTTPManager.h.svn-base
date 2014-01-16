//
//  iLMHTTPManager.h
//  iLivinMusicUIUX
//
//  Created by jaehoon lee on 6/19/12.
//  Copyright (c) 2012 Kaist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTPManager.h"
@protocol iLMHTTPManagerDelegate 
- (void)getImage:(UIImage *)image;
@end

@interface iLMHTTPRequestOperation : HTTPRequestOperation 
{
    id<iLMHTTPManagerDelegate> delegate;
}
@property(nonatomic, retain) id<iLMHTTPManagerDelegate> delegate;
@end

@interface iLMHTTPManager : HTTPManager
{
    id<iLMHTTPManagerDelegate> delegate;
}
+ (iLMHTTPManager *)sharedObject;
@property(nonatomic, retain) id<iLMHTTPManagerDelegate> delegate;
@end
