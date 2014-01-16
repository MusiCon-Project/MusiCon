//
//  ImageEditManager.h
//  Modules
//
//  Created by JHLee on 11. 6. 20..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PaintingViewModified.h"
#import "CuttingView.h"

#define DEGREES_TO_RADIANS(__ANGLE__) ((__ANGLE__) / 180.0 * M_PI)

@interface ImageEditManager : NSObject {
    uint32_t * pixels;
    CGContextRef context;
    
    int width;
    int height;
	UIImage * sourceImage;
	UIImageOrientation imageOrientation;
    
    //Draw, Rotation, Cut
    PaintingViewModified * paintView;
    
    CGPoint touch1;
    CGPoint touch2;
    
    CGFloat initialDistance;
    CGFloat finalDistance;
    
    CGFloat initialWidth;
    CGFloat initialHeight;
}

+ (ImageEditManager *)sharedObject;
- (void) destorySingleTon;

- (BOOL) isImageSet;
- (id) setImage:(UIImage *)anImage;
- (id) setImageBuffer:(uint32_t *)buffer width:(CGFloat)bufWidth height:(CGFloat)bufHeight;
- (UIImage*) getImage;
- (void) saveImage;

- (id) shineFilter;
- (id) sketchFilter;
- (id) blackWhiteFilter;
- (id) blurFilter;

- (void) startPainting:(UIView *)MainView Rect:(CGRect)rect;
- (id) combineWithImage;
- (void)combineWithOtherImage:(UIImage *)image;
- (void)erasePaintView;

- (void) rotate:(UIImageView *)anImageView degree:(double)degree;
- (void) rotationEnable:(UIImageView *)outputImage;
- (void) rotationStart:(NSSet*)touches onMainView:(UIView *)view;
- (void) rotating:(NSSet *)touches onMainView:(UIView *)view withImage:(UIImageView *)outputImage;
- (void) rotationEnd:(NSSet *)touches onMainView:(UIView *)view withImage:(UIImageView *)outputImage;

- (void) cutStart:(NSSet*)touches onMainView:(UIView *)view WithImage:(CuttingView *)cutImage;
- (void) cutting:(NSSet *)touches onMainView:(UIView *)view withImage:(UIView *)outputImage;
- (UIImage *)cutAndSaveImage:(CuttingView *)cutView;



@end
