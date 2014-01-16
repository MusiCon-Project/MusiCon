//
//  record.m
//  iLivinMusicUIUX
//
//  Created by jaehoon lee on 2/22/12.
//  Copyright (c) 2012 Kaist. All rights reserved.
//

#import "record.h"
#import "LocalPushHelper.h"
#import "iLivinMusicMainViewController.h"
@interface record (internal)
- (void)setPlayPickerPosition:(double)degree;
- (void)addDefaultViewComp;
- (void)startRecordTimer;
- (void)stopRecordTimer;
@end

@implementation record
@synthesize curRecordType;
@synthesize recordBoard;
@synthesize RecordLine = _recordLine;
@synthesize selAlbum;
@synthesize limitTime;
@synthesize parentViewCon;
@synthesize albumSelected;
- (id)initWithFrame:(CGRect)frame type:(recordType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self addDefaultViewComp];
        curRecordType = type;
        if(type == RecordType)
        {
            [self setBoardToRecordUI];
        }else if(type == TimerType)
        {
            [self setBoardToTimerUI:YES];
        }else if(type == AlarmType)
        {
            [self setBoardToAlarmUI:YES];            
        }
        
        self.userInteractionEnabled = YES;
        albumSelected = NO;
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

#pragma mark - UIMethod
- (void)addDefaultViewComp
{
    recordDefaultBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, recordLength, recordLength)];
    [self addSubview:recordDefaultBg];
    [recordDefaultBg release];
    
    recordBoard = [[UIImageView alloc] initWithFrame:CGRectMake(recordSizeDiff/2, recordSizeDiff/2, recordLength - recordSizeDiff, recordLength - recordSizeDiff)];
    recordBoardlayer = [recordBoard layer];
    [recordBoardlayer setMasksToBounds:YES];
    [recordBoardlayer setCornerRadius:(recordLength - recordSizeDiff)/2];
    [self addSubview:recordBoard];
    [recordBoard release];
    
    recordBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, recordLength, recordLength)];
    [self addSubview:recordBg];
    [recordBg release];
    
    playPicker = [[PlayPickerImageView alloc] initWithFrame:CGRectMake(recordLength / 2.0 - 10, (recordLength - 20) - 10, 35, 40)];
    playPicker.record = self;
    [self addSubview:playPicker];
    [playPicker release];
    
    emotionButton = [[UIButton alloc] initWithFrame:CGRectMake(185, 30, 20, 20)];
    [emotionButton setImage:[UIImage imageNamed:@"pop_yellow_like_cloud.png"] forState:UIControlStateNormal];
    [emotionButton addTarget:self action:@selector(emotionButton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:emotionButton];
    [emotionButton release];
    
    _hourHand = [[hourMinuteHand alloc] initWithFrame:CGRectMake(recordLength/2.0 - 20, recordLength/2.0, 40.0, 130.0)];
    [self addSubview:_hourHand];
    [_hourHand release];
    
    _minuteHand = [[hourMinuteHand alloc] initWithFrame:CGRectMake(recordLength/2.0 - 20, recordLength/2.0, 40.0, 130.0)];
    _minuteHand.delegate = self;
    [self addSubview:_minuteHand];
    [_minuteHand release];
}

- (void)setBoardToRecordUI
{
    curRecordType = RecordType;
    [recordBg setImage:[UIImage imageNamed:@"pop_yellow_lp_player.png"]];
    [recordDefaultBg setImage:[UIImage imageNamed:@"pop_yellow_lp_player_lp_default.png"]];
    [emotionButton setHidden:NO];
    [playPicker setHidden:NO];
    [_hourHand setHidden:YES];
    [_minuteHand setHidden:YES];
    [_recordLine setHidden:NO];
        
    [self setPlayPickerPosition:initialPlayPickerDegree];
    degree = 0;
    playDegree = initialPlayPickerDegree;
    isPlaying = NO;
    playTimer = nil;
}

- (void)setBoardToTimerUI:(BOOL)activated
{
    curRecordType = TimerType;
    NSLog(@"__activated__:%d", activated);
    _hourHand.curHourMinuteType = TimerHourType;
    if(activated == YES)
        [recordBg setImage:[UIImage imageNamed:@"pop_yellow_timer.png"]];
    else 
        [recordBg setImage:[UIImage imageNamed:@"pop_yellow_timer_off.png"]];
    [playPicker setHidden:YES];
    [emotionButton setHidden:YES];
    [_hourHand setHidden:NO];
    [_minuteHand setHidden:YES];
    [_recordLine setHidden:YES];
    
    [_hourHand setImage:[UIImage imageNamed:@"pop_yellow_timer_picker_off.png"]];
    
    [self stopRecordTimer];
    
    UIButton * test = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [test addTarget:self action:@selector(timerTest) forControlEvents:UIControlEventTouchUpInside];
    test.frame = CGRectMake(200, 150, 20, 20);
    [self addSubview:test];
    
}

- (void)timerTest
{
    [self startRecordTimer];
}

- (void)setBoardToAlarmUI:(BOOL)activated
{
    curRecordType = AlarmType;
    _hourHand.curHourMinuteType = AlarmHourType;
    _hourHand.transform = CGAffineTransformRotate(_hourHand.transform, DEGREES_TO_RADIANS(-180));
    _minuteHand.curHourMinuteType = AlarmMinuteType;
    _minuteHand.transform = CGAffineTransformRotate(_minuteHand.transform, DEGREES_TO_RADIANS(-180));
    if(activated == YES)
        [recordBg setImage:[UIImage imageNamed:@"pop_yellow_alarm.png"]];
    else
        [recordBg setImage:[UIImage imageNamed:@"pop_yellow_alarm_off.png"]];
    [playPicker setHidden:YES];
    [emotionButton setHidden:YES];
    [_hourHand setHidden:NO];
    [_minuteHand setHidden:NO];
    [_recordLine setHidden:YES];
    
    [_hourHand setImage:[UIImage imageNamed:@"pop_yellow_alarm_hour_picker.png"]];
    [_minuteHand setImage:[UIImage imageNamed:@"pop_yellow_alarm_minute_picker.png"]];
    
    curHour = 0;
    preMinuteAngle = -0.1;
    
    [self stopRecordTimer];
    
    UIButton * test = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [test addTarget:self action:@selector(alarmTest) forControlEvents:UIControlEventTouchUpInside];
    test.frame = CGRectMake(200, 150, 20, 20);
    [self addSubview:test];
}

- (void)alarmTest
{
//    NSDate * today = [NSDate date];
//    
//    NSString *respath = [NSString stringWithFormat:@"%@",[selAlbum.assetURL absoluteString]];
//    [LocalPushHelper registerLocalPush:today songURL:respath];
    [self startRecordTimer];
}

#pragma mark - hourMinuteHandDelegate
- (void) minuteHandChanged:(double)angle
{
    NSLog(@"%f %d", angle, curHour);
    //179 -> -179 시간 지난거, vice versa 한시간 백
    if((preMinuteAngle > 45) && (angle < -45))
        curHour++;
    else if((preMinuteAngle < -45) && (angle > 45))
        curHour--;    
    
    double HourAngle = (curHour - 6) * 30 + (angle + 180) * 30 / 360;
    _hourHand.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(HourAngle));
    
    preMinuteAngle = angle;
}

#pragma mark - recordTimer
- (void)startRecordTimer
{
    if(recordTimer == nil)
    {
        if(curRecordType == RecordType)
        {
//            recordTimer = [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(onTimer) userInfo:nil repeats:YES];         
//            NSRunLoop *runloop = [NSRunLoop currentRunLoop];
//            [runloop addTimer:recordTimer forMode:UITrackingRunLoopMode];
            double rotationTime = selAlbum.playTime - selAlbum.currentTime;
            CABasicAnimation* moveAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
            moveAnimation.duration = rotationTime;
            moveAnimation.fromValue = [NSNumber numberWithInt:0];            
            moveAnimation.toValue = [NSNumber numberWithFloat:M_PI / 180 * 20 * rotationTime];
            moveAnimation.autoreverses = YES;            
            moveAnimation.delegate = self;
            [recordBoard.layer addAnimation:moveAnimation forKey:@"animationMoverRotation"];
        }
        else if(curRecordType == TimerType)
        {
            double angle = atan2(_hourHand.transform.b, _hourHand.transform.d) * 180 / M_PI;
            int num = (angle + 180.0)/ 45.0;
            limitTime = num * 60;
            
            limitTime = 5;
            
            recordTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(onTimer) userInfo:nil repeats:YES];         
            NSRunLoop *runloop = [NSRunLoop currentRunLoop];
            [runloop addTimer:recordTimer forMode:UITrackingRunLoopMode];
        }   
        else if(curRecordType == AlarmType)
        {
            limitTime = 5;
            
            recordTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(onTimer) userInfo:nil repeats:YES];         
            NSRunLoop *runloop = [NSRunLoop currentRunLoop];
            [runloop addTimer:recordTimer forMode:UITrackingRunLoopMode];
        }      

    }
}

- (void)stopRecordTimer
{
    if(recordTimer != nil)
    {
        [recordTimer invalidate];
        recordTimer = nil;
    }
}

#pragma mark - PlayPickerMethods
- (void)setPlayPickerPosition:(double)posDegree
{
    playPicker.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(-posDegree));
    playPicker.center = CGPointMake(recordLength / 2.0 + (recordLength - recordSizeDiff) / 2.0 * sin(DEGREES_TO_RADIANS(posDegree)), recordLength / 2.0 + (recordLength - recordSizeDiff) / 2.0 * cos(DEGREES_TO_RADIANS(posDegree)));
}

- (void)setPlayTime:(double)time curTime:(double)curTime
{
    playDegreePlusValue = (finalPlayPickerDegree - initialPlayPickerDegree) / time;
    playDegree = (finalPlayPickerDegree - initialPlayPickerDegree) / time * curTime + initialPlayPickerDegree;
    playPicker.totalPlaytime = time;
    [self setPlayPickerPosition:playDegree];
}

- (void)stopPlayPicker
{
    if(playTimer != nil)
    {
        [playTimer invalidate];
        playTimer = nil;
    }
    
    [self setPlayPickerPosition:initialPlayPickerDegree];
}

- (void)setPlayPickerAndStart
{
    if(playTimer == nil)
    {
        playTimer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(playOnTimer) userInfo:nil repeats:YES]; 
        NSRunLoop *runloop = [NSRunLoop currentRunLoop];
       [runloop addTimer:playTimer forMode:UITrackingRunLoopMode];
    }
}

#pragma mark - timer Method
- (void)onTimer
{
    if(curRecordType == RecordType)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        recordBoard.transform = CGAffineTransformMakeRotation(M_PI / 180 * degree);
        [UIView commitAnimations];
        
        degree += 10;
    }
    else if(curRecordType == TimerType)
    {
        if(limitTime == 0)
        {
            audioHelper = [AudioHelper sharedObject];
            [audioHelper stop];
            
            _hourHand.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(-180.0));                                    
            [recordTimer invalidate];
            recordTimer = nil;
            NSLog(@"Stoped");
        }
        _hourHand.transform = CGAffineTransformRotate(_hourHand.transform,DEGREES_TO_RADIANS( -45.0/60.0));                                     
        limitTime--;
        NSLog(@"%f %d", atan2(_hourHand.transform.b, _hourHand.transform.d) * 180 / M_PI, limitTime);
    }
    else if(curRecordType == AlarmType)
    {
        if(limitTime == 0)
        {
            MPMusicPlayerController * musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
            [musicPlayer play];
            
            [recordTimer invalidate];
            recordTimer = nil;
            NSLog(@"Stoped");
        }
        limitTime--;
        NSLog(@"Time:%d",limitTime);
    }
}

- (void)playOnTimer
{
    if(playDegree > finalPlayPickerDegree)
    {
        [playTimer invalidate];
        playTimer = nil;
        
        return;
    }
    
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.1];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    playPicker.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(360 - playDegree));
    playPicker.center = CGPointMake(recordLength / 2.0 + (recordLength - recordSizeDiff) / 2.0 * sin(DEGREES_TO_RADIANS(playDegree)), recordLength / 2.0 + (recordLength - recordSizeDiff) / 2.0 * cos(DEGREES_TO_RADIANS(playDegree)));
	[UIView commitAnimations];
    
    playDegree += playDegreePlusValue / 10.0;
}

#pragma mark - UIButton Action
- (void)emotionButton
{
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:emotionButton cache:YES];
	[UIView commitAnimations];
}

#pragma mark - Table Reload Data
- (void)reloadTableView
{
    [parentViewCon reloadTableView];
}
@end
