//
//  album.h
//  iLivinMusicUIUX
//
//  Created by jaehoon lee on 2/21/12.
//  Copyright (c) 2012 Kaist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlbumGestureRecognizer.h"
#define recordLength 250
#define recordOffset 30

#define HistoryAlbumStrokeLength 41
#define HistoryAlbumLength 38
#define AlbumStrokeLength 46
#define AlbumLength 38
#define AlbumLongPressEventTime 0.5
#define AlbumNameTagFadeAnimationDuration 0.3
#define AlbumNameTagMoveAnimationDuration 0.7
#define AlbumNameTagWidth 120
#define AlbumNameTagStart 260

@class album;
@protocol albumDelegate <NSObject>
- (void)albumFinishEnlargeOnRecord:(UIImage *)_albumImage Title:(NSString *)title playTime:(double)time album:(album *)alb;
- (void)albumVerticalMove:(double)currentY albumY:(double)selectedAlbumY;
- (void)albumVerticalEnded;
@end

@class iLivinMusicMainViewController;
@interface album : UIImageView
{
    iLivinMusicMainViewController * mainViewCon;
    UIScrollView * albumScrollViewCon;
    
    UIImageView * albumStroke;
    UIImageView * albumjaket;
    CALayer * albumjaketlayer;
    
    UIImage * smallStroke;
    UIImage * smalljaket;
    UIImage * bigStroke;
    UIImage * bigjaket;
    UIImage * recordStroke;
    
    CGPoint touch;
    CGPoint currentTouch;
    
    CGRect initialFrame;
    id<albumDelegate> delegate;
    
    //album Info
    NSNumber * persistentID;
    NSString * musicTitle;
    NSString * artist;
    NSString * albumTitle;
    NSString * lyrics;
    double playTime;
    double currentTime;
 
    BOOL longPressed;
    BOOL moved;
    
    AlbumGestureRecognizer * longPress;
    NSURL * assetURL; //song URL in Ipod Library
    
    UIImageView * nameTag;
    UILabel * nameTagLabel;
    NSInteger folderIndex;
    BOOL selected;

    BOOL previousShow;
}
@property(readwrite) CGRect initialFrame;
@property(nonatomic, retain) UIImageView * albumStroke;
@property(nonatomic, retain) UIImageView * albumjaket;
@property(nonatomic, retain) CALayer * albumjaketlayer;
@property(nonatomic, retain) iLivinMusicMainViewController * mainViewCon;
@property(nonatomic, retain) UIScrollView * albumScrollViewCon;
@property(nonatomic, retain) id<albumDelegate> delegate;
@property(nonatomic, retain) NSNumber * persistentID;
@property(nonatomic, retain) NSString * artist;
@property(nonatomic, retain) NSString * musicTitle;
@property(nonatomic, retain) NSString * albumTitle;
@property(nonatomic, retain) NSString * lyrics;
@property(nonatomic, retain) UIImage * smalljaket;
@property(readwrite) double playTime;
@property(readwrite) double currentTime;
@property(nonatomic, retain) NSURL * assetURL;
@property(nonatomic, retain) UIImageView * nameTag;
@property(nonatomic, retain) UILabel * nameTagLabel;
@property(nonatomic, retain) UIImage * smallStroke;
@property(nonatomic, retain) UIImage * bigStroke;
@property(nonatomic, retain) UIImage * bigjaket;
@property(nonatomic, retain) UIImage * recordStroke;
@property(readwrite) NSInteger folderIndex;
@property(readwrite) BOOL selected;

- (void)setFrameWithInitialFrame:(CGRect)frame;
- (void)setAlbumjaket:(UIImage *)smallImage bigImage:(UIImage *)bigImage recordImage:(UIImage *)recordImage;
- (CGSize)getSizeFromString:(NSString *)string;
- (void)setSelect:(BOOL)select;
- (BOOL)checkNameTagShowed;
- (void)showNameTag:(BOOL)show;

@end
