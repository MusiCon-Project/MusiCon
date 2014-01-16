//
//  AlbumInfo.h
//  iLivinMusicUIUX
//
//  Created by jaehoon lee on 5/5/12.
//  Copyright (c) 2012 Kaist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class FolderInfo;

@interface AlbumInfo : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * jaketImgURL;
@property (nonatomic, retain) FolderInfo *folder;
+ (AlbumInfo *)saveAlbum:(NSString *)name imageURL:(NSString *)imgURL inFolder:(FolderInfo *)folder;
@end
