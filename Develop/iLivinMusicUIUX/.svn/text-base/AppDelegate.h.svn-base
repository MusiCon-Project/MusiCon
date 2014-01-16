//
//  AppDelegate.h
//  iLivinMusicUIUX
//
//  Created by jaehoon lee on 2/11/12.
//  Copyright (c) 2012 Kaist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "record.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, AudioHelperDelegate>
{
    record * _record;
}
@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
