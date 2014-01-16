//
//  UIImage+Transform.m
//  Messenger
//
//  Created by  재호 정 on 10. 04. 23.
//  Copyright 2010 인포뱅크. All rights reserved.
//

#import "UIImage+Transform.h"
#import <QuartzCore/QuartzCore.h>

static inline double radians (double degrees) { return degrees * M_PI/180;}

static void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth, float ovalHeight)
{
    float fw, fh;
    if (ovalWidth == 0 || ovalHeight == 0) {
        CGContextAddRect(context, rect);
        return;
    }
    CGContextSaveGState(context);
    CGContextTranslateCTM (context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM (context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth (rect) / ovalWidth;
    fh = CGRectGetHeight (rect) / ovalHeight;
    CGContextMoveToPoint(context, fw, fh/2);
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1);
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1);
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1);
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}

@implementation UIImage (Transform)

- (float)maxLengthToReduceTo{
	
	float imageWidth=self.size.width;
	float imageHeight=self.size.height;
	
	float theLength=0;
	
	if(imageWidth>imageHeight){

		theLength=800.0/(imageWidth+imageHeight)*imageWidth;
		
	}
	
	else{

		theLength=800.0/(imageWidth+imageHeight)*imageHeight;		
		
	}
	
	return theLength;
	
}

- (UIImage *)makeRoundCornerImageWithWidth: (int) cornerWidth height: (int) cornerHeight
{
	UIImage * newImage = nil;
	
	if( nil != self)
	{
		NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
		int w = self.size.width;
		int h = self.size.height;
		
		CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
		CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
		
		CGContextBeginPath(context);
		CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
		addRoundedRectToPath(context, rect, cornerWidth, cornerHeight);
		CGContextClosePath(context);
		CGContextClip(context);
		
		CGContextDrawImage(context, CGRectMake(0, 0, w, h), self.CGImage);
		
		CGImageRef imageMasked = CGBitmapContextCreateImage(context);
		CGContextRelease(context);
		CGColorSpaceRelease(colorSpace);
		
		newImage = [[UIImage imageWithCGImage:imageMasked] retain];
		CGImageRelease(imageMasked);
		
		[pool release];
	}
	
    return newImage;
}


-(UIImage *)scaleImageNewMaxSize:(int)length{
	
	CGImageRef imageRef = [self CGImage];
	CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
	CGColorSpaceRef colorSpaceInfo = CGImageGetColorSpace(imageRef);
//	CGColorSpaceRef colorSpaceInfo=CGColorSpaceCreateDeviceRGB();

	CGFloat targetWidth = CGImageGetWidth(imageRef);
	CGFloat targetHeight = CGImageGetHeight(imageRef);
	
	if (targetWidth > length || targetHeight > length) {
		CGFloat ratio = targetWidth/targetHeight;
		if (ratio > 1) {
			targetWidth = length;
			targetHeight = targetWidth / ratio;
		}
		else {
			targetHeight = length;
			targetWidth = targetHeight * ratio;
		}
	}
	
	if (bitmapInfo == kCGImageAlphaNone) {
		bitmapInfo = kCGImageAlphaNoneSkipLast;
	}
	
	CGContextRef bitmap;
	
	if (self.imageOrientation == UIImageOrientationUp || self.imageOrientation == UIImageOrientationDown) {
		bitmap = CGBitmapContextCreate(NULL, targetWidth, targetHeight, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
		
	} else {
		bitmap = CGBitmapContextCreate(NULL, targetHeight, targetWidth, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
		
	}

	if (self.imageOrientation == UIImageOrientationLeft) {
		CGContextRotateCTM (bitmap, M_PI / 2.0);
		CGContextTranslateCTM (bitmap, 0, -targetHeight);
		
	} else if (self.imageOrientation == UIImageOrientationRight) {
		CGContextRotateCTM (bitmap, -1*M_PI / 2.0);
		CGContextTranslateCTM (bitmap, -targetWidth, 0);
		
	} else if (self.imageOrientation == UIImageOrientationUp) {
		// NOTHING
	} else if (self.imageOrientation == UIImageOrientationDown) {
		CGContextTranslateCTM (bitmap, targetWidth, targetHeight);
		CGContextRotateCTM (bitmap, -2*M_PI / 2.0);
	}
	
	CGContextDrawImage(bitmap, CGRectMake(0, 0, targetWidth, targetHeight), imageRef);
	CGImageRef ref = CGBitmapContextCreateImage(bitmap);
	UIImage* newImage = [UIImage imageWithCGImage:ref];
	CGContextRelease(bitmap);
	CGImageRelease(ref);
//	CGColorSpaceRelease(colorSpaceInfo);
	
	return newImage; 
}

+ (UIImage*)resizedImage:(UIImage*)inImage  inRect:(CGRect)thumbRect 
{
	// Creates a bitmap-based graphics context and makes it the current context.
	UIGraphicsBeginImageContext(thumbRect.size);
	[inImage drawInRect:thumbRect];
	
	return UIGraphicsGetImageFromCurrentImageContext();
}

+ (UIImage*)resizedImage2:(UIImage*)inImage inSize:(CGSize)size
{
    float resizeWidth = size.width;
    float resizeHeight = size.height;

    UIGraphicsBeginImageContext(CGSizeMake(resizeWidth, resizeHeight));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0.0, resizeHeight);
    CGContextScaleCTM(context, 1.0, -1.0);

    CGContextDrawImage(context, CGRectMake(0.0, 0.0, resizeWidth, resizeHeight), [inImage CGImage]);
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

- (UIImage *)fixRotatedImageToOrienationUp
{
	UIImage * newImage;
	if(self.imageOrientation != UIImageOrientationUp && self.CGImage != nil)
	{
		newImage = [UIImage imageWithCGImage:self.CGImage scale:1.0 orientation:UIImageOrientationUp];
		NSLog(@"newImageRotate");
	}
	else
	{
		newImage = self;
		NSLog(@"newImageNotRotate");
	}	
	return newImage;
}

- (UIImage *)resizeImageToFitRect:(CGRect)rect
{
	UIImage * resizedImage = self;
	
	int originImageWidth = self.size.width;
	int originImageHeight = self.size.height;
	double widthRatio = originImageWidth / rect.size.width;
	double heightRatio = originImageHeight / rect.size.height;
	int changedImageWidth, changedImageHeight;
	changedImageWidth = originImageWidth;
	changedImageHeight = originImageHeight;
	
	NSLog(@"%d %d %f %f", originImageWidth, originImageHeight, widthRatio, heightRatio);
	if(widthRatio < 1.0 && heightRatio < 1.0)
	{
		if(widthRatio > heightRatio)
		{
			changedImageWidth = originImageWidth / widthRatio;
			changedImageHeight = originImageHeight / widthRatio;
			resizedImage = [UIImage resizedImage:self inRect:CGRectMake(0, 0, changedImageWidth, changedImageHeight)];
		}
		else
		{ 
			changedImageWidth = originImageWidth / heightRatio;
			changedImageHeight = originImageHeight / heightRatio;
			resizedImage = [UIImage resizedImage:self inRect:CGRectMake(0, 0, changedImageWidth, changedImageHeight)];
		}
		
	}else if(widthRatio > 1.0 || heightRatio > 1.0)
	{
		if(widthRatio > heightRatio)
		{
			changedImageWidth = originImageWidth / widthRatio;
			changedImageHeight = originImageHeight / widthRatio;
			resizedImage = [UIImage resizedImage:self inRect:CGRectMake(0, 0, changedImageWidth, changedImageHeight)];
		}
		else
		{ 
			changedImageWidth = originImageWidth / heightRatio;
			changedImageHeight = originImageHeight / heightRatio;
			resizedImage = [UIImage resizedImage:self inRect:CGRectMake(0, 0, changedImageWidth, changedImageHeight)];
		}
	}
	NSLog(@"%d %d", changedImageWidth, changedImageHeight);
	
	return resizedImage;
}

- (UIImage*)imageByCropping:(UIImage *)imageToCrop toRect:(CGRect)rect
{
	UIGraphicsBeginImageContext(rect.size);
	CGContextRef currentContext = UIGraphicsGetCurrentContext();
	
	CGContextTranslateCTM(currentContext, 0.0, rect.size.height);
	CGContextScaleCTM(currentContext, 1.0, -1.0);	
	
	CGRect clippedRect = CGRectMake(0, 0, rect.size.width, rect.size.height);
	CGContextClipToRect( currentContext, clippedRect);
	CGRect drawRect = CGRectMake(rect.origin.x * -1,rect.origin.y * -1,imageToCrop.size.width,imageToCrop.size.height);
	CGContextDrawImage(currentContext, drawRect, imageToCrop.CGImage);
	CGContextScaleCTM(currentContext, 1.0, -1.0);
	
	UIImage *cropped = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return cropped;
}


- (UIImage*)imageByCroppingToRect:(CGRect)rect
{
	UIGraphicsBeginImageContext(rect.size);
	CGContextRef currentContext = UIGraphicsGetCurrentContext();
	
	CGContextTranslateCTM(currentContext, 0.0, rect.size.height);
	CGContextScaleCTM(currentContext, 1.0, -1.0);	
	
	CGRect clippedRect = CGRectMake(0, 0, rect.size.width, rect.size.height);
	CGContextClipToRect( currentContext, clippedRect);
	CGRect drawRect = CGRectMake(rect.origin.x * -1,rect.origin.y * -1,self.size.width,self.size.height);
	CGContextDrawImage(currentContext, drawRect, self.CGImage);
	CGContextScaleCTM(currentContext, 1.0, -1.0);
	
	UIImage *cropped = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return cropped;
}

// size 를 받아서 해당 size 비율의 가장 큰 이미지를 원본 이미지에서 잘라낸 후 resize한다.
- (UIImage *)imageByCroppingToSize:(CGSize)size
{
	int originImageWidth = self.size.width;
	int originImageHeight = self.size.height;
	double widthRatio = originImageWidth / size.width;
	double heightRatio = originImageHeight / size.height;
	int changedImageWidth, changedImageHeight;
	changedImageWidth = originImageWidth;
	changedImageHeight = originImageHeight;

	if(widthRatio > heightRatio)
	{
		changedImageWidth = size.width * heightRatio;
		changedImageHeight = size.height * heightRatio;
	}
	else
	{ 
		changedImageWidth = size.width * widthRatio;
		changedImageHeight = size.height * widthRatio;
	}

	NSLog(@"original (%f, %f), size (%f, %f) => crop rect (%f, %f, %d, %d)",self.size.width,self.size.height,size.width,size.height , self.size.width/2 - changedImageWidth/2, self.size.height/2 - changedImageHeight/2, changedImageWidth, changedImageHeight);
	
	return [self imageByCroppingToRect:CGRectMake(self.size.width/2 - changedImageWidth/2, self.size.height/2 - changedImageHeight/2, changedImageWidth, changedImageHeight)];
}

+ (UIImage *)imageWithContentsOfIndependentFile:(NSString *)path
{
	return [[[UIImage alloc] initWithContentsOfIndependentFile:path] autorelease];
}

- (id)initWithContentsOfIndependentFile:(NSString *)path
{
	NSString *newPath		= path;
	NSString *fileName		= [path stringByDeletingPathExtension];
	NSString *fileExtension = [path pathExtension];
	
	if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [UIImage instancesRespondToSelector:@selector(scale)])
	{
		if ([[[UIDevice currentDevice] systemVersion] intValue] >= 4 && [[UIScreen mainScreen] scale] == 2.0)
		{
			NSString *hd = [fileName stringByAppendingString:@"@2x"];
			newPath = [[NSBundle mainBundle] pathForResource:hd ofType:fileExtension];
		}
	}
	
	if (!newPath)
		newPath = [[NSBundle mainBundle] pathForResource:fileName ofType:fileExtension];
	
	if (!newPath)
		newPath = [[NSBundle mainBundle] pathForResource:path ofType:nil];
	
	if (newPath != nil)
		return [self initWithContentsOfFile:newPath];
	
	return nil;	
/*	if ([[[UIDevice currentDevice] systemVersion] intValue] >= 4 && [[UIScreen mainScreen] scale] == 2)
	{
		NSString *path2x = [[path stringByDeletingLastPathComponent] 
							stringByAppendingPathComponent:[NSString stringWithFormat:@"%@@2x.%@", [[path lastPathComponent] stringByDeletingPathExtension], [path pathExtension]]];
		
		if ([[NSFileManager defaultManager] fileExistsAtPath:path2x])
			return [self initWithCGImage:[[UIImage imageWithData:[NSData dataWithContentsOfFile:path2x]] CGImage] scale:[[UIScreen mainScreen] scale] orientation:UIImageOrientationUp];
	}
	
	return [self initWithData:[NSData dataWithContentsOfFile:path]];*/
}

- (UIImage *)currentScreenCapture:(CGRect)frame view:(UIView *)view
{
	CGSize imageSize = frame.size;
	
	if (UIGraphicsBeginImageContextWithOptions != NULL)
		UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
	else
		UIGraphicsBeginImageContext(imageSize);
	
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	
	CGContextSaveGState(ctx);
	
	CGContextTranslateCTM(ctx, view.center.x, view.center.y);
	CGContextConcatCTM(ctx, view.transform);
	CGContextTranslateCTM(ctx, -view.frame.size.width * view.layer.anchorPoint.x, -view.frame.size.height * view.layer.anchorPoint.y);
	
	[view.layer renderInContext:ctx];
	
	CGContextRestoreGState(ctx);
	
	UIImage *captureImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return captureImage;
}


@end
