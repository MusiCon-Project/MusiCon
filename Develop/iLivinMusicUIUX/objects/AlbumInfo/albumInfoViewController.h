//
//  albumInfoViewController.h
//  iLivinMusicUIUX
//
//  Created by jaehoon lee on 5/28/12.
//  Copyright (c) 2012 Kaist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "History.h"
#import "LBSManager.h"
#import "FBManager.h"
#import "TwitterManager.h"
#import "ImageEditManager.h"
#import "SA_OAuthTwitterController.h"
#import "SA_OAuthTwitterEngine.h"

@class SA_OAuthTwitterEngine;
@interface albumInfoViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, UITextViewDelegate, MKMapViewDelegate, UISearchBarDelegate, LBSManagerDelegate, FBManagerDelegate, SA_OAuthTwitterControllerDelegate, SA_OAuthTwitterEngineDelegate>
{
    UIButton * closeBtn;
    UILabel * infoLabel;
    
    album * _album;
    UILabel * musicName;
    UILabel * artist;    
    UIImageView * miniAlbumStroke;
    UIImageView * miniAlbumJacket;
    
    UIImageView * buttonArrow;
    UIButton * albumBtn;
    UIButton * lyrics;
    UIButton * plus;
    UIButton * sns;
    UIButton * youtube;

    //youtubeView
    UIImageView * line;
    UIWebView * webView;
    
    //albumView
    UIImageView * sameAlbumBg;
    UITableView * sameAlbumTableView;
    
    UIImageView * lyricsBg;
    UIScrollView * lyricsScrollView;
    UILabel * lyricsLabel;
    
    //commentView
    UIImageView * commentView;
    UIImageView * commentView2;
    UIImageView * commentArrow;
    UIButton * facebookBtn;
    UIButton * twitterBtn;
    UIButton * sendBtn;
    UIButton * chatBtn;
    UIButton * emotionBtn;
    UIButton * mapBtn;
    UITextView * chatTextView;
    
    History * albumHistory;
    NSMutableArray * sameAlbumArray;
    NSString * lyricString;
    NSNumber * persistentID;
    
    UIImageView * emotionsBg;
    UIImageView * emotionsBgOnCommentView;
    NSInteger preSelectIndex;
    
    //commentView2
    UIScrollView * albumScrollView;
    UIImageView * albumJacketView;
    
    //emoticonView
    NSMutableArray * emotionSet;
    NSInteger currentEmotionIndex;
    UIButton * emotionSelCallBtn;
    UIImageView * emotion;
    BOOL emotionAniFinished;
    NSInteger selectedEmotionIndex;
    
    //mapView
    LBSManager * lbsManager;
    MKMapView * mapView;
    UITableView * mapTableView;
    UIActivityIndicatorView * mapTableViewIndicator;
    UISearchBar * searchBar;
    NSArray * searchedPlace;
    NSString * selectedPlaceID;
    
    //social
    FBManager * fbManager;
    TwitterManager * twManager;
    SA_OAuthTwitterEngine *_engine;
    
    ImageEditManager * imageEditManager;

}
- (void)fbDidLogin;
- (void)fbDidLogout;
- (void)viewModalLoadFinished;

- (void)viewInit;
- (void)viewInitForArtist;
@property(nonatomic, retain) History * albumHistory;
@property(nonatomic, retain) NSMutableArray * sameAlbumArray;
@property(nonatomic, retain) NSString * lyricString;
@property(nonatomic, retain) NSNumber * persistentID;
@property(nonatomic, retain) NSArray * searchedPlace;
@property(nonatomic, retain) album * _album;
@end
