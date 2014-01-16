/*
 *  Image.h
 *  ImageProcessing
 *
 *  Created by Chris Greening on 02/01/2009.
 *  Modified by JaeHoon Lee on 29/06/2011.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//#import <vector>

@class Image;
// objective C wrapper for our image class
@interface ImageWrapper : NSObject {
	Image *image;
	bool ownsImage;
}

@property(assign, nonatomic) Image *image;
@property(assign, nonatomic) bool ownsImage;
+ (ImageWrapper *) imageWithCPPImage:(Image *) theImage;
@end

@interface ImagePoint : NSObject {
@public
    short x,y;
}
@property(assign, nonatomic) short x; 
@property(assign, nonatomic) short y;
+ (ImagePoint *)ImagePoint;
+ (ImagePoint *)ImagePointWithxPos:(int)xpos yPos:(int)ypos;
+ (ImagePoint *)ImagePointWithOther:(const ImagePoint *)other;
@end

@interface Image : NSObject {
    uint8_t * m_imageData;
    uint8_t ** m_yptrs;
    
    int m_width;
    int m_height;
    
    bool m_ownsData;
}
@property(assign, nonatomic) uint8_t * m_imageData;
@property(assign, nonatomic) uint8_t ** m_yptrs;
@property(assign, nonatomic) int m_width;
@property(assign, nonatomic) int m_height;
@property(assign, nonatomic) bool m_ownsData;
+ (Image *)Image:(ImageWrapper *)other x1:(int)x1 y1:(int)y1 x2:(int)x2 y2:(int)y2;
+ (Image *)Image:(int) width height:(int)height;
+ (Image *)Image:(uint8_t *)imageData width:(int)width height:(int)height ownsData:(bool)ownsData;
+ (Image *)Image:(UIImage *)srcImage width:(int)width height:(int)height interpolation:(CGInterpolationQuality)interpolation imageIsRotatedBy90degrees:(bool)imageIsRotatedBy90degrees;
- (void) initYptrs;
- (ImageWrapper *) autoThreshold;	// threshold an image automatically
@end

/*
 class Image {
 private:
 uint8_t *m_imageData;
 uint8_t **m_yptrs;
 int m_width;
 int m_height;
 bool m_ownsData;
 Image(ImageWrapper *other, int x1, int y1, int x2, int y2);
 Image(int width, int height);
 Image(uint8_t *imageData, int width, int height, bool ownsData=false);
 Image(UIImage *srcImage, int width, int height, CGInterpolationQuality interpolation, bool imageIsRotatedBy90degrees=false);
 void initYptrs();
 public:
 // copy a section of another image
 static ImageWrapper *createImage(ImageWrapper *other, int x1, int y1, int x2, int y2);
 // create an empty image of the required width and height
 static ImageWrapper *createImage(int width, int height);
 // create an image from data
 static ImageWrapper *createImage(uint8_t *imageData, int width, int height, bool ownsData=false);
 // take a source UIImage and convert it to greyscale
 static ImageWrapper *createImage(UIImage *srcImage, int width, int height, bool imageIsRotatedBy90degrees=false);
 // edge detection
 ImageWrapper *cannyEdgeExtract(float tlow, float thigh);
 // local thresholding
 ImageWrapper* autoLocalThreshold();
 // threshold using integral
 ImageWrapper *autoIntegratingThreshold();
 // threshold an image automatically
 ImageWrapper *autoThreshold();
 // gaussian smooth the image
 ImageWrapper *gaussianBlur();
 // get the percent set pixels
 int getPercentSet();
 // exrtact a connected area from the image
 void extractConnectedRegion(int x, int y, std::vector<ImagePoint> *points);
 // find the largest connected region in the image
 void findLargestStructure(std::vector<ImagePoint> *maxPoints);
 // normalise an image
 void normalise();
 // rotate by 90, 180, 270, 360
 ImageWrapper *rotate(int angle);
 // shrink to a new size
 ImageWrapper *resize(int newX, int newY);
 ImageWrapper *shrinkBy2();
 // histogram equalisation
 void HistogramEqualisation();
 // skeltonize
 void skeletonise();
 // convert back to a UIImage for display
 UIImage *toUIImage();
 ~Image() {
 if(m_ownsData)
 free(m_imageData);
 delete m_yptrs;
 }
 inline uint8_t* operator[](const int rowIndex) {
 return m_yptrs[rowIndex];
 }
 inline int getWidth() {
 return m_width;
 }
 inline int getHeight() {
 return m_height;
 }
 };
 
 inline bool sortByX1(const ImagePoint &p1, const ImagePoint &p2) {
 if(p1.x==p2.x) return p1.y<p2.y;
 return p1.x<p2.x;
 }
 *//*
    inline bool sortByY1(const ImagePoint &p1, const ImagePoint &p2) {
	if(p1.y==p2.y) return p1.x<p2.x;
	return p1.y<p2.y;
    }
    */
