//
//  ImageEditManager.m
//  Modules
//
//  Created by JHLee on 11. 6. 20..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ImageEditManager.h"

typedef enum
{
    ALPHA,
    BLUE,
    GREEN,
    RED
}PIXEL;

@implementation ImageEditManager
static ImageEditManager * ImageEditManagerInst;

+ (ImageEditManager *)sharedObject
{
    @synchronized(self)
    {
        if(ImageEditManagerInst == nil)
        {
            ImageEditManagerInst = [[ImageEditManager alloc] init];
        }
    }
    return ImageEditManagerInst;
}

- (id) init
{
    if((self = [super init]))
    {
        
    }
    return self;
}

- (void) reset
{
    if(pixels)
    {
        free(pixels);
        pixels = nil;
    }
    if(context){
        CGContextRelease(context);
        context = nil;
    }
}

- (void) destorySingleTon
{
    if(ImageEditManagerInst)
        [ImageEditManagerInst release];
    
    [self reset];
}

- (void) dealloc
{    
    [super dealloc];
}


#pragma mark - Image I/O

- (BOOL) isImageSet
{
    if(pixels == nil || context == nil)
        return NO;
    
    return YES;
}

- (id) setImage:(UIImage *)anImage
{
    [self reset];
	if( anImage == nil ) {
		return nil;
	}
	
	CGSize size = anImage.size;
    width = size.width;
    height = size.height;
	imageOrientation = anImage.imageOrientation;
	sourceImage = anImage;
	
    // the pixels will be painted to this array
    pixels = (uint32_t *) malloc(width * height * sizeof(uint32_t));
	
    // clear the pixels so any transparency is preserved
    memset(pixels, 0, width * height * sizeof(uint32_t));
	
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	
    // create a context with RGBA pixels
    context = CGBitmapContextCreate(pixels, width, height, 8, width * sizeof(uint32_t), colorSpace, 
                                    kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);

	
    // paint the bitmap to our context which will fill in the pixels array
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), anImage.CGImage);
	
	
	CGColorSpaceRelease( colorSpace ); 
	
	return self;
}

- (id) setImageBuffer:(uint32_t *)buffer width:(CGFloat)bufWidth height:(CGFloat)bufHeight
{
    [self reset];
    
    if(buffer == nil){
        return nil;
    }
    
    pixels = buffer;
    width = bufWidth;
    height = bufHeight;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    // create a context with RGBA pixels
    context = CGBitmapContextCreate(buffer, bufWidth, bufHeight, 8, bufWidth * sizeof(uint32_t), colorSpace, 
                                    kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);
	CGColorSpaceRelease( colorSpace ); 
    
    return self;
}

-(UIImage*) getImage {
	if( context == nil ) {
		return nil;
	}
	
	CGImageRef image = CGBitmapContextCreateImage(context);
    
	// make a new UIImage to return
    UIImage *resultUIImage = [UIImage imageWithCGImage:image];
	
    // we're done with image now too
    CGImageRelease(image);
	
    return resultUIImage;	
}

- (void) saveImage
{
    UIImageWriteToSavedPhotosAlbum([self getImage], NULL, NULL, NULL);
}

#pragma mark - Filters
- (id) shineFilter
{
    for(int y = 0; y < height; y++) {
        for(int x = 0; x < width; x++) {
            uint8_t *rgbaPixel = (uint8_t *) &pixels[y * width + x];
//			
//            uint32_t gray = 0.3 * rgbaPixel[RED] + 0.59 * rgbaPixel[GREEN] + 0.11 * rgbaPixel[BLUE];
//			
//            // set the pixels to gray
//            rgbaPixel[RED] = gray;
//            rgbaPixel[GREEN] = gray;
//            rgbaPixel[BLUE] = gray;
            rgbaPixel[ALPHA] = 0.8 * rgbaPixel[ALPHA];
        }
    }
    
    return self;
}

- (id) sketchFilter //autoThreshold
{
    
/** grayScale을 적용한 이후에, sketchFilter를 적용할 경우,  
 * Threshold 값을 높일수록 나올 수 있는 gray 값이 늘어난다. 
 * 255 = 흰색, 0 = 검정색 이기 때문에 반대로 Threshold값을 낮추면 
 * 나올수 있는 gray값이 줄어들고 거의 검은색만 남게 된다.
 */
     
#define threshold_ratio 2
    int total[4] = {0, 0, 0, 0};
	int count = 0;
	for(int y=0; y<height; y++) {
		for(int x=0; x<width; x++) {
            uint8_t *rgbaPixel = (uint8_t *) &pixels[y * width + x];            
			total[0] += rgbaPixel[RED];
//            total[1] += rgbaPixel[GREEN];
//            total[2] += rgbaPixel[BLUE];
//			total[3] += rgbaPixel[ALPHA];
            count++;
		}
	}
    
//	int threshold[4] = {total[0]/count , total[1]/count, total[2]/count, total[3]/count};
    int threshold = total[0]/count;
    
	for(int y=0; y<height; y++) {
		for(int x=0; x<width; x++) {
            uint8_t *rgbaPixel = (uint8_t *) &pixels[y * width + x];
            
            
			if(rgbaPixel[RED] > threshold * threshold_ratio) {
				rgbaPixel[RED]= 255;//rgbaPixel[RED];
			} else {
				rgbaPixel[RED]= rgbaPixel[RED];
			}
            
			if(rgbaPixel[GREEN] > threshold * threshold_ratio) {
				rgbaPixel[GREEN]= 255;//rgbaPixel[RED];
			} else {
				rgbaPixel[GREEN]= rgbaPixel[GREEN];
			}        
            
            if(rgbaPixel[BLUE] > threshold * threshold_ratio) {
				rgbaPixel[BLUE]= 255;//rgbaPixel[RED];
			} else {
				rgbaPixel[BLUE]= rgbaPixel[BLUE];
			}

//            if(rgbaPixel[ALPHA] > threshold[3] * threshold_ratio) {
//				rgbaPixel[ALPHA]= 255;
//			} else {
////				rgbaPixel[ALPHA]= rgbaPixel[ALPHA];
//                rgbaPixel[ALPHA] = 0;
//			}
            

        
		}
	}
    
    return self;
}

- (id) blackWhiteFilter {
	for(int y = 0; y < height; y++) {
        for(int x = 0; x < width; x++) {
            uint8_t *rgbaPixel = (uint8_t *) &pixels[y * width + x];
			
            // convert to grayscale using recommended method: http://en.wikipedia.org/wiki/Grayscale#Converting_color_to_grayscale
            uint32_t gray = 0.3 * rgbaPixel[RED] + 0.59 * rgbaPixel[GREEN] + 0.11 * rgbaPixel[BLUE];
			
            // set the pixels to gray
            rgbaPixel[RED] = gray;
            rgbaPixel[GREEN] = gray;
            rgbaPixel[BLUE] = gray;
        }
    }
	
	return self;
}

- (id) blurFilter
{
    uint32_t * tempPixels = (uint32_t *) malloc(width * height * sizeof(uint32_t));
    
    int blur[5][5]={ 
		{ 1, 4, 7, 4, 1 },
		{ 4,16,26,16, 4 },
		{ 7,26,41,26, 7 },
		{ 4,16,26,16, 4 },
		{ 1, 4, 7, 4, 1 }};
    
	for(int y=0; y < height-5; y++) {
		for(int x=0; x < width-5; x++) {
			
            uint8_t *tempRgbaPixel = (uint8_t *) &tempPixels[y * width + x];
            int val[3] = {0, 0, 0};
			for(int dy = 0; dy < 5; dy++) {
				for(int dx = 0 ; dx < 5; dx++) {
                    uint8_t *rgbaPixel = (uint8_t *) &pixels[(y + dy) * width + (x + dx)];
					
                    val[0] += rgbaPixel[RED] * blur[dy][dx];
                    val[1] += rgbaPixel[GREEN] * blur[dy][dx];
                    val[2] += rgbaPixel[BLUE] * blur[dy][dx];
				}
			}
            
            tempRgbaPixel[RED] = val[0]/273;
            tempRgbaPixel[GREEN] = val[1]/273;
            tempRgbaPixel[BLUE] = val[2]/273;
		}
	}
    
    for(int y=0; y < height- 5; y++) {
		for(int x=0; x < width - 5; x++) {
            uint8_t *tempRgbaPixel = (uint8_t *) &tempPixels[y * width + x];
            uint8_t *rgbaPixel = (uint8_t *) &pixels[y * width + x];

            rgbaPixel[RED] = tempRgbaPixel[RED]; 
            rgbaPixel[GREEN] = tempRgbaPixel[GREEN];
            rgbaPixel[BLUE] = tempRgbaPixel[BLUE]; 
        }
    }
    
    return self;
}

#pragma mark - Image Function

- (void)startPainting:(UIView *)MainView Rect:(CGRect)rect
{
    paintView = [[PaintingViewModified alloc] initWithFrame:rect];

    paintView.isErase = NO;        
    paintView.pointSize = 1.5;
    paintView.backgroundColor = [UIColor clearColor];
    glColor4f(0.0, 0.0, 0.0, 1.0);
    
    [MainView addSubview:paintView];
}

- (id) combineWithImage
{
    unsigned char * drawedBuffer = [paintView getImageBuffer:paintView.bounds];
    NSLog(@"(%f,%f,%f,%f)", paintView.bounds.origin.x, paintView.bounds.origin.y, paintView.bounds.size.width, paintView.bounds.size.height);
//    if( drawedBuffer == nil ) {
//		return nil ;
//	}
	
//	CGSize size = drawedImage.size;
//    width = size.width;
//    height = size.height;
//    
//    uint32_t * drawedImagePixels = (uint32_t *) malloc(width * height * sizeof(uint32_t));
//    memset(drawedImagePixels, 0, width * height * sizeof(uint32_t));
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    CGContextRef drawedImageContext = CGBitmapContextCreate(drawedImagePixels, width, height, 8, width * sizeof(uint32_t), colorSpace, 
//                                    kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);
//    CGContextDrawImage(drawedImageContext, CGRectMake(0, 0, width, height), drawedImage.CGImage);
//	CGColorSpaceRelease( colorSpace ); 

    for(int y = 0; y < height; y++) {
        for(int x = 0; x < width; x++) {
//            uint8_t *tempRgbaPixel = (uint8_t *) &drawedImagePixels[y * width + x];
            uint8_t *rgbaPixel = (uint8_t *) &pixels[y * width + x];

            int index = 4 * y * width + 4 * x;
            int isClear = drawedBuffer[index] + drawedBuffer[index + 1] + drawedBuffer[index + 2] + drawedBuffer[index + 3]; //0:Clear other:haveColor
            if(isClear != 0)
            {
                rgbaPixel[RED] = drawedBuffer[index];
                rgbaPixel[GREEN] = drawedBuffer[index + 1];
                rgbaPixel[BLUE] = drawedBuffer[index + 2];
                rgbaPixel[ALPHA] = drawedBuffer[index + 3];
            }
            
//            NSLog(@"%d %d %d %d", drawedBuffer[0], drawedBuffer[1], drawedBuffer[2], drawedBuffer[3]);
        }
    }

//    free(drawedImagePixels);
//    CGContextRelease(drawedImageContext);
    
    return self;
}

//TODO JHLee Need More 보완 
- (void)combineWithOtherImage:(UIImage *)image
{    
    image = [UIImage imageNamed:@"pop_yellow_like_0.png"];
    int comWidth = image.size.width; int comHeight =  image.size.height;
    uint32_t * buffer = (uint32_t *) malloc(comWidth * comHeight * sizeof(uint32_t));
    
    NSLog(@"%f %f", image.size.width, image.size.height);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    context = CGBitmapContextCreate(buffer, width, height, 8, width * sizeof(uint32_t), colorSpace, 
                                    kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), image.CGImage);
	CGColorSpaceRelease( colorSpace ); 
    
    
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    context = CGBitmapContextCreate(buffer, comWidth, comHeight, 8, comWidth * sizeof(uint32_t), colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);
//    CGContextDrawImage(context, CGRectMake(0, 0, comWidth, comHeight), image.CGImage);
//	CGColorSpaceRelease( colorSpace ); 
    
    for(int y = 0; y < comHeight; y++) {
        for(int x = 0; x < comWidth; x++) {
            uint8_t *rgbaPixel = (uint8_t *) &buffer[y * comWidth + x];
            int index = 4 * y * comWidth + 4 * x;
//            int isClear = rgbaPixel[index] + rgbaPixel[index + 1] + rgbaPixel[index + 2] + rgbaPixel[index + 3]; //0:Clear other:haveColor
//            NSLog(@"x:%d y:%d isClear:%d buffer:%d",x, y, isClear, buffer[y * comWidth + x]);
//            if(isClear != 0)
//            memset(pixels, 0, width * height * sizeof(uint32_t));
//            pixels[y * width + x] = buffer[y * comWidth + x];
        }
    }
    
    uint32_t * combinedPixel = (uint32_t *) malloc(height * width * sizeof(uint32_t));
    for(int y=0; y < height; y++) {
        for(int x=0; x < width; x++) {
            combinedPixel[y * width + x] = pixels[y * width + x];
        }
    }
    
    [self setImageBuffer:combinedPixel width:width height:height];
}

- (void)erasePaintView
{
    [paintView erase];
    [paintView removeFromSuperview];
 
    glColor4f(0.0, 0.0, 0.0, 0.0);
    [paintView release];
}

- (void) rotate:(UIImageView *)anImageView degree:(double)degree
{
    double initialDegree = atan2(anImageView.transform.b , anImageView.transform.a);
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationCurve:100.0];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    
    CGAffineTransform cgCTM = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(degree) + initialDegree);
    anImageView.transform = cgCTM;
    
    [UIView commitAnimations];
    
    uint32_t * rotatedPixels = (uint32_t *) malloc(height * width * sizeof(uint32_t));
    
    if(degree == 90)
    {
        for(int y=0; y < height; y++) {
            for(int x=0; x < width; x++) {
                rotatedPixels[x * height + (height - y - 1)] = pixels[y * width + x];
            }
        }
    }
    
    [self setImageBuffer:rotatedPixels width:height height:width];

}

- (void) rotationEnable:(UIImageView *)outputImage
{
     [outputImage setMultipleTouchEnabled:YES];
}

- (void) rotationStart:(NSSet*)touches onMainView:(UIView *)view
{
	
	NSArray *allTouches = [touches allObjects]; 
	int count = [allTouches count];
	
	if (count > 1) {
		touch1 = [[allTouches objectAtIndex:0] locationInView:view]; 
		touch2 = [[allTouches objectAtIndex:1] locationInView:view];
	}
}

- (void) rotating:(NSSet *)touches onMainView:(UIView *)view withImage:(UIImageView *)outputImage
{
    CGPoint currentTouch1;
	CGPoint currentTouch2;
	
	NSArray *allTouches = [touches allObjects]; 
	int count = [allTouches count]; 
	
    //	if (count == 1) {
    //		if (CGRectContainsPoint([outputImage frame], [[allTouches objectAtIndex:0] locationInView:self.view])) {
    //			outputImage.center = [[allTouches objectAtIndex:0] locationInView:self.view];
    //			return;
    //		}
    //	}
    
    
	if (count > 1) {
		if ((CGRectContainsPoint([outputImage frame], [[allTouches objectAtIndex:0] locationInView:view])) ||
			(CGRectContainsPoint([outputImage frame], [[allTouches objectAtIndex:1] locationInView:view]))) {
            
			currentTouch1 = [[allTouches objectAtIndex:0] locationInView:view]; 
			currentTouch2 = [[allTouches objectAtIndex:1] locationInView:view];
			
			CGFloat previousAngle = atan2(touch2.y - touch1.y, touch2.x - touch1.x) * 180 / M_PI;
			CGFloat currentAngle = atan2(currentTouch2.y - currentTouch1.y,currentTouch2.x - currentTouch1.x) * 180 / M_PI;
            
			CGFloat angleToRotate = currentAngle - previousAngle;
            
			CGAffineTransform transform = CGAffineTransformRotate(outputImage.transform, DEGREES_TO_RADIANS(angleToRotate));
            
			outputImage.transform = transform;
			touch1 = currentTouch1;
			touch2 = currentTouch2;
		}
		
	}
    
}

- (void) rotationEnd:(NSSet *)touches onMainView:(UIView *)view withImage:(UIImageView *)outputImage
{
    UITouch *touch = [touches anyObject];
	
	if ([touch tapCount] == 2) {
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationBeginsFromCurrentState:YES];
		[UIView setAnimationCurve:UIViewAnimationCurveLinear];
		[UIView setAnimationDuration:0.20];
		outputImage.center = view.center;
		outputImage.transform = CGAffineTransformIdentity;
		[UIView commitAnimations];
		
		return;
	}
}

- (CGFloat)distanceBetweenTwoPoints:(CGPoint)fromPoint toPoint:(CGPoint)toPoint {
    
	float x = toPoint.x - fromPoint.x;
    float y = toPoint.y - fromPoint.y;
    
    return sqrt(x * x + y * y);
}

- (void) cutStart:(NSSet*)touches onMainView:(UIView *)view WithImage:(CuttingView *)cutImage
{
	NSArray *allTouches = [touches allObjects]; 
	int count = [allTouches count];
	
    initialWidth = cutImage.frame.size.width;
    initialHeight = cutImage.frame.size.height;
    
	if (count > 1) {
		touch1 = [[allTouches objectAtIndex:0] locationInView:view]; 
		touch2 = [[allTouches objectAtIndex:1] locationInView:view];
        
        initialDistance = [self distanceBetweenTwoPoints:touch1 toPoint:touch2];
        
	}
}

- (void) cutting:(NSSet *)touches onMainView:(UIView *)view withImage:(CuttingView *)outputImage
{
    CGPoint currentTouch1;
	CGPoint currentTouch2;
	
	NSArray *allTouches = [touches allObjects]; 
	int count = [allTouches count]; 
	
//	if (count == 1) {
//		if (CGRectContainsPoint([outputImage frame], [[allTouches objectAtIndex:0] locationInView:view])) {
//			outputImage.center = [[allTouches objectAtIndex:0] locationInView:view];
//			return;
//		}
//	}
    
    
	if (count > 1) {
//		if ((CGRectContainsPoint([outputImage frame], [[allTouches objectAtIndex:0] locationInView:view])) ||
//			(CGRectContainsPoint([outputImage frame], [[allTouches objectAtIndex:1] locationInView:view]))) 
        {
            
//            if((touch2.y - touch1.y) == 0 || (touch2.x - touch1.x) == 0)
//                return;
            
			currentTouch1 = [[allTouches objectAtIndex:0] locationInView:view]; 
			currentTouch2 = [[allTouches objectAtIndex:1] locationInView:view];
			
            if(initialDistance == 0)
            {
                initialDistance = [self distanceBetweenTwoPoints:currentTouch1 toPoint:currentTouch2];
            }
            
//            CGFloat ratio =  MAX((currentTouch2.y - currentTouch1.y) / (touch2.y - touch1.y) , (currentTouch2.y - currentTouch1.y) / (touch2.x - touch1.x));
//          CGFloat previousAngle = atan2(touch2.y - touch1.y, touch2.x - touch1.x) * 180 / M_PI;
//			CGFloat currentAngle = atan2(currentTouch2.y - currentTouch1.y,currentTouch2.x - currentTouch1.x) * 180 / M_PI;            
//			CGFloat angleToRotate = currentAngle - previousAngle;
//			CGAffineTransform transform = CGAffineTransformRotate(outputImage.transform, DEGREES_TO_RADIANS(angleToRotate));
//			outputImage.transform = transform;

            finalDistance = [self distanceBetweenTwoPoints:currentTouch1 toPoint:currentTouch2];
            CGFloat  ratio = finalDistance/initialDistance;
            
            CGPoint center = CGPointMake((currentTouch1.x + currentTouch2.x) / 2.0, (currentTouch1.y + currentTouch2.y) / 2.0);
            CGFloat Imagewidth = initialWidth * ratio;
            CGFloat Imageheight = initialHeight * ratio;

            [outputImage setFrame:CGRectMake(center.x - Imagewidth / 2, center.y - Imageheight /2 , Imagewidth, Imageheight)];
            [outputImage drawBoundary];
            
//			touch1 = currentTouch1;
//			touch2 = currentTouch2;
            
		}
		
	}

}

//ImageSource and CuttingView must have same frame
- (UIImage *)cutAndSaveImage:(CuttingView *)cutView
{
    int cutX = cutView.frame.origin.x;
    int cutY = cutView.frame.origin.x;
    int cutWidth = cutView.frame.size.width;
    int cutHeight = cutView.frame.size.height;
    
	
	NSLog(@"cutX:%d cutY:%d cutWidth:%d cutHeight:%d", cutX, cutY, cutWidth, cutHeight);
    uint32_t * cutPixels = (uint32_t *) malloc(cutWidth * cutHeight * sizeof(uint32_t));
    for(int y = cutY; y < cutHeight + cutY; y++) {
        for(int x = cutX; x < cutWidth + cutX; x++) {
            
            uint8_t *cutPixel = (uint8_t *) &cutPixels[(y - cutY) * cutWidth + (x - cutX)];
            uint8_t *rgbaPixel = (uint8_t *) &pixels[y * width + x];
            
            cutPixel[RED] = rgbaPixel[RED];
            cutPixel[GREEN] = rgbaPixel[GREEN];
            cutPixel[BLUE] = rgbaPixel[BLUE];
            cutPixel[ALPHA] = rgbaPixel[ALPHA];

        }
    }

//	uint32_t * cutPixels = (uint32_t *) malloc(width * height * sizeof(uint32_t));
//	for(int y = 0; y < height; y++) {
//        for(int x = 0; x < width; x++) {
//            
//            uint8_t *cutPixel = (uint8_t *) &cutPixels[y * width + x];
//            uint8_t *rgbaPixel = (uint8_t *) &pixels[y * width + x];
//            
//            cutPixel[RED] = rgbaPixel[RED];
//            cutPixel[GREEN] = rgbaPixel[GREEN];
//            cutPixel[BLUE] = rgbaPixel[BLUE];
//            cutPixel[ALPHA] = rgbaPixel[ALPHA];
//			
//        }
//    }

    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef cutContext = CGBitmapContextCreate(cutPixels, cutWidth, cutHeight, 8, cutWidth * sizeof(uint32_t), colorSpace, 
                                    kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);
	
//	CGContextRef cutContext = CGBitmapContextCreate(cutPixels, width, height, 8, width * sizeof(uint32_t), colorSpace, 
//													kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);
	//=========Cut Issue:(TODO:JHLee) have to fix rotation ==========//
	//	if(imageOrientation == UIImageOrientationRight)
	//	{
		CGContextTranslateCTM(cutContext, width/2, height/2);
		CGContextRotateCTM(cutContext, DEGREES_TO_RADIANS(90));
//		CGContextScaleCTM(cutContext, -1, 1);
//		CGContextTranslateCTM(cutContext, -width, 0);
	//		
	//	}
	//=========Cut Issue:(TODO:JHLee) have to fix rotation ==========//
	
	CGImageRef image = CGBitmapContextCreateImage(cutContext);
    UIImage *resultUIImage = [UIImage imageWithCGImage:image];
	CGColorSpaceRelease( colorSpace ); 
    free(cutPixels);
    
    //=============== resetImage ===============//
    [self reset];
    [self setImage:resultUIImage];
    
    //==========================================//
    
    
    return resultUIImage;
}



@end
