//
//  History.m
//  iLivinMusicUIUX
//
//  Created by jaehoon lee on 3/31/12.
//  Copyright (c) 2012 Kaist. All rights reserved.
//

#import "History.h"
#import "DataModelManager.h"

@implementation History
@dynamic albumImageURL;
@dynamic title;
@dynamic albumTitle;
@dynamic artist;
@dynamic emotion;
+ (NSMutableArray *)readHistorys
{
    NSFetchRequest* fetchRequest = [NSFetchRequest new];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"History" inManagedObjectContext:[[DataModelManager sharedManager] managedObjectContext]];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSMutableArray *entities = [[[mainDelegate managedObjectContext] executeFetchRequest:fetchRequest error:&error] mutableCopy];
    return entities;
}

+ (History *)saveHistory:(NSString *)title albumTitle:(NSString*)albumTitle Artist:(NSString *)artist Emotion:(NSInteger)emotion AlbumImageURL:(NSString *)imgURL
{
    History *history = (History*) [NSEntityDescription insertNewObjectForEntityForName:@"History" inManagedObjectContext:[[DataModelManager sharedManager] managedObjectContext]];
    
    history.title = title;
    history.albumTitle = albumTitle;
    history.artist = artist;
    history.emotion = [NSNumber numberWithInteger:emotion];
    history.albumImageURL = imgURL;
    
    return history;
}

+ (void)deleteHistory:(History *)history
{
    NSManagedObjectContext *context = [[DataModelManager sharedManager] managedObjectContext];
	[context deleteObject:history];
}

+ (void)deleteHistorys
{
    NSMutableArray * historys = [History readHistorys];
    for (History* history in historys) 
    {
        [[[DataModelManager sharedManager] managedObjectContext] deleteObject:history];//삭제
    }
}

#pragma mark - save Image
+ (NSString *)saveImage:(UIImage *)image title:(NSString *)title 
{
	NSData *data = UIImagePNGRepresentation(image);
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,  YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:title]];

	[fileManager createFileAtPath:fullPath contents:data attributes:nil];
    
    return fullPath;
}

+ (UIImage *)readImage:(NSString *)ImageURL title:(NSString *)title 
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,  YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:title]];

    UIImage * img = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@", fullPath]];
    NSLog(@"fullPathRead : %@",fullPath);
    
    return img;
}
@end
