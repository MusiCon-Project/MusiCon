//
//  folderButton.h
//  iLivinMusicUIUX
//
//  Created by jaehoon lee on 5/5/12.
//  Copyright (c) 2012 Kaist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
typedef enum
{
    ArtistButtonType,
    AlbumTitleButtonType,
    UserSelButtonType,
}FolderButtonType;


#define FolderLongPressEventTime 1.5

@interface folderButton : UIButton
{
    iLivinMusicMainViewController * mainViewCon;
    CGRect initialFrame;
    
    UIImageView * folderImage;
    UIImageView * albumJacket;
    CALayer * albumJacketLayer;
    UIImageView * coverImage;
    
    FolderButtonType folderType;
    UIImage * recordStroke;
    NSString * artist;
    NSString * albumTitle;
    NSInteger index;

    //Touch Associate
    CGPoint touch;
    CGPoint currentTouch;

    BOOL folderClicked;
    BOOL moved;
    
    BOOL folderAddMode;
}
@property(nonatomic, retain) iLivinMusicMainViewController * mainViewCon;
@property(nonatomic, retain) UIImage * recordStroke;
@property(nonatomic, retain) UIImageView * albumJacket;
@property(readwrite) FolderButtonType folderType;
@property(nonatomic, retain) NSString * artist;
@property(nonatomic, retain) NSString * albumTitle;
@property(readwrite) NSInteger index;
@property(readwrite) BOOL folderAddMode;
- (void)setFrameWithInitialFrame:(CGRect)frame;
-(void)setCoverHidden;
-(void)setCover:(BOOL)selected;
@end
