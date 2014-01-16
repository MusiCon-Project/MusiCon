//
//  AlbumInfo.m
//  iLivinMusicUIUX
//
//  Created by jaehoon lee on 5/5/12.
//  Copyright (c) 2012 Kaist. All rights reserved.
//

#import "AlbumInfo.h"
#import "FolderInfo.h"
#import "DataModelManager.h"

@implementation AlbumInfo

@dynamic name;
@dynamic jaketImgURL;
@dynamic folder;
+ (AlbumInfo *)saveAlbum:(NSString *)name imageURL:(NSString *)imgURL inFolder:(FolderInfo *)folder
{
    AlbumInfo *album = (AlbumInfo*) [NSEntityDescription insertNewObjectForEntityForName:@"AlbumInfo" inManagedObjectContext:[[DataModelManager sharedManager] managedObjectContext]];
    album.name = name;
    album.jaketImgURL = imgURL;
    album.folder = folder;
    
    [folder addAlbumObject:album];
    return album;
}
@end
