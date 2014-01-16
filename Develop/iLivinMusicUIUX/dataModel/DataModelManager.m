//
//  DataModelManager.m
//  iLivinMusicUIUX
//
//  Created by jaehoon lee on 4/4/12.
//  Copyright (c) 2012 Kaist. All rights reserved.
//

#import "DataModelManager.h"
#import "AppDelegate.h"
static DataModelManager *singletonInstance = nil;
@implementation DataModelManager
+ (DataModelManager *)sharedManager {
	@synchronized (self) {
		if (singletonInstance == nil) {
			singletonInstance = [[DataModelManager alloc] init];
		}
		return singletonInstance;
	}
}

- (void)destroySingleton{
	[singletonInstance release];
	singletonInstance=nil;
}

- (id)init
{
    if(self = [super init])
    {
        _managedObjectModel = [mainDelegate managedObjectModel];
        _managedObjectContext = [mainDelegate managedObjectContext];
    }
    return self;
}

#pragma mark -
#pragma mark Core Data stack
- (NSManagedObjectContext *) managedObjectContext 
{
    return _managedObjectContext;
}

- (void)saveToPersistentStore
{
	[mainDelegate saveContext];
}

@end
