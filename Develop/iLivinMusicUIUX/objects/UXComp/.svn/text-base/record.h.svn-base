//
//  record.h
//  iLivinMusicUIUX
//
//  Created by jaehoon lee on 2/22/12.
//  Copyright (c) 2012 Kaist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "PlayPickerImageView.h"
#import "hourMinuteHand.h"
#import "recordLine.h"
#import "album.h"
#import "AudioHelper.h"
#define recordLength 250
#define recordSizeDiff 38
#define initialPlayPickerDegree -16.3
#define finalPlayPickerDegree 115.6

typedef enum
{
    RecordType,
    TimerType,
    AlarmType
}recordType;

@class iLivinMusicMainViewController;
@interface record : UIView <hourMinuteHandDelegate>
{
    CGFloat degree;
    CGFloat playDegree;
    CGFloat playDegreePlusValue;
    UIImageView * recordBoard;
    CALayer * recordBoardlayer;
    UIImageView * recordBg;
    UIImageView * recordDefaultBg;
    
    PlayPickerImageView * playPicker;
    
    NSTimer *recordTimer;
    NSTimer *playTimer;
    
    BOOL isPlaying;
    
    UIButton * emotionButton;
    
    hourMinuteHand * _hourHand;
    hourMinuteHand * _minuteHand;
    
    recordLine * _recordLine;
    
    recordType curRecordType;
    int limitTime;

    //For HourHand effect from MinuteHand
    int curHour;
    double preMinuteAngle;
    
    album * selAlbum;
    AudioHelper * audioHelper;
    iLivinMusicMainViewController * parentViewCon;
    
    BOOL albumSelected;
}
@property(readwrite) recordType curRecordType;
@property(nonatomic, retain) UIImageView * recordBoard;
@property(nonatomic, retain) recordLine * RecordLine;
@property(nonatomic, retain) album * selAlbum;
@property(readwrite) int limitTime;
@property(nonatomic, retain) iLivinMusicMainViewController * parentViewCon;
@property(readwrite) BOOL albumSelected;
- (id)initWithFrame:(CGRect)frame type:(recordType)type;
- (void)setPlayTime:(double)time curTime:(double)curTime;
- (void)stopPlayPicker;
- (void)setPlayPickerAndStart;
- (void)setBoardToRecordUI;
- (void)setBoardToTimerUI:(BOOL)activated;
- (void)setBoardToAlarmUI:(BOOL)activated;
- (void)startRecordTimer;
- (void)reloadTableView;
@end
