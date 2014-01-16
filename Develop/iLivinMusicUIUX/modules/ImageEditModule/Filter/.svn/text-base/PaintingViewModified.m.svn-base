
#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/EAGLDrawable.h>
#import <Foundation/Foundation.h>

#import "PaintingViewModified.h"

//CLASS IMPLEMENTATIONS:

// A class extension to declare private methods
@interface PaintingViewModified (private)

- (BOOL)createFramebuffer;
- (void)destroyFramebuffer;

@end

@implementation PaintingViewModified

@synthesize  location;
@synthesize  previousLocation;

@synthesize bufferXArray;
@synthesize bufferYArray;
@synthesize pointSize;
@synthesize isErase;

// Implement this to override the default layer class (which is [CALayer class]).
// We do this so that our view will be backed by a layer that is capable of OpenGL ES rendering.
+ (Class) layerClass
{
	return [CAEAGLLayer class];
}

- (id)initWithFrame:(CGRect)rect{
	
	CGImageRef		brushImage;
	CGContextRef	brushContext;
	GLubyte			*brushData;
	size_t			width, height;
    
    if ((self = [super initWithFrame:rect])) {
		CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
		
		eaglLayer.opaque = YES;
		// In this application, we want to retain the EAGLDrawable contents after a call to presentRenderbuffer.
		eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
										[NSNumber numberWithBool:YES], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
		
		context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
		
		if (!context || ![EAGLContext setCurrentContext:context]) {
			[self release];
			return nil;
		}
		
		// Create a texture from an image
		// First create a UIImage object from the data in a image file, and then extract the Core Graphics image
		brushImage = [UIImage imageNamed:@"Particle2_3.png"].CGImage;
		
		// Get the width and height of the image
		width = CGImageGetWidth(brushImage);
		height = CGImageGetHeight(brushImage);
		
		// Texture dimensions must be a power of 2. If you write an application that allows users to supply an image,
		// you'll want to add code that checks the dimensions and takes appropriate action if they are not a power of 2.
		
		// Make sure the image exists
		if(brushImage) {
			// Allocate  memory needed for the bitmap context
			brushData = (GLubyte *) calloc(width * height * 4, sizeof(GLubyte));
			// Use  the bitmatp creation function provided by the Core Graphics framework. 
			brushContext = CGBitmapContextCreate(brushData, width, height, 8, width * 4, CGImageGetColorSpace(brushImage), kCGImageAlphaPremultipliedLast);
			
			//			for(int i=0;i<width*height*4;i=i+4){
			//				
			//				//NSLog(@"data[%d] = %d \t data[%d] = %d \t data[%d] = %d \t data[%d] = %d",i,brushData[i],i+1,brushData[i+1],i+2,brushData[i+2],i+3,brushData[i+3]);
			//				brushData[i] = 255;
			//				brushData[i+1]=255;
			//				brushData[i+2]=255;
			//			}
			
			// After you create the context, you can draw the  image to the context.
			CGContextDrawImage(brushContext, CGRectMake(0.0, 0.0, (CGFloat)width, (CGFloat)height), brushImage);
			// You don't need the context at this point, so you need to release it to avoid memory leaks.
			CGContextRelease(brushContext);
			// Use OpenGL ES to generate a name for the texture.
			glGenTextures(1, &brushTexture);
			// Bind the texture name. 
			glBindTexture(GL_TEXTURE_2D, brushTexture);
			// Set the texture parameters to use a minifying filter and a linear filer (weighted average)
			glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
			glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
			// Specify a 2D texture image, providing the a pointer to the image data in memory
			glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, brushData);
			
			// Release  the image data; it's no longer needed
            free(brushData);
		}
		
		//Set up OpenGL states
		glMatrixMode(GL_PROJECTION);
		CGRect frame = self.bounds;
		glOrthof(0, frame.size.width, 0, frame.size.height, -1, 1);
		glViewport(0, 0, frame.size.width, frame.size.height);
		glMatrixMode(GL_MODELVIEW);
		
		glEnable(GL_TEXTURE_2D);
		glEnableClientState(GL_VERTEX_ARRAY);
		glEnableClientState(GL_COLOR_ARRAY);
		
	    glEnable(GL_BLEND);
		glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
		
		glEnable(GL_POINT_SPRITE_OES);
		glTexEnvf(GL_POINT_SPRITE_OES, GL_COORD_REPLACE_OES, GL_TRUE);
		
		//Make sure to start with a cleared buffer
		needsErase = YES;
		[self erase];
		
	}
	
	bufferXArray = [[NSMutableArray alloc] init];
	bufferYArray = [[NSMutableArray alloc] init];
	slopeX = 0.0;
	slopeY = 0.0;
	
	return self;
	
}


- (void) initGL{
    CGImageRef		brushImage;
    CGContextRef	brushContext;
    GLubyte			*brushData;
    size_t			width, height;

    CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
    
    eaglLayer.opaque = YES;
    // In this application, we want to retain the EAGLDrawable contents after a call to presentRenderbuffer.
    eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithBool:YES], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
    
    context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
    
    if (!context || ![EAGLContext setCurrentContext:context]) {
        [self release];
        return ;
    }
    
    // Create a texture from an image
    // First create a UIImage object from the data in a image file, and then extract the Core Graphics image
    brushImage = [UIImage imageNamed:@"Particle2_3.png"].CGImage;
    
    // Get the width and height of the image
    width = CGImageGetWidth(brushImage);
    height = CGImageGetHeight(brushImage);
    
    // Texture dimensions must be a power of 2. If you write an application that allows users to supply an image,
    // you'll want to add code that checks the dimensions and takes appropriate action if they are not a power of 2.
    
    // Make sure the image exists
    if(brushImage) {
        // Allocate  memory needed for the bitmap context
        brushData = (GLubyte *) calloc(width * height * 4, sizeof(GLubyte));
        // Use  the bitmatp creation function provided by the Core Graphics framework. 
        brushContext = CGBitmapContextCreate(brushData, width, height, 8, width * 4, CGImageGetColorSpace(brushImage), kCGImageAlphaPremultipliedLast);
        
        //			for(int i=0;i<width*height*4;i=i+4){
        //				
        //				//NSLog(@"data[%d] = %d \t data[%d] = %d \t data[%d] = %d \t data[%d] = %d",i,brushData[i],i+1,brushData[i+1],i+2,brushData[i+2],i+3,brushData[i+3]);
        //				brushData[i] = 255;
        //				brushData[i+1]=255;
        //				brushData[i+2]=255;
        //			}
        
        // After you create the context, you can draw the  image to the context.
        CGContextDrawImage(brushContext, CGRectMake(0.0, 0.0, (CGFloat)width, (CGFloat)height), brushImage);
        // You don't need the context at this point, so you need to release it to avoid memory leaks.
        CGContextRelease(brushContext);
        // Use OpenGL ES to generate a name for the texture.
        glGenTextures(1, &brushTexture);
        // Bind the texture name. 
        glBindTexture(GL_TEXTURE_2D, brushTexture);
        // Set the texture parameters to use a minifying filter and a linear filer (weighted average)
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
        // Specify a 2D texture image, providing the a pointer to the image data in memory
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, brushData);
        
        // Release  the image data; it's no longer needed
        free(brushData);
    }
    
    //Set up OpenGL states
    glMatrixMode(GL_PROJECTION);
    CGRect frame = self.bounds;
    glOrthof(0, frame.size.width, 0, frame.size.height, -1, 1);
    glViewport(0, 0, frame.size.width, frame.size.height);
    glMatrixMode(GL_MODELVIEW);
    
    glEnable(GL_TEXTURE_2D);
    glEnableClientState(GL_VERTEX_ARRAY);
    glEnableClientState(GL_COLOR_ARRAY);
    
    glEnable(GL_BLEND);
    glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
    
    glEnable(GL_POINT_SPRITE_OES);
    glTexEnvf(GL_POINT_SPRITE_OES, GL_COORD_REPLACE_OES, GL_TRUE);
    
//    //Make sure to start with a cleared buffer
    needsErase = YES;
    [self erase];


    bufferXArray = [[NSMutableArray alloc] init];
    bufferYArray = [[NSMutableArray alloc] init];
    slopeX = 0.0;
    slopeY = 0.0;
}

- (void)drawView
{
	UIImage *uiImage = [UIImage imageNamed:@"chatwindow_bg_2.png"];
	
	CGImageRef image = uiImage.CGImage;
	NSUInteger width = CGImageGetWidth(image);
	NSUInteger height = CGImageGetHeight(image);
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	UInt8 * rawData = malloc(height * width * 4);
	
	int bytesPerPixel = 4;
	int bytesPerRow = bytesPerPixel * width;
	
	NSUInteger bitsPerComponent = 8;
	CGContextRef context1 = CGBitmapContextCreate(
												  rawData, width, height, bitsPerComponent, bytesPerRow, colorSpace,
												  kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big
												  );
	CGColorSpaceRelease(colorSpace);
	
	CGContextDrawImage(context1, CGRectMake(0, 0, width, height), image);
	CGContextRelease(context1);
	
	// 다음과 같이 사용한다.
	// rawData[x * bytesPerRow  + y * bytesPerPixel]
}


// If our view is resized, we'll be asked to layout subviews.
// This is the perfect opportunity to also update the framebuffer so that it is
// the same size as our display area.
-(void)layoutSubviews
{
	[EAGLContext setCurrentContext:context];
	[self destroyFramebuffer];
	[self createFramebuffer];
	
	// Clear the framebuffer the first time it is allocated
	if (needsErase) {
		[self erase];
		needsErase = NO;
	}
}

- (BOOL)createFramebuffer
{
	// Generate IDs for a framebuffer object and a color renderbuffer
	glGenFramebuffersOES(1, &viewFramebuffer);
	glGenRenderbuffersOES(1, &viewRenderbuffer);
	
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
	// This call associates the storage for the current render buffer with the EAGLDrawable (our CAEAGLLayer)
	// allowing us to draw into a buffer that will later be rendered to screen wherever the layer is (which corresponds with our view).
	[context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:(id<EAGLDrawable>)self.layer];
	glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, viewRenderbuffer);
	
	glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &backingWidth);
	glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &backingHeight);
	
	// For this sample, we also need a depth buffer, so we'll create and attach one via another renderbuffer.
	glGenRenderbuffersOES(1, &depthRenderbuffer);
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, depthRenderbuffer);
	glRenderbufferStorageOES(GL_RENDERBUFFER_OES, GL_DEPTH_COMPONENT16_OES, backingWidth, backingHeight);
	glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_DEPTH_ATTACHMENT_OES, GL_RENDERBUFFER_OES, depthRenderbuffer);
	
	if(glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES)
	{
		return NO;
	}
	
	return YES;
}

// Clean up any buffers we have allocated.
- (void)destroyFramebuffer
{
	glDeleteFramebuffersOES(1, &viewFramebuffer);
	viewFramebuffer = 0;
	glDeleteRenderbuffersOES(1, &viewRenderbuffer);
	viewRenderbuffer = 0;
	
	if(depthRenderbuffer)
	{
		glDeleteRenderbuffersOES(1, &depthRenderbuffer);
		depthRenderbuffer = 0;
	}
}

// Releases resources when they are not longer needed.
- (void) dealloc
{
	if (brushTexture)
	{
		glDeleteTextures(1, &brushTexture);
		brushTexture = 0;
	}
	
	if([EAGLContext currentContext] == context)
	{
		[EAGLContext setCurrentContext:nil];
	}
	
	[context release];
	
	[bufferXArray release];
	[bufferYArray release];
	[super dealloc];
}

// Erases the screen
- (void) erase
{
	[EAGLContext setCurrentContext:context];
	
	//Clear the buffer
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
	glClearColor(1.0, 1.0, 1.0, 0.0);
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	
	const GLfloat vertices[] = {
		0.0f,	0.0f,
		self.frame.size.width, 0.0f,
		0.0f,	self.frame.size.height,
		self.frame.size.width, self.frame.size.height,
	};
	
	const GLubyte verticeColor[] = {
		255,255,255,0,
		255,255,255,0,
		255,255,255,0,
		255,255,255,0,
	};
	
	glVertexPointer(2, GL_FLOAT, 0, vertices);
	glColorPointer(4, GL_UNSIGNED_BYTE, 0, verticeColor);
	glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
	
	
	
	//Display the buffer
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
    glClearColor(0.0, 0.0, 0.0, 0.0);
    glClearDepthf(0.0);
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

	[context presentRenderbuffer:GL_RENDERBUFFER_OES];
}



- (void)drawPoint:(CGPoint)point
{
	static GLfloat*	vertexBuffer = NULL;
	static GLfloat* vertexColor = NULL;
	
	GLfloat color[4]; 
	glGetFloatv(GL_CURRENT_COLOR, color);
	
	
	[EAGLContext setCurrentContext:context];
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
	if(vertexBuffer == NULL)
	{
		vertexBuffer = malloc(10 * 2 * sizeof(GLfloat));
		vertexColor = malloc(10 * 4 * sizeof(GLfloat));
	}
	
	for(int i=0;i<10;i++){
		vertexBuffer[2*i+0] = point.x;
		vertexBuffer[2*i+1] = point.y;
		vertexColor[4*i+0] = color[0];
		vertexColor[4*i+1] = color[1];
		vertexColor[4*i+2] = color[2];
		vertexColor[4*i+3] = color[3];
	}
	
	glVertexPointer(2, GL_FLOAT, 0, vertexBuffer);
	glColorPointer(4, GL_FLOAT, 0, vertexColor);
	glDrawArrays(GL_POINTS, 0, 10);
	
	//Display the buffer
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
	[context presentRenderbuffer:GL_RENDERBUFFER_OES];
	
}



// Handles the start of a touch
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	CGRect				bounds = [self bounds];
    UITouch*	touch = [[event touchesForView:self] anyObject];
	firstTouch = YES;
	//Convert touch point from UIView referential to OpenGL one (upside-down flip)
	location = [touch locationInView:self];
	location.y = bounds.size.height - location.y;
	
	if(isErase) {
		glPointSize(30.0f);
		//		glDisable(GL_BLEND);
		//		glDisable(GL_TEXTURE_2D);
	}
	else {
		glPointSize(5.0f);
		//		glEnable(GL_BLEND);
		//		glEnable(GL_TEXTURE_2D);
	}
	
	
	//input first point to bufferArray
	
	[bufferXArray addObject:[NSNumber numberWithInt:location.x]];
	[bufferYArray addObject:[NSNumber numberWithInt:location.y]];
	
	
	
}

// Handles the continuation of a touch.
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{  
	
	CGRect				bounds = [self bounds];
	UITouch*			touch = [[event touchesForView:self] anyObject];
	
	//Convert touch point from UIView referential to OpenGL one (upside-down flip)
	if (firstTouch) {
		firstTouch = NO;
	} 
	
	location = [touch locationInView:self];
	location.y = bounds.size.height - location.y;
	previousLocation = [touch previousLocationInView:self];
	previousLocation.y = bounds.size.height - previousLocation.y;
	
	
	// bufferArray must have exactly 3 points
	
	if([bufferXArray count] ==3){
		
		[bufferXArray removeObjectAtIndex:0];
		[bufferYArray removeObjectAtIndex:0];
		
	}
	
	[bufferXArray addObject:[NSNumber numberWithInt:location.x]];
	[bufferYArray addObject:[NSNumber numberWithInt:location.y]];
	
	if([bufferXArray count] == 3){
		[self renderHermiteCurveWithXArray:bufferXArray YArray:bufferYArray];
	}
	
	
}

// Handles the end of a touch  event when the touch is a tap.
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	//	//NSLog(@"touchesEnded");
	CGRect				bounds = [self bounds];
    UITouch*	touch = [[event touchesForView:self] anyObject];
	
	
	
	if (firstTouch) {
		firstTouch = NO;
		previousLocation = [touch previousLocationInView:self];
		previousLocation.y = bounds.size.height - previousLocation.y;
		//		[self renderLineFromPoint:previousLocation toPoint:location];
		if([bufferXArray count] ==3){
			
			[bufferXArray removeObjectAtIndex:0];
			[bufferYArray removeObjectAtIndex:0];
			
		}
		
		[bufferXArray addObject:[NSNumber numberWithInt:location.x]];
		[bufferYArray addObject:[NSNumber numberWithInt:location.y]];
		
		if([bufferXArray count] == 3){
			[self renderHermiteCurveWithXArray:bufferXArray YArray:bufferYArray];
		}
		else{
			[self drawPoint:location];
			
		}
	}
	
	// Clean all buffers for next touch
	
	[bufferXArray removeAllObjects];
	[bufferYArray removeAllObjects];
	slopeX = 0.0;
	slopeY = 0.0;
	
	//	CGRect myRect = self.frame;
	//	NSInteger myDataLength = myRect.size.width * myRect.size.height * 4;
	//	GLubyte *buffer = (GLubyte *) malloc(myDataLength);
	//	glReadPixels(myRect.origin.x, myRect.origin.y, myRect.size.width, myRect.size.height, GL_RGBA, GL_UNSIGNED_BYTE, buffer);
	
	//	for(int i=0;i<20000;i=i+4){
	//		
	//		//NSLog(@"data[%d] = %d \t data[%d] = %d \t data[%d] = %d \t data[%d] = %d",
	//			  i,buffer[i],i+1,buffer[i+1],i+2,buffer[i+2],i+3,buffer[i+3]);
	//	}
	
	//Display the buffer
	//	glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
	//	[context presentRenderbuffer:GL_RENDERBUFFER_OES];
	
}

// Handles the end of a touch event.
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	// If appropriate, add code necessary to save the state of the application.
	// This application is not saving state.
}


- (void)saveImage:(CGRect)myRect{
	
	
	//create UIImage
	
	UIImage *image = [[UIImage alloc] init];
	image = [self drawableToCGImage:myRect];
	//	//NSLog(@"%@",image);
	
	
	
	// save image to png file
	
	NSData *data = UIImagePNGRepresentation(image);
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,  YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"currentImageFile.png"]];
	//	//NSLog(@"fullPath : %@",fullPath);
	[fileManager createFileAtPath:fullPath contents:data attributes:nil];
	
	
}

- (GLubyte *)getImageBuffer:(CGRect)myRect
{
	NSInteger myDataLength = myRect.size.width * myRect.size.height * 4;
	GLubyte *buffer = (GLubyte *) malloc(myDataLength);
	glReadPixels(myRect.origin.x, myRect.origin.y, myRect.size.width, myRect.size.height, GL_RGBA, GL_UNSIGNED_BYTE, buffer);
	
	//upside down
	
	GLubyte *buffer2 = (GLubyte *) malloc(myDataLength);
	
	int x,y;
	
	for(y=0;y<myRect.size.height;y++){
		
		for(x=0;x<myRect.size.width*4;x++){
			NSInteger buff1 = y * 4 * myRect.size.width + x;
			NSInteger buff2 = (myRect.size.height - 1 - y) * myRect.size.width * 4 + x;
			buffer2[buff2] = buffer[buff1];
		}
		
	}

    for(int i=0;i<myRect.size.width * myRect.size.height * 4;i++){
        buffer[i] = buffer2[i];
    }

//    for(int i=0;i<320*460;i++){
//        NSLog(@"buffer[%d] = %d %d %d %d",4*i,*(buffer+4*i),*(buffer+4*i+1),*(buffer+4*i+2),*(buffer+4*i+3));
//    }
    
    return buffer;
}

//2nd version
- (UIImage *) drawableToCGImage:(CGRect)myRect {
	
	
	UIImage *myImage;
	NSInteger myDataLength = myRect.size.width * myRect.size.height * 4;
	GLubyte *buffer = (GLubyte *) malloc(myDataLength);
	glReadPixels(myRect.origin.x, myRect.origin.y, myRect.size.width, myRect.size.height, GL_RGBA, GL_UNSIGNED_BYTE, buffer);
	
	//upside down
	
	GLubyte *buffer2 = (GLubyte *) malloc(myDataLength);
	
	int x,y;
	
	for(y=0;y<myRect.size.height;y++){
		
		for(x=0;x<myRect.size.width*4;x++){
			NSInteger buff1 = y*4*myRect.size.width+x;
			NSInteger buff2 = (myRect.size.height-1-y)*myRect.size.width*4+x;
			buffer2[buff2] = buffer[buff1];
		}
		
	}
	
	//make data provider
	
	int bitsPerComponent = 8;
    int bitsPerPixel = 32;
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
	int bytesPerRow,i;
	
	CGDataProviderRef provider;
	CGImageRef imageRef;
	
    NSLog(@"orietiontion:%d", [UIDevice currentDevice].orientation);
	switch ([UIDevice currentDevice].orientation) {
		case 0:
			bytesPerRow = 4 * myRect.size.width;
			for(i=0;i<myRect.size.width*myRect.size.height*4;i++){
				buffer[i] = buffer2[i];
			}
			
			provider = CGDataProviderCreateWithData(NULL, buffer, myDataLength, NULL);
			
			// make the cgimageref
			imageRef = CGImageCreate(myRect.size.width, myRect.size.height, bitsPerComponent, bitsPerPixel, bytesPerRow, colorSpaceRef, bitmapInfo, provider, NULL, NO, renderingIntent);
			
			//make the uiimage from that
			myImage = [UIImage imageWithCGImage:imageRef];
			
			CGDataProviderRelease(provider);
			CGImageRelease(imageRef);
			
			break;
			
		case 2:
			bytesPerRow = 4 * myRect.size.width;
			for(x=0;x<myRect.size.height;x++){
				for(y=0;y<myRect.size.width;y++){
					NSInteger buff = (x + y*myRect.size.height)*4;
					NSInteger buff2 = ((myRect.size.height-x)*myRect.size.width + (myRect.size.width-y))*4;
					buffer[buff] = buffer2[buff2];
					buffer[buff+1] = buffer2[buff2+1];
					buffer[buff+2] = buffer2[buff2+2];
					buffer[buff+3] = buffer2[buff2+3];
					
				}
			}
			provider = CGDataProviderCreateWithData(NULL, buffer, myDataLength, NULL);
			
			// make the cgimageref
			
			imageRef = CGImageCreate(myRect.size.height, myRect.size.width, bitsPerComponent, bitsPerPixel, bytesPerRow, colorSpaceRef, bitmapInfo, provider, NULL, NO, renderingIntent);
			
			//make the uiimage from that
			myImage = [UIImage imageWithCGImage:imageRef];
			
			CGDataProviderRelease(provider);
			CGImageRelease(imageRef);
			break;
			
		case 3:
			bytesPerRow = 4 * myRect.size.height;
			for(x=0;x<myRect.size.height;x++){
				for(y=0;y<myRect.size.width;y++){
					NSInteger buff = (x + y*myRect.size.height)*4;
					NSInteger buff2 = (x*myRect.size.width + (myRect.size.width-y))*4;
					buffer[buff] = buffer2[buff2];
					buffer[buff+1] = buffer2[buff2+1];
					buffer[buff+2] = buffer2[buff2+2];
					buffer[buff+3] = buffer2[buff2+3];
					
				}
			}
			provider = CGDataProviderCreateWithData(NULL, buffer, myDataLength, NULL);
			
			// make the cgimageref
			
			imageRef = CGImageCreate(myRect.size.height, myRect.size.width, bitsPerComponent, bitsPerPixel, bytesPerRow, colorSpaceRef, bitmapInfo, provider, NULL, NO, renderingIntent);
			
			//make the uiimage from that
			myImage = [UIImage imageWithCGImage:imageRef];
			
			CGDataProviderRelease(provider);
			CGImageRelease(imageRef);
			break;
			
		case 4:
			bytesPerRow = 4 * myRect.size.height;
			for(x=0;x<myRect.size.height;x++){
				for(y=0;y<myRect.size.width;y++){
					NSInteger buff = (x + y*myRect.size.height)*4;
					NSInteger buff2 = ((myRect.size.height-x)*myRect.size.width + y)*4;
					buffer[buff] = buffer2[buff2];
					buffer[buff+1] = buffer2[buff2+1];
					buffer[buff+2] = buffer2[buff2+2];
					buffer[buff+3] = buffer2[buff2+3];
					
				}
			}
			provider = CGDataProviderCreateWithData(NULL, buffer, myDataLength, NULL);
			
			// make the cgimageref
			
			imageRef = CGImageCreate(myRect.size.height, myRect.size.width, bitsPerComponent, bitsPerPixel, bytesPerRow, colorSpaceRef, bitmapInfo, provider, NULL, NO, renderingIntent);
			
			//make the uiimage from that
			myImage = [UIImage imageWithCGImage:imageRef];
			
			CGDataProviderRelease(provider);
			CGImageRelease(imageRef);
			break;
			
		default:
			bytesPerRow = 4 * myRect.size.width;
			for(i=0;i<myRect.size.width*myRect.size.height*4;i++){
				buffer[i] = buffer2[i];
			}
			
			provider = CGDataProviderCreateWithData(NULL, buffer, myDataLength, NULL);
			
			// make the cgimageref
			imageRef = CGImageCreate(myRect.size.width, myRect.size.height, bitsPerComponent, bitsPerPixel, bytesPerRow, colorSpaceRef, bitmapInfo, provider, NULL, NO, renderingIntent);
			
			//make the uiimage from that
			myImage = [UIImage imageWithCGImage:imageRef];
			
			CGDataProviderRelease(provider);
			CGImageRelease(imageRef);
			break;			
	}
	
//		for(i=0;i<320*350;i++){
//			NSLog(@"buffer[%d] = %d %d %d %d",4*i,*(buffer+4*i),*(buffer+4*i+1),*(buffer+4*i+2),*(buffer+4*i+3));
//        }
	
	
	return myImage;
}

// New function to draw Hermite Curve

- (void)renderHermiteCurveWithXArray:(NSArray *)xArray YArray:(NSArray *)yArray{
	
	//	//NSLog(@"renderHermiteCurve X:%@ , Y:%@",xArray,yArray);
	
	static GLfloat*		vertexBuffer = NULL;
	static GLfloat*		vertexBufferForAA = NULL;
	static GLfloat*		vertexColor = NULL;
	static NSUInteger	vertexMax = 16;
	NSUInteger			vertexCount = 0,count01,count12,i;
	CGFloat				x[3];
	CGFloat				y[3];
	CGFloat				t;
	
	x[0] = [[xArray objectAtIndex:0] floatValue];
	x[1] = [[xArray objectAtIndex:1] floatValue];
	x[2] = [[xArray objectAtIndex:2] floatValue];
	
	y[0] = [[yArray objectAtIndex:0] floatValue];
	y[1] = [[yArray objectAtIndex:1] floatValue];
	y[2] = [[yArray objectAtIndex:2] floatValue];
	
	
	
	[EAGLContext setCurrentContext:context];
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
	
	GLfloat color[4]; 
	glGetFloatv(GL_CURRENT_COLOR, color);
	//	//NSLog(@"current color => %f \t %f \t %f \t %f",color[0],color[1],color[2],color[3]);
	
	//	if(isErase) {
	//		color[0] = 1.0f;
	//		color[1] = 1.0f;
	//		color[2] = 1.0f;
	//		color[3] = 0.0f;
	//	}
	
	
	//Allocate vertex array buffer
	if(vertexBuffer == NULL){
		vertexBuffer = malloc(vertexMax * 3 * sizeof(GLfloat));
		vertexColor = malloc(vertexMax*4*sizeof(GLfloat));
		vertexBufferForAA = malloc(vertexMax * 2 * kAARoundCount * sizeof(GLfloat));
	}
	
	//Compute distances between points
	count01 = MAX(ceilf(sqrtf((x[1] - x[0]) * (x[1] - x[0]) + (y[1] - y[0]) * (y[1] - y[0])) / kBrushPixelStep)*2.5, 1);
	count12 = MAX(ceilf(sqrtf((x[2] - x[1]) * (x[2] - x[1]) + (y[2] - y[1]) * (y[2] - y[1])) / kBrushPixelStep)*2.5, 1);
	t = (GLfloat)count01 / ((GLfloat)count01+(GLfloat)count12);
	CGFloat largeT = 1/(t*t - t*t*t);
	
	
	//Add points to the buffer so there are drawing points every pixels
	
	vertexBuffer[0] = x[0];
	vertexBuffer[1] = y[0];
	vertexBuffer[2] = 1.0f;
	vertexColor[0] = color[0];
	vertexColor[1] = color[1];
	vertexColor[2] = color[2];
	vertexColor[3] = color[3];
	vertexCount += 1;
	
	for(i = 0; i < count01; ++i) {
		if(vertexCount+1 == vertexMax) {
			vertexMax = 2 * vertexMax;
			vertexBuffer = realloc(vertexBuffer, vertexMax * 3 * sizeof(GLfloat));
			vertexColor = realloc(vertexColor, vertexMax*4*sizeof(GLfloat));
			vertexBufferForAA = realloc(vertexBufferForAA, vertexMax * 2 * kAARoundCount * sizeof(GLfloat));
		}
		
		CGFloat u = (GLfloat)i/((GLfloat)count01+(GLfloat)count12);
		vertexBuffer[3 * vertexCount + 0] = x[0]*( 1 + (t*t*t-1)*largeT*u*u + (1-t*t)*largeT*u*u*u ) + slopeX*( u + (t*t*t-t)*largeT*u*u + (t-t*t)*largeT*u*u*u )
		+ x[1]*( largeT*u*u - largeT*u*u*u ) + x[2]*( t*t*largeT*u*u*u - t*t*t*largeT*u*u );
		vertexBuffer[3 * vertexCount + 1] = y[0]*( 1 + (t*t*t-1)*largeT*u*u + (1-t*t)*largeT*u*u*u ) + slopeY*( u + (t*t*t-t)*largeT*u*u + (t-t*t)*largeT*u*u*u )
		+ y[1]*( largeT*u*u - largeT*u*u*u ) + y[2]*( t*t*largeT*u*u*u - t*t*t*largeT*u*u );
		vertexBuffer[3 * vertexCount + 2] = 1.0f;
		//		//NSLog(@"vertexBuffer[%d] = %f , %f",2*vertexCount +0,vertexBuffer[2*vertexCount +0],vertexBuffer[2*vertexCount +1]);
		
		
		vertexColor[4 * vertexCount + 0] = color[0];
		vertexColor[4 * vertexCount + 1] = color[1];
		vertexColor[4 * vertexCount + 2] = color[2];
		vertexColor[4 * vertexCount + 3] = color[3];
		
		
		//		CGPoint thisPoint = CGPointMake(vertexBuffer[2 * vertexCount + 0], vertexBuffer[2 * vertexCount + 1]);
		//		[self drawCircle:thisPoint withPointSize:2.0];
		
		
		vertexCount += 1;
	}
	
	
	slopeX = x[0]*( 2*t*(t*t*t-1)*largeT + 3*t*t*(1-t*t)*largeT ) + slopeX*( 1 + 2*t*(t*t*t-t)*largeT + 3*t*t*(t-t*t)*largeT )
	+ x[1]*( 2*t*largeT - 3*t*t*largeT ) + x[2]*t*t*t*t*largeT;
	slopeY = y[0]*( 2*t*(t*t*t-1)*largeT + 3*t*t*(1-t*t)*largeT ) + slopeY*( 1 + 2*t*(t*t*t-t)*largeT + 3*t*t*(t-t*t)*largeT )
	+ y[1]*( 2*t*largeT - 3*t*t*largeT ) + y[2]*t*t*t*t*largeT;
	
	//	//NSLog(@"next slope : %f , %f",slopeX,slopeY);
	
	
	//	//NSLog(@"start x : %f , end x : %f",start.x,end.x);
	
	
	
	glVertexPointer(3, GL_FLOAT, 0, vertexBuffer);
	glColorPointer(4, GL_FLOAT, 0, vertexColor);
	
	
    glDrawArrays(GL_POINTS, 0, vertexCount);
	
	
	//	CGRect myRect = self.frame;
	//	NSInteger myDataLength = myRect.size.width * myRect.size.height * 4;
	//	GLubyte *buffer = (GLubyte *) malloc(myDataLength);
	//	glReadPixels(myRect.origin.x, myRect.origin.y, myRect.size.width, myRect.size.height, GL_RGBA, GL_UNSIGNED_BYTE, buffer);
	
	
	
	//Display the buffer
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
	[context presentRenderbuffer:GL_RENDERBUFFER_OES];
	
	
	
}


@end
