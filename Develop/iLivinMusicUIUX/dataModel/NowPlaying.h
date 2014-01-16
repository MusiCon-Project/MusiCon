//
//  NowPlaying.h
//  iLivinMusicUIUX
//
//  Created by jaehoon lee on 5/9/12.
//  Copyright (c) 2012 Kaist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface NowPlaying : NSManagedObject

@property (readwrite) double persistentID;
@property (readwrite) int64_t pid;

+ (NSMutableArray *)readNowPlayings;
+ (NowPlaying *)saveNowPlaying:(double)persistentID;
+ (void)deleteNowPlaying:(NowPlaying *)nowPlaying;
+ (void)deleteNowPlaying;
@end
