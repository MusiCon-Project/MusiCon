//
//  History.h
//  iLivinMusicUIUX
//
//  Created by jaehoon lee on 3/31/12.
//  Copyright (c) 2012 Kaist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"


@interface History : NSManagedObject
{
    
}
@property (nonatomic, retain) NSString * albumImageURL;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * albumTitle;
@property (nonatomic, retain) NSString * artist;
@property (nonatomic, retain) NSNumber * emotion;

+ (NSMutableArray *)readHistorys;
+ (History *)saveHistory:(NSString *)title albumTitle:(NSString*)albumTitle Artist:(NSString *)artist Emotion:(NSInteger)emotion AlbumImageURL:(NSString *)imgURL;
+ (void)deleteHistory:(History *)history;
+ (void)deleteHistorys;
+ (NSString *)getImagePathURL:(NSString *)title;
+ (NSString *)saveImage:(UIImage *)image title:(NSString *)title;
+ (UIImage *)readImage:(NSString *)ImageURL title:(NSString *)title;
@end
