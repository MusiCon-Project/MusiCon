//
//  UIImage+Transform.h
//  Messenger
//
//  Created by  재호 정 on 10. 04. 23.
//  Copyright 2010 인포뱅크. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MAX_PICTURE_SIZE    1024
#define PICTURE_COMPRESSION_QUALITY	0.7

static void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth, float ovalHeight);

@interface UIImage (Transform) 

+ (UIImage *)imageWithContentsOfIndependentFile:(NSString *)path;
+ (UIImage*)resizedImage:(UIImage*)inImage inRect:(CGRect)thumbRect;
+ (UIImage*)resizedImage2:(UIImage*)inImage inSize:(CGSize)size;

- (float)maxLengthToReduceTo;
- (UIImage *)makeRoundCornerImageWithWidth: (int) cornerWidth height: (int) cornerHeight;
- (UIImage *)scaleImageNewMaxSize:(int)length;
- (UIImage*)resizeImageToFitRect:(CGRect)rect;
- (UIImage *)fixRotatedImageToOrienationUp;
- (UIImage *)imageByCroppingToSize:(CGSize)size;
- (id)initWithContentsOfIndependentFile:(NSString *)path;

@end
