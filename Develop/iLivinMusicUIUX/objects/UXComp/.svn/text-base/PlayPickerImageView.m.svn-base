//
//  PlayPickerImageView.m
//  iLivinMusicUIUX
//
//  Created by jaehoon lee on 3/28/12.
//  Copyright (c) 2012 Kaist. All rights reserved.
//

#import "PlayPickerImageView.h"
#import "iLivinMusicMainViewController.h"
#import "record.h"
#define RADIAN_TO_DEGREE(__RAD__) ((__RAD__) * 180.0)
#define DEGREES_TO_RADIANS(__ANGLE__) ((__ANGLE__) / 180.0 * M_PI)


@implementation PlayPickerImageView
@synthesize record = _record;
@synthesize totalPlaytime;
@synthesize origin;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        radius = (recordLength - recordSizeDiff)/ 2.0;
        origin = CGPointMake(recordLength / 2.0, recordLength / 2.0);
        
        playPicker = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 20)];
        [playPicker setImage:[UIImage imageNamed:@"pop_yellow_playing_position_picker_yellow.png"]];
        [self addSubview:playPicker];
        [playPicker release];
        
        self.userInteractionEnabled = YES;
        
        preRadian = atan2(frame.origin.y - origin.y, frame.origin.x  - origin.x);
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

#pragma mark - touch events
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSArray *allTouches = [touches allObjects]; 
	int count = [allTouches count];
	if (count == 1) {
//		touch = [[allTouches objectAtIndex:0] locationInView:[self superview]]; 
	}
    [[self superview] bringSubviewToFront:self];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	NSArray *allTouches = [touches allObjects]; 
	int count = [allTouches count]; 
    
	if (count == 1) 
    {        
        double angle = atan2(self.transform.b, self.transform.d) * 180 / M_PI;
        currentTouch = [[allTouches objectAtIndex:0] locationInView:[self superview]]; 
        double radian = atan2(currentTouch.y - origin.y, currentTouch.x - origin.x);        
        
        NSLog(@"check:%f %f %f %f", RADIAN_TO_DEGREE(radian), angle, DEGREES_TO_RADIANS(-finalPlayPickerDegree), (preRadian - radian));
        
        if(angle > -initialPlayPickerDegree) //최초 Limit (시작점)
        {
            if(!((preRadian - radian) > 0))
            {
//                self.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(-initialPlayPickerDegree));
                self.center = CGPointMake(radius * cos(DEGREES_TO_RADIANS(-initialPlayPickerDegree)+ M_PI_2) + origin.x , radius * sin(DEGREES_TO_RADIANS(-initialPlayPickerDegree) + M_PI_2) + origin.y);
                return;
            }
        }
        else if(angle < -finalPlayPickerDegree) //마지막 Limit
        {
           if(!((preRadian - radian) < 0))
           {
//               NSLog(@"%f %f",DEGREES_TO_RADIANS(initialPlayPickerDegree * 2) - M_PI_2, DEGREES_TO_RADIANS(-finalPlayPickerDegree ));
//                self.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(-26.0) - M_PI_2);
                self.center = CGPointMake(radius * cos(DEGREES_TO_RADIANS(-finalPlayPickerDegree )+ M_PI_2) + origin.x , radius * sin(DEGREES_TO_RADIANS(-finalPlayPickerDegree)+ M_PI_2) + origin.y);
                return;
           }
        }
        
        self.transform = CGAffineTransformMakeRotation(M_PI + M_PI_2 + radian);
        self.center = CGPointMake(radius * cos(radian) + origin.x , radius * sin(radian) + origin.y);
        preRadian = radian;
        touchUpAngle = angle + M_PI_2;
	}
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSArray *allTouches = [touches allObjects]; 
	int count = [allTouches count]; 
    if(count == 1)
    {
        double angle = atan2(self.transform.b, self.transform.d) * 180 / M_PI;
        double playPoint = (-1 * angle - initialPlayPickerDegree) / (finalPlayPickerDegree - initialPlayPickerDegree);

        if(playPoint < 0)
            playPoint = 0;
        if(playPoint > 1)
            playPoint = 1;
        
        MPMusicPlayerController * musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
        musicPlayer.currentPlaybackTime = playPoint * totalPlaytime;
        [_record setPlayTime:totalPlaytime curTime:playPoint * totalPlaytime];
        NSLog(@"finalAngle:%f %f %f %f", playPoint * totalPlaytime, playPoint, musicPlayer.currentPlaybackTime, totalPlaytime);
    }
    
}
@end
