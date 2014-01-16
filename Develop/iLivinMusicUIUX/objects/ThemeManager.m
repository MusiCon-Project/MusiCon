//
//  ThemeManager.m
//  iLivinMusicUIUX
//
//  Created by jaehoon lee on 6/18/12.
//  Copyright (c) 2012 Kaist. All rights reserved.
//

#import "ThemeManager.h"

@implementation ThemeManager
//static ThemeManager * themeManager;
static ThemeKind selectTheme;
//#pragma mark - init
//+ (HTTPManager *)sharedObject
//{
//    @synchronized(self)
//    {
//        if (httpManager == nil) {
//            httpManager = [[ThemeManager alloc] init];
//        }
//    }
//    
//    return httpManager;
//}
//
//- (id)init
//{
//    if((self = [super init]))
//    {
//		operationQueue = [[NSOperationQueue alloc] init];
//		[operationQueue setMaxConcurrentOperationCount:1];
//    }
//    return self;
//}
//
//- (void) dealloc
//{
//	[operationQueue cancelAllOperations];
//	[operationQueue release];
//    [super dealloc];
//}
//
//- (void) destroySharedObject
//{
//	[httpManager release];
//}

+ (void)setTheme:(ThemeKind)themekind
{
    selectTheme = themekind;
    
    iLMHTTPManager * httpManager = [iLMHTTPManager sharedObject];
    [httpManager request:@"" query:@"" httpMethod:@"GET"];
}

+ (UIImage *)getImageFromTheme:(NSString *)themeName
{
    NSString * imageName = [NSString stringWithFormat:@"%@_%d", themeName, selectTheme];
    return [ThemeManager readImage:imageName];
}

+ (NSString *)saveImage:(UIImage *)image title:(NSString *)title 
{
	NSData *data = UIImagePNGRepresentation(image);
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,  YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"Theme/",title]];
    
	[fileManager createFileAtPath:fullPath contents:data attributes:nil];
    
    return fullPath;
}

+ (UIImage *)readImage:(NSString *)title 
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,  YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"Theme/",title]];
    
    UIImage * img = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@", fullPath]];
    return img;
}
@end
