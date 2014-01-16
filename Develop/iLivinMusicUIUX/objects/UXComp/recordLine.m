//
//  recordLine.m
//  iLivinMusicUIUX
//
//  Created by jaehoon lee on 2/28/12.
//  Copyright (c) 2012 Kaist. All rights reserved.
//

#import "recordLine.h"
#import <QuartzCore/QuartzCore.h>
#define DEGREES_TO_RADIANS(__ANGLE__) ((__ANGLE__) / 180.0 * M_PI)
@implementation recordLine
@synthesize delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.anchorPoint = CGPointMake(55/140.0, 22/175.0);
        self.layer.position = CGPointMake(frame.origin.x + 55/2.0, frame.origin.y + 22);
        
        NSLog(@"width : %f",frame.size.width);
        
        UIImageView * recordLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, recordLineWidth, recordLineHeight)];
        [recordLine setImage:[UIImage imageNamed:@"pop_yellow_lp_player_lp_stick.png"]];
        [self addSubview:recordLine];
        [recordLine release];
        
        transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(20));
        self.transform = transform;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)playMusicFinished
{
    if([delegate respondsToSelector:@selector(playMusicFinished)])
        [delegate playMusicFinished];
}

#pragma mark - touch events
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSArray *allTouches = [touches allObjects]; 
	int count = [allTouches count];
	if (count == 1) {
		touch = [[allTouches objectAtIndex:0] locationInView:[self superview]]; 
	}
    [[self superview] bringSubviewToFront:self];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSArray *allTouches = [touches allObjects]; 
    int count = [allTouches count];
    if (count == 1) {
        {
            currentTouch = [[allTouches objectAtIndex:0] locationInView:[self superview]]; 
            CGFloat angleToRotate = atan2(currentTouch.y - 10, currentTouch.x - 10) * 180 / M_PI - atan2(touch.y - 10, touch.x - 10) * 180 / M_PI;
            CGFloat angle = atan2(transform.b, transform.d) * 180 / M_PI;
            
            if ((angle-10)*(angle-10)*(angle-10)/100+10 + angleToRotate < 0) {
                transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(0));
            } else if ((angle-10)*(angle-10)*(angle-10)/100+10 + angleToRotate > 20) {
                transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(20));
            } else {
                transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(cbrt(100*((angle-10)*(angle-10)*(angle-10)/100+angleToRotate))+10));
                touch = currentTouch;
            }
            
            self.transform = transform;
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSArray *allTouches = [touches allObjects]; 
	int count = [allTouches count]; 
    
	if (count == 1)
    {
        CGFloat angle = atan2(transform.b, transform.d) * 180 / M_PI;
        if(angle > 10)
        {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.1];
            transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(20));
            self.transform = transform;
            [UIView commitAnimations];
         
            if([delegate respondsToSelector:@selector(stopMusic)])
                [delegate stopMusic];
        }
        else
        {

            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.1];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(playMusicFinished)];
            transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(0));
            self.transform = transform;
            [UIView commitAnimations];
            
            if([delegate respondsToSelector:@selector(playMusic)])
                [delegate playMusic];
        }
    }
}

@end
