//
//  ThemeManager.h
//  iLivinMusicUIUX
//
//  Created by jaehoon lee on 6/18/12.
//  Copyright (c) 2012 Kaist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iLMHTTPManager.h"
typedef enum
{
    BasicTheme,
}ThemeKind;

#define recordImage @"recordImage_%d"


@interface ThemeManager : NSObject
{
    iLMHTTPManager * httpManager;
}
+ (void)setTheme:(ThemeKind)themekind;
+ (UIImage *)getImageFromTheme:(NSString *)themeName;
@end
