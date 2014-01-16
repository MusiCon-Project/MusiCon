//
//  DataModelManager.h
//  iLivinMusicUIUX
//
//  Created by jaehoon lee on 4/4/12.
//  Copyright (c) 2012 Kaist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataModelManager : NSObject
{
    NSManagedObjectModel *_managedObjectModel;                   /// xcdatamodeld로부터 가지고 오는 model
    NSManagedObjectContext *_managedObjectContext;               /// IBView, IBMessage managedObject들이 생기고 불리는 context
}
+ (DataModelManager *)sharedManager;
- (void)destroySingleton;
- (NSManagedObjectContext *) managedObjectContext;
- (void)saveToPersistentStore;
@end
