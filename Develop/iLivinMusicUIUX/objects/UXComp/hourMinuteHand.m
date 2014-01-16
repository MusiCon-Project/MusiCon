//
//  hourMinuteHand.m
//  iLivinMusicUIUX
//
//  Created by jaehoon lee on 4/1/12.
//  Copyright (c) 2012 Kaist. All rights reserved.
//

#import "hourMinuteHand.h"
#import "record.h"
@implementation hourMinuteHand
@synthesize curHourMinuteType;
@synthesize delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        origin = CGPointMake(recordLength / 2.0, recordLength / 2.0);
        
        self.layer.anchorPoint = CGPointMake(0.5, 0);
        self.layer.position = CGPointMake(frame.origin.x + 20, frame.origin.y);
        
        self.userInteractionEnabled = YES;
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

#pragma mark - Touch Event
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSArray *allTouches = [touches allObjects]; 
	int count = [allTouches count];
	if (count == 1) {
		touch = [[allTouches objectAtIndex:0] locationInView:[self superview]]; 
	}
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	NSArray *allTouches = [touches allObjects]; 
	int count = [allTouches count]; 
    
	if (count == 1) 
    {
        {
            currentTouch = [[allTouches objectAtIndex:0] locationInView:[self superview]]; 
            CGFloat previousAngle = atan2(touch.y - origin.x, touch.x - origin.y) * 180 / M_PI;
			CGFloat currentAngle = atan2(currentTouch.y - origin.x, currentTouch.x - origin.y) * 180 / M_PI;
            
            NSLog(@"currentAngle:%f",currentAngle);
            
            if(curHourMinuteType == TimerHourType)
            {
//                if (currentAngle > 180.0 - 45.0/2.0) {
//                    currentAngle = 180.0 - 45.0/2.0;
//                }
            }
            else if(curHourMinuteType == AlarmHourType)
            {
                
            }
            else if(curHourMinuteType == AlarmMinuteType)
            {
                
            }
            NSLog(@"currentAngle:%f",currentAngle);
            
			CGFloat angleToRotate = currentAngle - previousAngle;
            
			self.transform = CGAffineTransformRotate(self.transform, DEGREES_TO_RADIANS(angleToRotate));
			touch = currentTouch;
            
            double minuteAngle = atan2(self.transform.b, self.transform.d) * 180 / M_PI;
            [delegate minuteHandChanged:minuteAngle];
            
            if(curHourMinuteType == AlarmHourType)
            {
                
            }
            else if(curHourMinuteType == AlarmMinuteType)
            {
                
            }
		}
	}
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSArray *allTouches = [touches allObjects]; 
	int count = [allTouches count]; 
    
	if (count == 1) 
    {
        
        double divisionAngle;
        //음수 고려해주지 않게 위해서 180.0 더함. 180 > x > -180 이었음
        if(curHourMinuteType == TimerHourType)
        {
            divisionAngle = 45.0/2.0;
            double angle = atan2(self.transform.b, self.transform.d) * 180 / M_PI;
            if (angle > 180.0 - divisionAngle) {
                angle = 180.0 - divisionAngle;
            }
            int num = (angle + 180)/ divisionAngle;
            double reminder = (angle + 180) - num * divisionAngle;
            
            if(reminder > 22.5/2.0)
                num++;
            
            NSLog(@"currentAngle:%f num:%d", num * divisionAngle, num);
            
            self.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(num * divisionAngle - 180));
            
        }
        else if(curHourMinuteType == AlarmHourType)
        {
            divisionAngle = 30.0;            
        }
        else if(curHourMinuteType == AlarmMinuteType)
        {
            divisionAngle = 30.0;            
        }
    }
}

@end
