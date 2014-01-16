//
//  TwitterManager.h
//  iLivinMusicUIUX
//
//  Created by jaehoon lee on 7/2/12.
//  Copyright (c) 2012 Kaist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TwitterManager : NSObject
{
    
}
+ (TwitterManager *)sharedObject;
- (void)getAccounts;
- (void)updateTweetWithText:(NSString *)text image:(UIImage *)image;
@end
