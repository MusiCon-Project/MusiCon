//
//  utilButton.m
//  iLivinMusicUIUX
//
//  Created by jaehoon lee on 3/25/12.
//  Copyright (c) 2012 Kaist. All rights reserved.
//

#import "utilButton.h"
#import "UserDefaultHelper.h"
#import "iLivinMusicMainViewController.h"

#define recordMargin 5
#define recordLength 250

#define HistoryHeaderHeight 10
#define HistoryHeaderLineLength 100

@implementation utilButton
@synthesize activated;
@synthesize _buttonType;
@synthesize Record = _record;
- (id)initWithFrame:(CGRect)frame withButtonType:(recordType)btnType buttonPos:(buttonPos)bPos
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        if(btnType == TimerType)
            [self addTarget:self action:@selector(timerButtonOnAction) forControlEvents:UIControlEventTouchUpInside];
        else
            [self addTarget:self action:@selector(alarmButtonOnAction) forControlEvents:UIControlEventTouchUpInside];
        
        _buttonType = btnType;
        
        if(_buttonType == RecordType)
            activated = [[AudioHelper sharedObject] getPlayState];
        else if(_buttonType == AlarmType)
            activated = [UserDefaultHelper getAlarmState];
        else
            activated = [UserDefaultHelper getTimerState];
        _buttonPos = bPos;
                
        buttonEventReceived = NO;
        [self setButtonImageWithType:_buttonType];
        
        //Auto Image
        AutoImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, 20, 9)];
        [self addSubview:AutoImage];
        [AutoImage release];
        [self setAutoImage];
        
    }
    return self;
}

- (void)setButtonImageWithType:(recordType)preRecordType
{
    switch (preRecordType) 
    {
        case TimerType:
            if(activated)
                [self setImage:[UIImage imageNamed:@"pop_yellow_small_timer.png"] forState:UIControlStateNormal]; 
            else
                [self setImage:[UIImage imageNamed:@"pop_yellow_small_timer_off.png"] forState:UIControlStateNormal]; 
            break;
        case AlarmType:
            if(activated)
                [self setImage:[UIImage imageNamed:@"pop_yellow_small_alarm.png"] forState:UIControlStateNormal]; 
            else
                [self setImage:[UIImage imageNamed:@"pop_yellow_small_alarm_off.png"] forState:UIControlStateNormal];             
            break;
        case RecordType:
            activated = [[AudioHelper sharedObject] getPlayState];
            if(activated)
                [self setImage:[UIImage imageNamed:@"pop_yellow_small_lp_player.png"] forState:UIControlStateNormal]; 
            else
                [self setImage:[UIImage imageNamed:@"pop_yellow_small_lp_player_off.png"] forState:UIControlStateNormal];             
            break;
        default:
            break;
    }

    [self setAutoImage];
}

- (void)setAutoImage
{
    BOOL autoBool;
    [AutoImage setHidden:NO];
    if(_buttonType == TimerType)
         autoBool = [UserDefaultHelper getAutoTimerState];
    else if(_buttonType == AlarmType)
         autoBool = [UserDefaultHelper getAutoAlarmState];
    else 
    {
        [AutoImage setHidden:YES];
        return;
    }
 
    if(activated == YES)
    {
        if (autoBool) 
            [AutoImage setImage:[UIImage imageNamed:@"pop_yellow_small_auto_on"]];
        else
            [AutoImage setHidden:YES];
    }
    else 
    {
        if (autoBool) 
            [AutoImage setImage:[UIImage imageNamed:@"pop_yellow_small_auto_off"]];
        else
            [AutoImage setHidden:YES];

    }
    NSLog(@"%d %d", activated, autoBool);
}

#pragma mark - touch events
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self setHighlighted:YES];
    NSArray *allTouches = [touches allObjects]; 
    int count = [allTouches count];
    if (count == 1) {
        touch = [[allTouches objectAtIndex:0] locationInView:[self superview]]; 
        initialTouch = touch;
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
            CGFloat dx = currentTouch.x - touch.x;
            CGFloat dy = currentTouch.y - touch.y;
            
            self.frame = CGRectMake(self.frame.origin.x + dx, self.frame.origin.y + dy, self.frame.size.width, self.frame.size.height);
            
            touch = currentTouch;
        }
    } 
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self setHighlighted:NO];
    NSArray *allTouches = [touches allObjects]; 
    int count = [allTouches count]; 
    if(count == 1)
    {
        CGFloat distan = sqrt(pow((touch.x - initialTouch.x), 2) + pow((touch.y - initialTouch.y), 2));
        if(distan < 10)
            buttonEventReceived = YES;
        
        if(buttonEventReceived)
        {
            activated = !activated;
            if(_buttonType == AlarmType)
                [UserDefaultHelper setAlarmState:activated];
            else if(_buttonType == TimerType)
                [UserDefaultHelper setTimerState:activated];
            [self setButtonImageWithType:_buttonType];
            buttonEventReceived = NO;
        }
        else
        {        
            recordType preRecordType =  _record.curRecordType; //Temporal save For Record Type
            NSLog(@"Pre1:%d", preRecordType);
            if (CGRectContainsPoint(CGRectMake((320 - recordLength) / 2, recordMargin, recordLength, recordLength), [[allTouches objectAtIndex:0] locationInView:[self superview]]))
            {
                if(_buttonType == TimerType)
                {
                    [_record setBoardToTimerUI:activated];
                }
                else if(_buttonType == AlarmType)
                {
                    [_record setBoardToAlarmUI:activated]; 
                }
                else
                {
                    [_record setBoardToRecordUI];
                }
            }
            
            [_record reloadTableView];
            [UserDefaultHelper setCurrentRecordType:_record.curRecordType];
            if(preRecordType == AlarmType)
                activated = [UserDefaultHelper getAlarmState];
            else if(preRecordType == TimerType)
                activated = [UserDefaultHelper getTimerState];  
            NSLog(@"Pre2:%d", preRecordType);
            _buttonType = preRecordType;
            [self setButtonImageWithType:preRecordType];
        }
        
        if(_buttonPos == LeftButton)
        {    
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationDelegate:self];
            self.frame = CGRectMake(timeButtonMargin, 200, 50, 59);
            [UIView commitAnimations ];
        }
        else
        {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationDelegate:self];
            self.frame = CGRectMake(albumOriginX - timeButtonMargin - 50, 200, 50, 59);
            [UIView commitAnimations ];
        }
    }
//    else
//    {
//        activated = !activated;        
//        [self setButtonImageWithType:_buttonType];
//    }
}
@end
