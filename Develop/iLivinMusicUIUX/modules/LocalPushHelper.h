//
//  LocalPushHelper.h
//  iLivinMusicUIUX
//
//  Created by jaehoon lee on 4/4/12.
//  Copyright (c) 2012 Kaist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalPushHelper : NSObject
{
    
}
+ (void)registerLocalPush:(NSDate *)today songURL:(NSString *)songURL;
+ (void)removeLocalPush;
@end
