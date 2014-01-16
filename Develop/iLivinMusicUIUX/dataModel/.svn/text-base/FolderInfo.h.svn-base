//
//  FolderInfo.h
//  iLivinMusicUIUX
//
//  Created by jaehoon lee on 5/5/12.
//  Copyright (c) 2012 Kaist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface FolderInfo : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *album;
+ (NSMutableArray *)readFolders;
+ (FolderInfo *)saveFolder:(NSString *)name;
+ (void)deleteFolder:(FolderInfo *)folder;
+ (void)deleteFolders;
@end

@interface FolderInfo (CoreDataGeneratedAccessors)

- (void)addAlbumObject:(NSManagedObject *)value;
- (void)removeAlbumObject:(NSManagedObject *)value;
- (void)addAlbum:(NSSet *)values;
- (void)removeAlbum:(NSSet *)values;
@end
