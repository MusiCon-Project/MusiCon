

#import <UIKit/UIKit.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

//CONSTANTS:

#define kBrushOpacity		(1.0 / 3.0)
#define kBrushPixelStep		1
#define kBrushScale			2
#define kLuminosity			0.75
#define kSaturation			1.0
#define kAADistance1		1.0
#define kAADistance2		1.5
#define kAADistanceMax		2.0
#define kAADistanceInterval	0.5
#define kAARoundCount		15

//CLASS INTERFACES:

@interface PaintingViewModified : UIView
{
	NSMutableArray *bufferXArray;
	NSMutableArray *bufferYArray;
	CGFloat slopeX,slopeY,pointSize;
	
	
@private
	// The pixel dimensions of the backbuffer
	GLint backingWidth;
	GLint backingHeight;
	
	EAGLContext *context;
	
	// OpenGL names for the renderbuffer and framebuffers used to render to this view
	GLuint viewRenderbuffer, viewFramebuffer;
	
	// OpenGL name for the depth buffer that is attached to viewFramebuffer, if it exists (0 if it does not exist)
	GLuint depthRenderbuffer;
	
	GLuint	brushTexture;
	CGPoint	location;
	CGPoint	previousLocation;
	Boolean	firstTouch;
	Boolean needsErase;
	
	Boolean isErase;
}

@property(nonatomic, readwrite) CGPoint location;
@property(nonatomic, readwrite) CGPoint previousLocation;

@property(retain) NSMutableArray *bufferXArray;
@property(retain) NSMutableArray *bufferYArray;
@property CGFloat pointSize;
@property Boolean isErase;

- (void) initGL;
- (void)erase;
- (void)saveImage:(CGRect)myRect;
- (UIImage *)drawableToCGImage:(CGRect)myRect;
- (void)renderHermiteCurveWithXArray:(NSArray *)xArray YArray:(NSArray *)yArray;
- (GLubyte *)getImageBuffer:(CGRect)myRect;

@end
