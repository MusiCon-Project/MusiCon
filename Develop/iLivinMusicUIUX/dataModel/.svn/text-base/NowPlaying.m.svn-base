//
//  NowPlaying.m
//  iLivinMusicUIUX
//
//  Created by jaehoon lee on 5/9/12.
//  Copyright (c) 2012 Kaist. All rights reserved.
//

#import "NowPlaying.h"
#import "AppDelegate.h"
#import "DataModelManager.h"

@implementation NowPlaying

@dynamic persistentID;
@dynamic pid;
+ (NSMutableArray *)readNowPlayings
{
    NSFetchRequest* fetchRequest = [NSFetchRequest new];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"NowPlaying" inManagedObjectContext:[[DataModelManager sharedManager] managedObjectContext]];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"pid" ascending:YES];
	[fetchRequest setSortDescriptors: [NSArray arrayWithObject:sortDescriptor]];
	[sortDescriptor release];
    
    NSError *error;
    NSMutableArray *entities = [[[mainDelegate managedObjectContext] executeFetchRequest:fetchRequest error:&error] mutableCopy];
    return entities;
}

+ (NowPlaying *)saveNowPlaying:(double)persistentID 
{
    NowPlaying * nowPlaying = (NowPlaying*) [NSEntityDescription insertNewObjectForEntityForName:@"NowPlaying" inManagedObjectContext:[[DataModelManager sharedManager] managedObjectContext]];
    nowPlaying.persistentID = persistentID;
    
    NSArray * nowPlayings = [NowPlaying readNowPlayings];
    nowPlaying.pid = ((NowPlaying *)[nowPlayings lastObject]).pid + 1;
    
    return nowPlaying;
}

+ (void)deleteNowPlaying:(NowPlaying *)nowPlaying
{
    NSManagedObjectContext *context = [[DataModelManager sharedManager] managedObjectContext];
	[context deleteObject:nowPlaying];
}

+ (void)deleteNowPlaying
{
    NSMutableArray * nowPlayings = [NowPlaying readNowPlayings];
    for (NowPlaying* nowPlaying in nowPlayings) 
    {
        [[[DataModelManager sharedManager] managedObjectContext] deleteObject:nowPlaying];//삭제
    }
}
@end
