//
//  FolderInfo.m
//  iLivinMusicUIUX
//
//  Created by jaehoon lee on 5/5/12.
//  Copyright (c) 2012 Kaist. All rights reserved.
//

#import "FolderInfo.h"
#import "AlbumInfo.h"
#import "DataModelManager.h"
#import "AppDelegate.h"

@implementation FolderInfo

@dynamic name;
@dynamic album;
+ (NSMutableArray *)readFolders
{
    NSFetchRequest* fetchRequest = [NSFetchRequest new];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"FolderInfo" inManagedObjectContext:[[DataModelManager sharedManager] managedObjectContext]];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSMutableArray *entities = [[[mainDelegate managedObjectContext] executeFetchRequest:fetchRequest error:&error] mutableCopy];
    return entities;
}

+ (FolderInfo *)saveFolder:(NSString *)name 
{
    FolderInfo *folder = (FolderInfo*) [NSEntityDescription insertNewObjectForEntityForName:@"FolderInfo" inManagedObjectContext:[[DataModelManager sharedManager] managedObjectContext]];
    folder.name = name;
    
    return folder;
}

+ (void)deleteFolder:(FolderInfo *)folder
{
    NSManagedObjectContext *context = [[DataModelManager sharedManager] managedObjectContext];
	[context deleteObject:folder];
}

+ (void)deleteFolders
{
    NSMutableArray * folders = [FolderInfo readFolders];
    for (FolderInfo* folder in folders) 
    {
        [[[DataModelManager sharedManager] managedObjectContext] deleteObject:folder];//삭제
    }
}
@end
