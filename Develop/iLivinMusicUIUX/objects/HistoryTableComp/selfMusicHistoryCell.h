//
//  selfMusicHistoryCell.h
//  iLivinMusicUIUX
//
//  Created by jaehoon lee on 3/13/12.
//  Copyright (c) 2012 Kaist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "record.h"
#import "History.h"
#import "DataModelManager.h"
@interface selfMusicHistoryCell : UITableViewCell
{
    UILabel * musicName;
    UILabel * artist;
    
    UIImageView * miniAlbumStroke;
    UIImageView * miniAlbumJacket;
    
    UIImageView * emotion;
    UIButton * emotionSelCallBtn;
    NSMutableArray * emotionSet;
    BOOL emotionAniFinished;
    NSInteger currentEmotionIndex;
    
    NSInteger selectedEmotionIndex;
    
    UIButton * musicNameButton;
    UIButton * artistButton;

    History * history;
}
@property(nonatomic, retain) UIButton * musicNameButton;
@property(nonatomic, retain) UILabel * musicName;
@property(nonatomic, retain) UIButton * artistButton;
@property(nonatomic, retain) UILabel * artist;
@property(nonatomic, retain) UIImageView * miniAlbumStroke;
@property(nonatomic, retain) UIImageView * miniAlbumJacket;
@property(nonatomic, retain) UIImageView * emotion;
@property(nonatomic, retain) History * history;
- (void)emotionAnimation;
- (void)activateAlbumInfo:(BOOL)deact;
- (void)emotionButtonAction:(id)sender;
- (void)setEmotionAniFinished:(BOOL)aEmotionAniFinished;
- (void)saveEmotionNumInHistory:(NSInteger)emotionNum;
@end

typedef enum
{
    AlarmSettingCellType,
    VolumeSettingCellType,
    TimerSettingCellType,
}alarmSettingCellType;

@interface settingCell : UITableViewCell
{
    UILabel * title;
    UILabel * subTitle;
    
    UISlider * volumeLine;
    
    UIButton * rightButton;
    UIButton * leftButton;
    
    UIDatePicker * datePicker;
}
- (void)setSettingCellView:(recordType)RecordType indexPathRow:(NSInteger)row;
- (void)updateSettingCellView:(recordType)RecordType indexPathRow:(NSInteger)row;
@property(nonatomic, retain) UILabel * title;
@property(nonatomic, retain) UILabel * subTitle;
@property(nonatomic, retain) UIButton * rightButton;
@property(nonatomic, retain) UIButton * leftButton;
@end