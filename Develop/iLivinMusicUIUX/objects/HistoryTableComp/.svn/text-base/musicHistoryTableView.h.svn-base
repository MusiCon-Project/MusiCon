//
//  musicHistoryTableView.h
//  iLivinMusicUIUX
//
//  Created by jaehoon lee on 2/29/12.
//  Copyright (c) 2012 Kaist. All rights reserved.
//

#import <UIKit/UIKit.h>
@class iLivinMusicMainViewController;
@class albumInfoViewController;
@interface musicHistoryTableView : UITableView <UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
{
    iLivinMusicMainViewController * parentViewCon;
    NSArray * historyArray;
    
    CGPoint touch;
    CGPoint currentTouch;
    
    UIPickerView * datePicker;
    UIImageView * autoWarningView;
    UIImageView * emotionsBg;
    NSInteger preSelectIndex;
    NSMutableArray * cellArray;
    
    albumInfoViewController * _albumInfoViewController;
}
@property(nonatomic, retain) iLivinMusicMainViewController * parentViewCon;
- (void)updateHistory;
- (void)alarmTimerClicked;
- (void)autoAlarmTimerExplainationClicked;
- (void)volumeExplainationClicked;
- (void)alarmMusicClicked;
@end
