//
//  sliderButton.m
//  iLivinMusicUIUX
//
//  Created by jaehoon lee on 7/21/12.
//  Copyright (c) 2012 Kaist. All rights reserved.
//

#import "sliderButton.h"
#import "iLivinMusicMainViewController.h"

@implementation sliderButton
@synthesize delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#pragma mark - touch events
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSArray *allTouches = [touches allObjects]; 
	int count = [allTouches count]; 

    if (count == 1) {
        currentTouch = [[allTouches objectAtIndex:0] locationInView:[[self superview] superview]];
        [self setHighlighted:YES];
        [delegate touchesBegan:currentTouch];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSArray *allTouches = [touches allObjects]; 
	int count = [allTouches count]; 
    
	if (count == 1) {
        currentTouch = [[allTouches objectAtIndex:0] locationInView:[[self superview] superview]];
        [delegate touchesMoved:currentTouch];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self setHighlighted:NO];
    [delegate touchesEnded];
//    [delegate slideButtonOnAction:self];
}
@end
