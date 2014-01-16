//
//  iLivinMusicMainViewController.h
//  iLivinMusicUIUX
//
//  Created by jaehoon lee on 2/11/12.
//  Copyright (c) 2012 Kaist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVAudioSession.h>
#import <MediaPlayer/MediaPlayer.h>
#import "AudioHelper.h"
#import "album.h"
#import "folderButton.h"
#import "record.h"
#import "recordLine.h"
#import "musicHistoryTableView.h"
#import "selfMusicHistoryCell.h"
#import "utilButton.h"
#import "sliderButton.h"

#define albumOriginX 310
#define albumStorageOriginX 310
#define recordMargin 5
#define recordLength 250

#define timeButtonMargin 20
#define HistoryHeaderHeight 10
#define HistoryHeaderLineLength 100

//Modified by The Finest Artist at 5.20
#define albumStorageAlbumSpace 69
#define albumStorageWidth 70.5
#define albumStorageAnimationDuration 0.1
#define albumStorageOneClickMargin 15
#define albumStorageSwipeMargin 20
#define albumStorageTagFadeMargin 40
#define albumStorageTagMoveMargin 70
#define albumVerticalAnimationDuration 0.1
#define albumInfoAnimationDuration 0.6

#define ALARM_NOTI @"ALARM_NOTI"
#define TIMER_NOTI @"TIMER_NOTI"
#define AUTO_ALARM_NOTI @"AUTO_ALARM_NOTI"
#define AUTO_TIMER_NOTI @"AUTO_TIMER_NOTI"

@interface iLivinMusicMainViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, AudioHelperDelegate, albumDelegate, recordLineDelegate>
{
    UIImageView * bg;
    UIImageView * bgTop;
    
    sliderButton * slideButton;
    BOOL opened; //Album Storage가 열려 있는지 여부
    BOOL opening; //사용자가 Album Storage 스크롤시 열고있는 중인지 여부
    BOOL shouldSwipe; //사용자가 swipe를 이용해서 Album Storage를 열게 하는게 가능한지(처음 Album Storage touch한 위치에 따라 Album Storage swipe가 안될수도 있음)
    BOOL shouldOneClickMove; //사용자가 Album Storage를 클릭한번으로 열수 있는지 여부(처음 Album Storage touch한 위치에 따라 Album Storage open이 안될수도 있음)
    double lastTouchX;
    double lastTouchY;
    BOOL shouldScroll; //Album Storage가 열려 있고 사용자가 Album storage를 swipe하지 않는 경우 Album들을 위아래로 scroll하는 이벤트를 원한다고 간주하고 Album scroll event가 진행됨)
    double mainViewMoveMargin;
    BOOL tagOpened; //name tag가 열여있는지 여부
    BOOL tagShuoldSwipe; //name tag를 swipe를 이용하여 열수 있는지 여부(처음 사용자가 터치한 위치에 따라 달라짐)
    
    BOOL albumVerticalMoveStarted;
    double albumVerticalMoveStartY;
    
    UIView * fullRecordView;
    UIImageView * volumeView;
    UIButton * repeatButton;
    NSInteger repeat; //0:repeat no 1: repeat all 2: repeat one
    UIButton * shuffleButton;
    NSInteger shuffle; //0.shuffle off 1:shuffle on
    
    MPMusicPlayerController * musicPlayer;
    
    utilButton * timerButton;
    utilButton * alarmButton;
    
    AudioHelper * audioHelper;
    NSMutableArray * albumArray;
    NSMutableArray * selectedAlbumArray;
    NSMutableArray * folderArray;
    NSMutableArray * showingAlbumArray;
    
    record * _record;
    NSMutableArray * historyArray;
    musicHistoryTableView * _musicHistoryTableView;
    
    UIScrollView * albumScroll;
    
    CGPoint touch;
    CGPoint currentTouch;
    album * selectedAlbum;
    
    UIButton * shopButton;
    UIButton * infoTrashButton;
    UIButton * recentMusicButton;
    UIButton * menuButton;
    UIButton * selectAllButton;
    
    NSInteger preSelectedmenu; //0:song 1:artist 2:album 3:folder
    NSInteger preSelectedAlbumStorageMenu; //0:shop 1:now playing 2:menu
    
    BOOL longLeftSwipeDetected;
    UISwipeGestureRecognizer *longLeftSwipeRecognizer;
    
    NSMutableArray * subMenus;
    NSMutableArray * albumsInFolderArr;
    folderButton * selectedFolderButton;
    BOOL folderAddActivated;
    
    UIActivityIndicatorView * albumsIndicator;
}
@property(nonatomic, retain) record * record;
@property(readwrite) BOOL opened;
@property(readwrite) BOOL shouldSwipe;
@property(nonatomic, retain) NSMutableArray * albumArray;
@property(nonatomic, retain) NSMutableArray * folderArray;
@property(nonatomic, retain) UIButton * slideButton;
@property(nonatomic, retain) NSMutableArray * subMenus;
- (void)addAlbumInSelectedAlbumArr:(album *)_album;
- (void)removeAlbumFromSelectedAlbumArr:(album *)_album;
- (void)FlipToAlbumSelectedAction:(album *)selAlbum;
- (void)FlipToAlbumDeselectedAction:(album *)selAlbum;
- (void)collectSelectedAlbumToMovingAlbum:(CGRect)pos mainAlbum:(album *)_album;
- (void)selectedAlbumBackToInitialPos:(CGRect)pos;
- (void)showAlbumTag:(BOOL)show;
- (void)folderAddMenuButtonOnAction;
- (void)reloadTableView;
- (void)folderButtonOnAction:(id)sender;
- (void)folderVerticalMove:(double)currentY folderY:(double)selectedAlbumY;
- (void)folderVerticalEnded;
- (void)slideButtonOnAction:(id)slideButton;
- (void)saveAlbumsInFolder:(folderButton *)folderBtn;
- (void)touchesBegan:(CGPoint)currentPoint;
- (void)touchesMoved:(CGPoint)currentPoint;
- (void)touchesEnded;
@end
