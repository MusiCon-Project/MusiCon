/*
 *  Image.h
 *  ImageProcessing
 *
 *  Created by Chris Greening on 02/01/2009.
 *  Modified by JaeHoon Lee on 29/06/2011.
 */

#include "Image.h"
//#include <stack>

@implementation ImageWrapper

@synthesize image;
@synthesize ownsImage;

#pragma mark - imageWrapper Class Method

+ (ImageWrapper *) imageWithCPPImage:(Image *) theImage;
{
	ImageWrapper *wrapper = [[ImageWrapper alloc] init];
	wrapper.image=theImage;
	wrapper.ownsImage=true;
	return [wrapper autorelease];
}

+ (ImageWrapper *) imageWithCPPImage:(Image *) theImage ownsImage:(bool) ownsTheImage;
{
	ImageWrapper *wrapper = [[ImageWrapper alloc] init];
	wrapper.image=theImage;
	wrapper.ownsImage=ownsTheImage;
	return [wrapper autorelease];
}

- (void) dealloc
{
	// delete the image that we have been holding onto
//	if(ownsImage) [image release];
	[super dealloc];
}


@end

@implementation ImagePoint
@synthesize x;
@synthesize y;

#pragma mark - imagePoint init Class Method
+ (ImagePoint *)ImagePoint
{
    ImagePoint *Point = [[ImagePoint alloc] init];
    Point.x = 0;
    Point.y = 0;
    
    return [Point autorelease];
}

+ (ImagePoint *)ImagePointWithxPos:(int)xpos yPos:(int)ypos
{
    ImagePoint *Point = [[ImagePoint alloc] init];
    Point.x = xpos;
    Point.y = ypos;
    
    return [Point autorelease];
}

+ (ImagePoint *)ImagePointWithOther:(const ImagePoint *)other
{
    ImagePoint *Point = [[ImagePoint alloc] init];
    Point.x = other.x;
    Point.y = other.y;
    
    return [Point autorelease];
}
@end

@implementation Image
@synthesize m_imageData;
@synthesize m_yptrs;
@synthesize m_width;
@synthesize m_height;
@synthesize m_ownsData;

- (void)initYptrs
{
    m_yptrs = (uint8_t **) malloc(sizeof(uint8_t *) * m_height);
    for(int i = 0; i < m_height; i++)
    {
        m_yptrs[i] = m_imageData + i * m_width;
    }
}

#pragma mark - image init Class Method

+ (Image *)Image:(ImageWrapper *)other x1:(int)x1 y1:(int)y1 x2:(int)x2 y2:(int)y2
{
    Image *ImageInst = [[Image alloc] init];
    
    ImageInst.m_width = x2 - x1;
    ImageInst.m_height = y2 - y1;
    ImageInst.m_imageData = (uint8_t *)malloc(ImageInst.m_width * ImageInst.m_height);
    
    [ImageInst initYptrs];
    
    Image *otherImage = other.image;
    for(int y = y1; y < y2; y++)
    {
        for(int x = x1; x < x2; x++)
        {
            ImageInst.m_yptrs[y - y1][x - x1] = otherImage.m_yptrs[y][x]; //I don't know //(*this)[y-y1][x-x1]=(*otherImage)[y][x];
        }
    }
    
    ImageInst.m_ownsData = YES;
    
    return [ImageInst autorelease];
}

+ (Image *)Image:(int) width height:(int)height
{
    Image *ImageInst = [[Image alloc] init];

    ImageInst.m_imageData = (uint8_t *)malloc(width*height);
    ImageInst.m_width = width;
    ImageInst.m_height = height;
    ImageInst.m_ownsData = YES;
    [ImageInst initYptrs];
    
    return [ImageInst autorelease];
}

+ (Image *)Image:(uint8_t *)imageData width:(int)width height:(int)height ownsData:(bool)ownsData
{
    Image *ImageInst = [[Image alloc] init];
    
    ImageInst.m_imageData = imageData;
    ImageInst.m_width = width;
    ImageInst.m_height = height;
    ImageInst.m_ownsData = ownsData;
	[ImageInst initYptrs];
    
    return [ImageInst autorelease];
}

+ (Image *)Image:(UIImage *)srcImage width:(int)width height:(int)height interpolation:(CGInterpolationQuality)interpolation imageIsRotatedBy90degrees:(bool)imageIsRotatedBy90degrees
{
    Image *ImageInst = [[Image alloc] init];
    
    if(imageIsRotatedBy90degrees) {
		int tmp = width;
		width = height;
		height = tmp;
	}
    
	ImageInst.m_width = width;
	ImageInst.m_height = height;
	// get hold of the image bytes
	ImageInst.m_imageData = (uint8_t *)malloc(ImageInst.m_width * ImageInst.m_height);

	CGColorSpaceRef colorSpace=CGColorSpaceCreateDeviceGray();
	CGContextRef context=CGBitmapContextCreate(ImageInst.m_imageData,  ImageInst.m_width, ImageInst.m_height, 8, ImageInst.m_width, colorSpace, kCGImageAlphaNone);
	CGContextSetInterpolationQuality(context, interpolation);
	CGContextSetShouldAntialias(context, NO);
	CGContextDrawImage(context, CGRectMake(0,0, ImageInst.m_width, ImageInst.m_height), [srcImage CGImage]);
	CGContextRelease(context);
	CGColorSpaceRelease(colorSpace);
	
	if(imageIsRotatedBy90degrees) {
		uint8_t *tmpImage=(uint8_t *) malloc(ImageInst.m_width * ImageInst.m_height);
		for(int y=0; y < ImageInst.m_height; y++) {
			for(int x=0; x < ImageInst.m_width; x++) {
				tmpImage[x * ImageInst.m_height + y] = ImageInst.m_imageData[(ImageInst.m_height-y-1) * ImageInst.m_width + x];
			}
		}
		int tmp = ImageInst.m_width;
		ImageInst.m_width = ImageInst.m_height;
		ImageInst.m_height=tmp;
		free(ImageInst.m_imageData);
		ImageInst.m_imageData=tmpImage;
	}
    
    [ImageInst initYptrs];
    
    return [ImageInst autorelease];
}


- (void)dealloc
{
    if(m_imageData)
    {
        free(m_imageData);
    }
    if(m_yptrs){
        free(m_yptrs);
    }
    
    [super dealloc];
}

#pragma mark - image Filter Method

- (ImageWrapper *) autoThreshold
{
    int total = 0;
	int count = 0;
	for(int y=0; y<m_height; y++) {
		for(int x=0; x<m_width; x++) {
			total += m_yptrs[y][x];
			count++;
		}
	}
	int threshold = total/count;
    
	Image *result= [Image Image:m_width height:m_height];
	for(int y=0; y<m_height; y++) {
		for(int x=0; x<m_width; x++) {
			if(m_yptrs[y][x]>threshold*0.8) {
				m_yptrs[y][x]=0;
			} else {
				m_yptrs[y][x]=255;
			}
		}
	}
	return [ImageWrapper imageWithCPPImage:result];
}

- (ImageWrapper *)gaussianBlur
{
    int blur[5][5]={ 
		{ 1, 4, 7, 4, 1 },
		{ 4,16,26,16, 4 },
		{ 7,26,41,26, 7 },
		{ 4,16,26,16, 4 },
		{ 1, 4, 7, 4, 1 }};
    
    Image *result = [Image Image:(m_width - 5) height:(m_height - 5)];
	for(int y=0; y<m_height-5; y++) {
		for(int x=0; x<m_width-5; x++) {
			int val=0;
			for(int dy=0; dy<5; dy++) {
				for(int dx=0; dx<5; dx++) {
					int pixel = m_yptrs[y+dy][x+dx];
					val += pixel*blur[dy][dx];
				}
			}
			result.m_yptrs[y][x] = val/273;
		}
	}
	return [ImageWrapper imageWithCPPImage:result];	
}

@end