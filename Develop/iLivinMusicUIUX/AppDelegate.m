//
//  AppDelegate.m
//  iLivinMusicUIUX
//
//  Created by jaehoon lee on 2/11/12.
//  Copyright (c) 2012 Kaist. All rights reserved.
//

#import "AppDelegate.h"
#import "iLivinMusicMainViewController.h"
#import "FBManager.h"

@implementation AppDelegate
@synthesize window = _window;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    iLivinMusicMainViewController * mainViewCont = [[iLivinMusicMainViewController alloc] init];  

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window addSubview:mainViewCont.view];
    [self.window makeKeyAndVisible];
    _record = mainViewCont.record;
    
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    [[FBManager sharedObject].facebook extendAccessTokenIfNeeded];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    NSLog(@"%@", url.absoluteString);
    return [[FBManager sharedObject].facebook handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    NSLog(@"%@", url.absoluteString);
    return [[FBManager sharedObject].facebook handleOpenURL:url];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

//- (void)applicationDidEnterBackground:(UIApplication *)application
//{
//    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
//    /*
//     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
//     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//     */
//    if ([[UIDevice currentDevice] respondsToSelector:@selector(isMultitaskingSupported)]) { //Check if our iOS version supports multitasking I.E iOS 4
//		if ([[UIDevice currentDevice] isMultitaskingSupported]) { //Check if device supports mulitasking
//			UIApplication *application = [UIApplication sharedApplication]; //Get the shared application instance
//            
//			__block UIBackgroundTaskIdentifier background_task; //Create a task object
//            
//			background_task = [application beginBackgroundTaskWithExpirationHandler: ^ {
//				[application endBackgroundTask: background_task]; //Tell the system that we are done with the tasks
//				background_task = UIBackgroundTaskInvalid; //Set the task to be invalid
//                
//				//System will be shutting down the app at any point in time now
//			}];
//            
//			//Background tasks require you to use asyncrous tasks
//            
//			dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//				//Perform your tasks that your application requires
//                NSLog(@"%d", _record.curRecordType);
//                if((_record.curRecordType == TimerType) || (_record.curRecordType == AlarmType))
//                {
//                    NSLog(@"\n\nRunning in the background!\n\n");
//                    while (!(_record.limitTime == 0)) 
//                    {
//                    }
//                    sleep(2);
//                }
//				[application endBackgroundTask: background_task]; //End the task so the system knows that you are done with what you need to perform
//				background_task = UIBackgroundTaskInvalid; //Invalidate the background_task
//			});
//		}
//	}
//}
//
//- (void)applicationWillEnterForeground:(UIApplication *)application
//{
//    NSError * setCategoryError;
//    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&setCategoryError];
//    if (setCategoryError) NSLog(@"error AVAudioSession setCategory");
//    /*
//     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
//     */
//    
//    if ([[UIDevice currentDevice] respondsToSelector:@selector(isMultitaskingSupported)]) { //Check if our iOS version supports multitasking I.E iOS 4
//		if ([[UIDevice currentDevice] isMultitaskingSupported]) { //Check if device supports mulitasking
//			UIApplication *application = [UIApplication sharedApplication]; //Get the shared application instance
//            
//			__block UIBackgroundTaskIdentifier background_task; //Create a task object
//            
//			background_task = [application beginBackgroundTaskWithExpirationHandler: ^ {
//				[application endBackgroundTask: background_task]; //Tell the system that we are done with the tasks
//				background_task = UIBackgroundTaskInvalid; //Set the task to be invalid
//                
//				//System will be shutting down the app at any point in time now
//			}];
//            
//			//Background tasks require you to use asyncrous tasks
//            [application endBackgroundTask: background_task]; //End the task so the system knows that you are done with what you need to perform
//            background_task = UIBackgroundTaskInvalid; //Invalidate the background_task
//		}
//	}
//
//}


- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
}

#pragma mark - Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil)
    {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil)
    {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"iLivinMusicUIUX" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil)
    {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"iLivinMusicUIUX.sqlite"];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
