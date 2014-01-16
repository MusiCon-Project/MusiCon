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
#import "ImageEditManager.h"

@interface albumInfoViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, UITextViewDelegate, MKMapViewDelegate, UISearchBarDelegate, LBSManagerDelegate, FBManagerDelegate>
{
    UIButton * closeBtn;
    
    album * _album;
    UILabel * musicName;
    UILabel * artist;    
    UIImageView * miniAlbumStroke;
    UIImageView * miniAlbumJacket;
    UIButton * emotion;
    
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
    NSInteger preSelectIndex;
    
    //emoticonView
    UIImageView * albumJacketView;
    
    //mapView
    LBSManager * lbsManager;
    MKMapView * mapView;
    UITableView * mapTableView;
    UISearchBar * searchBar;
    NSArray * searchedPlace;
    
    //social
    FBManager * fbManager;
    
    ImageEditManager * imageEditManager;
    
}
- (void)fbDidLogin;
- (void)fbDidLogout;
@property(nonatomic, retain) History * albumHistory;
@property(nonatomic, retain) NSMutableArray * sameAlbumArray;
@property(nonatomic, retain) NSString * lyricString;
@property(nonatomic, retain) NSNumber * persistentID;
@property(nonatomic, retain) NSArray * searchedPlace;
@property(nonatomic, retain) album * _album;
@end
