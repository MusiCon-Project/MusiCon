//
//  albumInfoViewController.m
//  iLivinMusicUIUX
//
//  Created by jaehoon lee on 5/28/12.
//  Copyright (c) 2012 Kaist. All rights reserved.
//

#import "albumInfoViewController.h"
#import "albumInfoTableViewCell.h"
#import "album.h"
#import "selfMusicHistoryCell.h"
#import "NowPlaying.h"
#import "DataModelManager.h"
#import "SA_OAuthTwitterEngine.h"
#import "UserDefaultHelper.h"
#import "UIImage+Transform.h"
#import <QuartzCore/QuartzCore.h>
#define buttonInterval 15
#define buttonLength 40
@interface albumInfoViewController ()
- (void)setAlbumView;
- (void)setButtonView;
- (void)setCommentView;
@end

@implementation albumInfoViewController
@synthesize albumHistory;
@synthesize sameAlbumArray;
@synthesize lyricString;
@synthesize persistentID;
@synthesize searchedPlace;
@synthesize _album;
#pragma mark - viewConfiguration
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        emotionSet = [[NSMutableArray alloc] init];
        selectedPlaceID = nil;
    }
    return self;
}

- (void)dealloc
{
    [emotionSet release];
    [albumHistory release];
    [sameAlbumArray release];
    [lyricString release];
    [persistentID release];
    [_album release];
    
    if(searchedPlace != nil)
        [searchedPlace release];

    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setAlbumView];
    [self setEmotionView];
    
    [self setYoutubeView];
    [self setSameAlbumView];
    [self setLyricView];
    [self setCommentView];
    
    [self setButtonView];
    
    infoLabel = [[UILabel alloc] initWithFrame:CGRectMake((310-170)/2.0, 5, 170, 16)];
    [infoLabel setFont:[UIFont fontWithName:@"ArialRoundedMTBold" size:14.0f]];
    [infoLabel setTextColor:[UIColor yellowColor]];
    [infoLabel setTextAlignment:UITextAlignmentCenter];
    infoLabel.text = @"Comments";
    [self.view addSubview:infoLabel];
    [infoLabel release];
    
    closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(270, 0, 50, 30)];
    [closeBtn setImage:[UIImage imageNamed:@"pop_yellow_album_storage_bubble.png"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(cancelOnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeBtn];
    [closeBtn release];
    
    [self viewInit];
}

- (void)viewInit
{
    [commentArrow setFrame:CGRectMake(40, 20, 5, 10)];
    commentView2.hidden = NO;
    chatBtn.selected = YES;
    emotionBtn.selected = NO;
    albumJacketView.hidden = YES;
    mapBtn.selected = NO;
    mapView.hidden = YES;
    searchBar.hidden = YES;
    mapTableView.hidden = YES;
    emotionsBgOnCommentView.hidden = YES;    
}

- (void)viewInitForArtist
{
    [buttonArrow setFrame:CGRectMake(37.5 + (buttonLength + buttonInterval)*2, 120, 15, 5)];
    [line setHidden:YES];
    [webView setHidden:YES];
    [sameAlbumBg setHidden:NO];
    [lyricsBg setHidden:YES];
    [commentView setHidden:YES];
    [commentView2 setHidden:YES];
    [chatTextView resignFirstResponder];
    infoLabel.text = @"Album Info";
}

- (void)viewModalLoadFinished
{
    [chatTextView becomeFirstResponder];
}

- (void)setAlbumView
{
    NSLog(@"%@", albumHistory.title);
    musicName = [[UILabel alloc] initWithFrame:CGRectMake(75, 38, 170, 14)];
    [musicName setFont:[UIFont fontWithName:@"ArialRoundedMTBold" size:12.0f]];
    [musicName setTextColor:[UIColor grayColor]];
    musicName.text = albumHistory.title;
    [self.view addSubview:musicName];
    [musicName release];
    
    artist = [[UILabel alloc] initWithFrame:CGRectMake(75, 55, 170, 11)];
    [artist setFont:[UIFont fontWithName:@"ArialRoundedMTBold" size:9.0f]];
    [artist setTextColor:[UIColor grayColor]];
    artist.text = albumHistory.artist;
    [self.view addSubview:artist];
    [artist release];
    
//    miniAlbumStroke = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, AlbumStrokeLength, AlbumStrokeLength)];
//    [miniAlbumStroke setImage:[UIImage imageNamed:@"pop_yellow_album_border.png"]];
    
    miniAlbumStroke = [[UIImageView alloc] initWithFrame:CGRectMake(25, 30, HistoryAlbumStrokeLength, HistoryAlbumStrokeLength)];
    [miniAlbumStroke setImage:[UIImage imageNamed:@"pop_yellow_album_border.png"]];
    [self.view addSubview:miniAlbumStroke];
    [miniAlbumStroke release];
    
    miniAlbumJacket = [[UIImageView alloc] initWithFrame:CGRectMake(27, 32, HistoryAlbumLength, HistoryAlbumLength)];
    CALayer * albumjaketlayer = [miniAlbumJacket layer];
    [albumjaketlayer setMasksToBounds:YES];
    [albumjaketlayer setCornerRadius:HistoryAlbumLength / 2.0];
    miniAlbumJacket.image = [History readImage:albumHistory.albumImageURL title:albumHistory.title];
    [self.view addSubview:miniAlbumJacket];
    [miniAlbumJacket release];
}

- (void)setEmotionView
{
    emotion = [[UIImageView alloc] initWithFrame:CGRectMake(250, 35, 30, 30)];
    [emotion setImage:[UIImage imageNamed:[NSString stringWithFormat:@"pop_yellow_like_%d.png", albumHistory.emotion.intValue]]];
    [self.view addSubview:emotion];
    [emotion release];
    
    emotionSelCallBtn = [[UIButton alloc] initWithFrame:CGRectMake(250, 35, 30, 30)];
    [emotionSelCallBtn addTarget:self action:@selector(emoticonButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [emotionSelCallBtn setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:emotionSelCallBtn];
    [emotionSelCallBtn release];
    
//    emotion.alpha = 0;
//    emotionAniFinished = NO;
    selectedEmotionIndex = 0; //JHLee Temporary
//    [emotionSet addObject:[NSNumber numberWithInt:0]];
//    [self emotionAnimation];
}

- (void)setButtonView
{
    buttonArrow = [[UIImageView alloc] initWithFrame:CGRectMake(37.5, 120, 15, 5)];
    [buttonArrow setImage:[UIImage imageNamed:@"pop_yellow_album_info_box_point.png"]];
    [self.view addSubview:buttonArrow];
    [buttonArrow release];
    
    double buttonXdiff = buttonLength + buttonInterval;
    plus = [[UIButton alloc] initWithFrame:CGRectMake(25, 77, buttonLength, buttonLength)];
    plus.tag = 0;
    [plus setImage:[UIImage imageNamed:@"pop_yellow_album_info_icon_plus.png"] forState:UIControlStateNormal];
    [plus addTarget:self action:@selector(mainButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:plus];
    [plus release];

    youtube = [[UIButton alloc] initWithFrame:CGRectMake(25 + buttonXdiff, 77, buttonLength, buttonLength)];
    youtube.tag = 1;
    [youtube setImage:[UIImage imageNamed:@"pop_yellow_album_info_icon_youtube.png"] forState:UIControlStateNormal];
    [youtube addTarget:self action:@selector(mainButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:youtube];
    [youtube release];

    albumBtn = [[UIButton alloc] initWithFrame:CGRectMake(25 + 2 * buttonXdiff, 77, buttonLength, buttonLength)];
    albumBtn.tag = 2;
    [albumBtn setImage:[UIImage imageNamed:@"pop_yellow_album_info_icon_album.png"] forState:UIControlStateNormal];
    [albumBtn addTarget:self action:@selector(mainButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:albumBtn];
    [albumBtn release];

    lyrics = [[UIButton alloc] initWithFrame:CGRectMake(25 + 3 * buttonXdiff, 77, buttonLength, buttonLength)];
    lyrics.tag = 3;
    [lyrics setImage:[UIImage imageNamed:@"pop_yellow_album_info_icon_lyrics.png"] forState:UIControlStateNormal];
    [lyrics addTarget:self action:@selector(mainButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:lyrics];
    [lyrics release];

    sns = [[UIButton alloc] initWithFrame:CGRectMake(25 + 4 * buttonXdiff, 77, buttonLength, buttonLength)];
    sns.tag = 4;
    [sns setImage:[UIImage imageNamed:@"pop_yellow_album_info_icon_sns.png"] forState:UIControlStateNormal];
    [sns addTarget:self action:@selector(mainButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sns];
    [sns release];
    
    [self mainButtonAction:sns];
}

#pragma mark - emotion Animation
- (void)emotionAnimation
{
    CABasicAnimation * opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = [NSNumber numberWithFloat:0.0];
    opacityAnimation.toValue = [NSNumber numberWithFloat:1.0];
    opacityAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	opacityAnimation.autoreverses = YES;
    opacityAnimation.repeatCount = 1;
    opacityAnimation.duration= 0.7;
	opacityAnimation.delegate = self;
    
    [emotion.layer addAnimation:opacityAnimation forKey:@"opacityAnimation"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [self changeEmotionImage];
    if(!emotionAniFinished)
        [self emotionAnimation];
}

- (void)changeEmotionImage
{
    if(([emotionSet count] - 1) == currentEmotionIndex)
        currentEmotionIndex = 0;
    else
        currentEmotionIndex++;
    NSNumber * emotionTag = [emotionSet objectAtIndex:currentEmotionIndex];
    NSString * emotionName = [NSString stringWithFormat:@"pop_yellow_like_%d.png", emotionTag.intValue];
    [emotion setImage:[UIImage imageNamed:emotionName]];
}
#pragma mark button action
- (void)setYoutubeView
{
    line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 125, 320, 2)];
    [line setBackgroundColor:[UIColor colorWithRed:46.0/255.0 green:46.0/255.0 blue:46.0/255.0 alpha:1]];
    [self.view addSubview:line];
    [line release];
    
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 127, 320, 333)];
    NSString * urlString = [NSString stringWithFormat:@"http://m.youtube.com/results?q=%@", albumHistory.title];
    NSString * escapedURL = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL * url = [NSURL URLWithString:escapedURL];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    
    [webView loadRequest:request];
    [self.view addSubview:webView];
    [webView release];
}

- (void)setSameAlbumView
{
    sameAlbumBg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 120, 290, 330)];
    sameAlbumBg.userInteractionEnabled = YES;
    [sameAlbumBg setImage:[UIImage imageNamed:@"pop_yellow_album_info_box.png"]];
    [self.view addSubview:sameAlbumBg];
    [sameAlbumBg release];
    
    sameAlbumTableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 30, 270, 290)];
    sameAlbumTableView.delegate = self;
    sameAlbumTableView.dataSource = self;
    [sameAlbumBg addSubview:sameAlbumTableView];
    [sameAlbumTableView release];
}

- (void)setLyricView
{
    lyricsBg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 120, 290, 330)];
    lyricsBg.userInteractionEnabled = YES;
    [lyricsBg setImage:[UIImage imageNamed:@"pop_yellow_album_info_box.png"]];
    [self.view addSubview:lyricsBg];
    [lyricsBg release];  
    
    lyricsScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 30, 270, 290)];
    [lyricsScrollView setBackgroundColor:[UIColor whiteColor]];
    [lyricsBg addSubview:lyricsScrollView];
    [lyricsScrollView release];
    
    CGSize estimateSize = [self getSizeFromString:lyricString];
    lyricsLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 250, estimateSize.height + 10)];
    lyricsScrollView.contentSize = CGSizeMake(270, estimateSize.height + 30);
    [lyricsLabel setFont:[UIFont fontWithName:@"ArialRoundedMTBold" size:15.0f]];
    [lyricsLabel setText:lyricString];
    [lyricsLabel setNumberOfLines:0];
    [lyricsLabel setLineBreakMode:UILineBreakModeClip];
    [lyricsScrollView addSubview:lyricsLabel];
    [lyricsLabel release];
}

- (CGSize)getSizeFromString:(NSString *)string
{
    return [string sizeWithFont:[UIFont fontWithName:@"ArialRoundedMTBold" size:15.0f] constrainedToSize:CGSizeMake(250.0f, FLT_MAX) lineBreakMode:UILineBreakModeClip];
}

- (void)setCommentView
{
    commentView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 120, 290, 120)];
    commentView.userInteractionEnabled = YES;
    [commentView setImage:[UIImage imageNamed:@"pop_yellow_album_info_comments.png"]];
    [self.view addSubview:commentView];
    [commentView release];
    
    commentView2 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 240, 290, 215)];
    [commentView2 setImage:[UIImage imageNamed:@"pop_yellow_album_info_comments2.png"]];
    commentView2.userInteractionEnabled = YES;
    commentView2.hidden = YES;
    [self.view addSubview:commentView2];
    [commentView2 release];
    
    commentArrow = [[UIImageView alloc] initWithFrame:CGRectMake(40, 20, 5, 10)];
    [commentArrow setImage:[UIImage imageNamed:@"pop_yellow_album_info_comments_pointer.png"]];
    [commentView addSubview:commentArrow];
    [commentArrow release];
    
    facebookBtn = [[UIButton alloc] initWithFrame:CGRectMake(250, 10, 30, 30)];
    facebookBtn.tag = 0;
    [facebookBtn setImage:[UIImage imageNamed:@"pop_yellow_album_info_comments_facebook.png"] forState:UIControlStateNormal];
    [facebookBtn setImage:[UIImage imageNamed:@"pop_yellow_album_info_comments_facebook_selected.png"] forState:UIControlStateSelected];
    [facebookBtn addTarget:self action:@selector(socialButtonOnAction:) forControlEvents:UIControlEventTouchUpInside];
    [commentView addSubview:facebookBtn];
    [facebookBtn release];
    
    twitterBtn = [[UIButton alloc] initWithFrame:CGRectMake(250, 40, 30, 30)];
    twitterBtn.tag = 0;
    [twitterBtn setImage:[UIImage imageNamed:@"pop_yellow_album_info_comments_twitter.png"] forState:UIControlStateNormal];
    [twitterBtn setImage:[UIImage imageNamed:@"pop_yellow_album_info_comments_twitter_selected.png"] forState:UIControlStateSelected];
    [twitterBtn addTarget:self action:@selector(socialButtonOnAction:) forControlEvents:UIControlEventTouchUpInside];
    [commentView addSubview:twitterBtn];
    [twitterBtn release];
    
    //set FB & TW state
    if([UserDefaultHelper getFBAssociteState] == YES)
        [facebookBtn setSelected:YES];
    
    if([UserDefaultHelper getTWAssociteState] == YES)
        [twitterBtn setSelected:YES];
    
    sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(250, 80, 30, 30)];
    sendBtn.tag = 0;
    [sendBtn setImage:[UIImage imageNamed:@"pop_yellow_album_info_comments_send.png"] forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(socialButtonOnAction:) forControlEvents:UIControlEventTouchUpInside];
    [commentView addSubview:sendBtn];
    [sendBtn release];
    
    fbManager = [FBManager sharedObject];
    [fbManager setDelegate:self];
    
    chatBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
    [chatBtn setImage:[UIImage imageNamed:@"pop_yellow_album_info_sns_chat.png"] forState:UIControlStateNormal];
    [chatBtn setImage:[UIImage imageNamed:@"pop_yellow_album_info_sns_chat_selected.png"] forState:UIControlStateSelected];
    [chatBtn addTarget:self action:@selector(commentButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [commentView addSubview:chatBtn];
    [chatBtn release];
    
    emotionBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 45, 30, 30)];
    [emotionBtn setImage:[UIImage imageNamed:@"pop_yellow_album_info_sns_emotion.png"] forState:UIControlStateNormal];
    [emotionBtn setImage:[UIImage imageNamed:@"pop_yellow_album_info_sns_emotion_selected.png"] forState:UIControlStateSelected];
    [emotionBtn addTarget:self action:@selector(commentButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [commentView addSubview:emotionBtn];
    [emotionBtn release];
    
    [self emotionOnCommentViewInit];
    
    albumScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 10, 270, 195)];
    albumScrollView.contentSize = CGSizeMake(270, 270);
    albumScrollView.bounces = NO;
    [commentView2 addSubview:albumScrollView];
    [albumScrollView release];
    
    albumJacketView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 270, 270)];
    albumJacketView.image = [UIImage resizedImage:_album.recordStroke inRect:CGRectMake(0, 0, 270, 270)];
    [albumScrollView addSubview:albumJacketView];
    [albumJacketView release];
    
    NSLog(@"ImageSize:%f %f", _album.recordStroke.size.width, _album.recordStroke.size.height);

    mapBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 80, 30, 30)];
    [mapBtn setImage:[UIImage imageNamed:@"pop_yellow_album_info_sns_map.png"] forState:UIControlStateNormal];
    [mapBtn setImage:[UIImage imageNamed:@"pop_yellow_album_info_sns_map_selected.png"] forState:UIControlStateSelected];
    [mapBtn addTarget:self action:@selector(commentButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [commentView addSubview:mapBtn];
    [mapBtn release];

    mapView = [[MKMapView alloc] initWithFrame:CGRectMake(45, 15, 200, 90)];
    mapView.layer.cornerRadius = 5.0;
    [commentView addSubview:mapView];
    [mapView release];
    
    lbsManager = [LBSManager sharedObject];
	[lbsManager setDelegate:self];
    
    //resize searchbar
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(10, 10, 270, 40)];
    searchBar.delegate = self;
    [commentView2 addSubview:searchBar];
    [searchBar release];
    
    //resize tableview cell height
    
    
    mapTableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 50, 270, 155)];
    mapTableView.delegate = self;
    mapTableView.dataSource = self;
    [commentView2 addSubview:mapTableView];
    [mapTableView release];
    
    mapTableViewIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(120, 62.5, 30, 30)];
    [mapTableViewIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [mapTableView addSubview:mapTableViewIndicator];
    [mapTableViewIndicator startAnimating];
    [mapTableViewIndicator release];
    
    chatTextView = [[UITextView alloc] initWithFrame:CGRectMake(43, 18, 203, 84)];
    [chatTextView setBackgroundColor:[UIColor clearColor]];
    [commentView addSubview:chatTextView];
    [chatTextView release];

    searchedPlace = nil;
}

- (void)emotionImageConf
{
    emotionsBg = [[UIImageView alloc] initWithFrame:CGRectMake(80, 27, 167, 93)];
    [emotionsBg setImage:[UIImage imageNamed:@"pop_yellow_like_tag.png"]];
    emotionsBg.userInteractionEnabled = YES;
    [self.view addSubview:emotionsBg];
    [emotionsBg release];
    
    for(int i = 0; i < 7; i++)
    {
        int j = i / 5.0; int k = i - j * 5;
        UIButton * emotionOpt = [[UIButton alloc] initWithFrame:CGRectMake(5 + 30 * k, 30 * j, 30, 30)];
        emotionOpt.tag = i;
        [emotionOpt addTarget:self action:@selector(emotionButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [emotionOpt setImage:[UIImage imageNamed:@"pop_yellow_like_selected.png"] forState:UIControlStateSelected];
        //Previous Selected Index. JH.Lee
        if(emotionOpt.tag == albumHistory.emotion.intValue)
            emotionOpt.selected = YES;
        UIImageView * emotionImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        NSString *imageName = [NSString stringWithFormat:@"pop_yellow_like_%d.png", i];
        [emotionImg setImage:[UIImage imageNamed:imageName]];
        [emotionOpt addSubview:emotionImg];
        [emotionsBg addSubview:emotionOpt];
        [emotionOpt release];
        [emotionImg release];
    }
}

- (void)emotionOnCommentViewInit
{
    emotionsBgOnCommentView = [[UIImageView alloc] initWithFrame:CGRectMake(43, 18, 203, 84)];
    emotionsBgOnCommentView.userInteractionEnabled = YES;
    [commentView addSubview:emotionsBgOnCommentView];
    [emotionsBgOnCommentView release];

    for(int i = 0; i < 7; i++)
    {
        int j = i / 6.0; int k = i - j * 6;
        UIButton * emotionOpt = [[UIButton alloc] initWithFrame:CGRectMake(5 + 33 * k, 30 * j, 30, 30)];
        emotionOpt.tag = i;
        [emotionOpt addTarget:self action:@selector(emotionOnCommentButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [emotionOpt setImage:[UIImage imageNamed:@"pop_yellow_like_selected.png"] forState:UIControlStateSelected];
        UIImageView * emotionImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        NSString *imageName = [NSString stringWithFormat:@"pop_yellow_like_%d.png", i];
        [emotionImg setImage:[UIImage imageNamed:imageName]];
        [emotionOpt addSubview:emotionImg];
        [emotionsBgOnCommentView addSubview:emotionOpt];
        [emotionOpt release];
        [emotionImg release];
    }
}

#pragma mark - button Action
- (void)emoticonButtonClicked:(id)sender
{
    if(emotionsBg == nil)
        [self emotionImageConf];
    else
    {
        emotionsBg.hidden = !emotionsBg.hidden;
        for (NSNumber * aEmotionOpt in emotionSet) 
            NSLog(@"%d", aEmotionOpt.intValue);
    }
}

- (void)emotionButtonAction:(id)sender
{
    for(id subView in [emotionsBg subviews])
    {
        if([subView isKindOfClass:[UIButton class]])
        {
            UIButton * subV = (UIButton *)subView;
            subV.selected = NO;
        }
    }
    
    UIButton * emotionOpt = (UIButton *)sender;
    emotionOpt.selected = !emotionOpt.selected;
    [emotion setImage:[UIImage imageNamed:[NSString stringWithFormat:@"pop_yellow_like_%d.png", emotionOpt.tag]]];
    
//    if(emotionOpt.selected == YES)
//    {
//        int index = 0; int emotionNumTag = emotionOpt.tag;
//        for (NSNumber * aEmotionOpt in emotionSet) 
//        {
//            if(emotionNumTag > [aEmotionOpt intValue]) 
//                index++ ; 
//            else
//                break;
//        }
//        [emotionSet insertObject:[NSNumber numberWithInt:emotionOpt.tag] atIndex:index];
//    }
//    else
//    {
//        int emotionNumTag = emotionOpt.tag;
//        for (NSNumber * aEmotionOpt in emotionSet) 
//        {
//            if(emotionNumTag == aEmotionOpt.intValue)
//                [emotionSet removeObject:aEmotionOpt];
//        }
//    }
}

- (void)emotionOnCommentButtonAction:(id)sender
{
    UIButton * emotionOpt = (UIButton *)sender;
    emotionOpt.selected = !emotionOpt.selected;
    
    NSMutableArray * selBtnArr = [[NSMutableArray alloc] init];
    for(UIButton * btn in emotionsBgOnCommentView.subviews)
    {
        if(btn.selected == YES)
        {
            NSLog(@"Tag:%d", btn.tag);
            [selBtnArr addObject:[NSNumber numberWithInt:btn.tag]];   
        }
    }
    
    albumJacketView.image = [UIImage resizedImage:[self combineWithEmoticon:selBtnArr] inRect:CGRectMake(0, 0, 270, 270)];
//    albumJacketView.image = [self combineWithEmoticon:selBtnArr];
}

- (void)imageEditOnAction
{
    imageEditManager = [ImageEditManager sharedObject];
    //    [imageEditManager setImage:_album.recordStroke];
    [imageEditManager setImage:[UIImage imageNamed:@"pop_yellow_like_0.png"]];
    NSLog(@"Image:%f %f", _album.recordStroke.size.width, _album.recordStroke.size.height);
    [imageEditManager combineWithOtherImage:nil];
    UIImage * combinedImg = [[imageEditManager getImage] retain];
    
    UIImageView * albumView = [[UIImageView alloc] initWithFrame:CGRectMake(140, 0, 176, 176)]; //228
    //    CALayer * albumjaketlayer = [albumView layer];
    //    [albumjaketlayer setMasksToBounds:YES];
    //    [albumjaketlayer setCornerRadius:HistoryAlbumLength / 2.0];
//    albumView.image = [self combineWithEmoticon:nil];
    [self.view addSubview:albumView];
    [albumView release];
    
    UIImageView * albumView2 = [[UIImageView alloc] initWithFrame:CGRectMake(140, 0, 176, 176)]; //228
    //    CALayer * albumjaketlayer = [albumView layer];
    //    [albumjaketlayer setMasksToBounds:YES];
    //    [albumjaketlayer setCornerRadius:HistoryAlbumLength / 2.0];
    albumView2.image = [UIImage imageNamed:@"pop_yellow_like_0.png"];
    //    [self.view addSubview:albumView2];
    [albumView2 release];
}

- (void)commentButtonAction:(id)sender
{
    UIButton * commentBtn = (UIButton *)sender;
    
    if([commentBtn isEqual:chatBtn])
    {
        [commentArrow setFrame:CGRectMake(40, 20, 5, 10)];
        commentView2.hidden = YES;
        chatBtn.selected = YES;
        [chatTextView becomeFirstResponder];
        chatTextView.hidden = NO;
        emotionBtn.selected = NO;
        albumJacketView.hidden = YES;
        mapBtn.selected = NO;
        mapView.hidden = YES;
        searchBar.hidden = YES;
        mapTableView.hidden = YES;
        emotionsBgOnCommentView.hidden = YES;
    }
    else if([commentBtn isEqual:emotionBtn])
    {
        [commentArrow setFrame:CGRectMake(40, 55, 5, 10)];
        commentView2.hidden = NO;
        chatBtn.selected = NO;
        [chatTextView resignFirstResponder];
        chatTextView.hidden = YES;
        emotionBtn.selected = YES;
        albumJacketView.hidden = NO;
        mapBtn.selected = NO;
        mapView.hidden = YES;
        searchBar.hidden = YES;
        mapTableView.hidden = YES;
        emotionsBgOnCommentView.hidden = NO;
    }
    else 
    {
        [commentArrow setFrame:CGRectMake(40, 90, 5, 10)];
        commentView2.hidden = NO;
        [chatTextView resignFirstResponder];
        chatTextView.hidden = YES;
        chatBtn.selected = NO;
        emotionBtn.selected = NO;
        albumJacketView.hidden = YES;
        mapBtn.selected = YES;
        mapView.hidden = NO;
        searchBar.hidden = NO;
        mapTableView.hidden = NO;
        emotionsBgOnCommentView.hidden = YES;

        [lbsManager setCurrentLocationWithDesiredAccuracy:kCLLocationAccuracyBest distanceFilter:kCLDistanceFilterNone];
    }
}

- (void)socialButtonOnAction:(id)sender
{
    UIButton * socialBtn = (UIButton *)sender;
    socialBtn.selected = !socialBtn.selected;
    
    if([socialBtn isEqual:facebookBtn])
    {
        [UserDefaultHelper setFBAssociteState:socialBtn.selected];
        if(socialBtn.selected == YES)
        {
            if ([fbManager Logined]==NO) {
                fbManager = [FBManager sharedObject];
                [fbManager setDelegate:self];
                //        NSLog(@"ACCESS:%@ EXPRIATIONDATE:%@",fbManager.facebook.accessToken, fbManager.facebook.expirationDate);
                [fbManager login];
            }
        }
    }
    else if([socialBtn isEqual:twitterBtn])
    {
        [UserDefaultHelper setTWAssociteState:socialBtn.selected];        
        #define kOAuthConsumerKey		@"A7OBF5sIzvsv0jX8IfuKYA"		
        #define kOAuthConsumerSecret	@"uwrmWzoT30oUzXZVT8ROiWV1nLZklUNihzGTYdfiXM"	
        
        if(socialBtn.selected == YES)
        {
            // Twitter Initialization / Login Code Goes Here
            if(!_engine){  
                _engine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate:self];  
                _engine.consumerKey    = kOAuthConsumerKey;  
                _engine.consumerSecret = kOAuthConsumerSecret;  
            }  	
        
            if(![_engine isAuthorized]){  
                UIViewController *controller = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine:_engine delegate:self];  
                
                if (controller){  
                    [self presentModalViewController: controller animated: YES];  
                }  
            }  
        }
        
    }
    else if([socialBtn isEqual:sendBtn])
    {
        if([UserDefaultHelper getFBAssociteState] == YES)
        {
            if ([fbManager Logined]==YES){ 
                fbManager = [FBManager sharedObject];
                [fbManager setDelegate:self];
                
                if(selectedPlaceID == nil)
                {
                    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:@"위치를 선택해 주시기 바랍니다." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
                    [alertView show];
                    [alertView release];
                    return;
                }
                
                NSString * message = [NSString stringWithFormat:@"%@\n%@\n%@", chatTextView.text, musicName.text, artist.text];
                [fbManager PicUploadWithImage:albumJacketView.image withText:message place:selectedPlaceID];
            }
        }
        
        if([UserDefaultHelper getTWAssociteState] == YES)
        {
            if([[mapView annotations] count] == 0)
            {
                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:@"위치를 선택해 주시기 바랍니다." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
                [alertView show];
                [alertView release];
                return;
            }
            
            CustomPlacemark * placemark = [[mapView annotations] objectAtIndex:0];
            NSString * latPayLoad = [[NSNumber numberWithDouble:placemark.coordinate.latitude] stringValue];
            NSString * longPayLoad = [[NSNumber numberWithDouble:placemark.coordinate.longitude] stringValue];
//            NSString * placeID = @"df51dec6f4ee2b2c";
            if([self cachedTwitterOAuthDataForUsername:_engine.username] != nil)
            {
                if(!_engine){  
                    _engine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate:self];  
                    _engine.consumerKey    = kOAuthConsumerKey;  
                    _engine.consumerSecret = kOAuthConsumerSecret;  
                }  	

                if(![_engine isAuthorized]){  
                    UIViewController *controller = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine:_engine delegate:self];  
                    
                    if (controller){  
                        [self presentModalViewController: controller animated: YES];  
                    }  
                }  

                [_engine uploadImage:albumJacketView.image text:chatTextView.text latitude:latPayLoad longtitude:longPayLoad];
            }
        }        
    }
}

- (void)mainButtonAction:(UIButton *)mainbutton
{
    if(mainbutton.tag == 0)
    {
        [buttonArrow setFrame:CGRectMake(37.5, 120, 15, 5)];
        UIAlertView * nowPlayingAlert = [[UIAlertView alloc] initWithTitle:nil message:@"앨범을 플레이리스트에 추가하시겠습니까?" delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"확인", nil];
        [nowPlayingAlert show];
        infoLabel.text = @"Add NowPlaying";
    }
    else if(mainbutton.tag == 1)
    {
        [buttonArrow setFrame:CGRectMake(37.5 + buttonLength + buttonInterval, 120, 15, 5)];
        [line setHidden:NO];
        [webView setHidden:NO];
        [sameAlbumBg setHidden:YES];
        [lyricsBg setHidden:YES];
        [commentView setHidden:YES];
        [commentView2 setHidden:YES];
        [chatTextView resignFirstResponder];
        infoLabel.text = @"YouTube";
    }
    else if(mainbutton.tag == 2)
    {
        [buttonArrow setFrame:CGRectMake(37.5 + (buttonLength + buttonInterval)*2, 120, 15, 5)];
        [line setHidden:YES];
        [webView setHidden:YES];
        [sameAlbumBg setHidden:NO];
        [lyricsBg setHidden:YES];
        [commentView setHidden:YES];
        [commentView2 setHidden:YES];
        [chatTextView resignFirstResponder];
        infoLabel.text = @"Album Info";
    }
    else if(mainbutton.tag == 3)
    {
        [buttonArrow setFrame:CGRectMake(37.5 + (buttonLength + buttonInterval)*3, 120, 15, 5)];
        [line setHidden:YES];
        [webView setHidden:YES];
        [sameAlbumBg setHidden:YES];
        [lyricsBg setHidden:NO];
        [commentView setHidden:YES];
        [commentView2 setHidden:YES];
        [chatTextView resignFirstResponder];
        infoLabel.text = @"Lyrics";
    }
    else if(mainbutton.tag == 4)
    {
        [buttonArrow setFrame:CGRectMake(37.5 + (buttonLength + buttonInterval)*4, 120, 15, 5)];
        [line setHidden:YES];
        [webView setHidden:YES];
        [sameAlbumBg setHidden:YES];
        [lyricsBg setHidden:YES];
        [commentView setHidden:NO];
        [commentView2 setHidden:NO];
        if (chatBtn.selected) {
            [commentView2 setHidden:YES];
            [chatTextView becomeFirstResponder];
        }
        infoLabel.text = @"Comments";
    }
}

- (void)cancelOnAction
{
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDuration:0.1];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(cancelDone)];
    self.view.frame = CGRectMake(0, 460, 320, 460);
    [UIView commitAnimations];
}

- (void)cancelDone
{
    emotionAniFinished = YES;
    [self.view removeFromSuperview];
    [self release];
}

- (UIImage * )combineWithEmoticon:(NSArray *)emotionArr
{
    UIImage * selImage = _album.recordStroke;
//    UIImage * selImage = [UIImage resizedImage2:_album.recordStroke inSize:CGSizeMake(270, 270)];
    CGImageRef cRef = CGImageRetain(selImage.CGImage);
    NSData * pixelData = (NSData*)CGDataProviderCopyData(CGImageGetDataProvider(cRef));
    size_t width = CGImageGetWidth(cRef);
    size_t height = CGImageGetHeight(cRef);
    unsigned char * pixelBytes = (unsigned char *)[pixelData bytes];
    
    int i = 0;
    for(NSNumber * emotionNum in emotionArr)
    {
        UIImage * selImage2 = [UIImage imageNamed:[NSString stringWithFormat:@"pop_yellow_like_%d.png", emotionNum.intValue]];
        CGImageRef cRef2 = CGImageRetain(selImage2.CGImage);
        NSData * pixelData2 = (NSData*)CGDataProviderCopyData(CGImageGetDataProvider(cRef2));
        size_t comWidth = CGImageGetWidth(cRef2);
        size_t comHeight = CGImageGetHeight(cRef2);
        NSLog(@"width:%zu height:%zu comWitdh:%zu comHeight:%zu", width, height, comWidth, comHeight);
        unsigned char * pixelBytes2 = (unsigned char *)[pixelData2 bytes];
        
        int j = i / 2.0; int k = i - j * 2;
        for(int y = j * (comHeight + 5); y < j * (comHeight + 5) + comHeight; y++) {
            for(int x = k * (comWidth + 5); x < k * (comWidth + 5) + comWidth; x++) {
                
                int index = 4 * y * width + 4 * x;
                int index2 = 4 * (y - (j * (comHeight + 5))) * comWidth + 4 * (x - (k * (comWidth + 5)));
                
                int clear = pixelBytes2[index2] + pixelBytes2[index2 + 1] + pixelBytes2[index2 + 2] + pixelBytes2[index2 + 3];
                if(clear != 0)
                {
                    pixelBytes[index] = pixelBytes2[index2];
                    pixelBytes[index + 1] = pixelBytes2[index2 + 1];
                    pixelBytes[index + 2] = pixelBytes2[index2 + 2];
                    pixelBytes[index + 3] = pixelBytes2[index2 + 3];
                }
            }
        }
        
        i++;
    }
    
    CFDataRef imgData = (CFDataRef)pixelData;
    CGDataProviderRef imgDataProvider = CGDataProviderCreateWithCFData(imgData);
    
    size_t bitsPerComponent = CGImageGetBitsPerComponent(cRef);
    size_t bitsPerPixel = CGImageGetBitsPerPixel(cRef);
    size_t bytesPerRow = CGImageGetBytesPerRow(cRef);
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(cRef);
    CGBitmapInfo info = CGImageGetBitmapInfo(cRef);
    CGFloat * decode = NULL;
    BOOL shouldInteroplate = NO;
    CGColorRenderingIntent intent = CGImageGetRenderingIntent(cRef);
    
    CGImageRef throughCGImage = CGImageCreate(width, height, bitsPerComponent, bitsPerPixel, bytesPerRow, colorSpace, info, imgDataProvider, decode, shouldInteroplate, intent);
    UIImage * newImage = [UIImage imageWithCGImage:throughCGImage];
    
    return newImage;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UITableView Delegate & DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if(searchedPlace != nil)
        return [searchedPlace count];
        
        

    return 0;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"albumInfoTitleHistoryCell_%d", indexPath.row];
    
    albumInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[albumInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];        
    }
    NSDictionary * place = [searchedPlace objectAtIndex:indexPath.row];
    cell.textLabel.text = [place objectForKey:@"name"]; 
    NSLog(@"place:%@",place);

	
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedPlaceID = [[searchedPlace objectAtIndex:indexPath.row] objectForKey:@"id"];
    
    CLLocationCoordinate2D locCoordinate;
    locCoordinate.longitude = [[[[searchedPlace objectAtIndex:indexPath.row] objectForKey:@"location"] objectForKey:@"longitude"] doubleValue];
    locCoordinate.latitude = [[[[searchedPlace objectAtIndex:indexPath.row] objectForKey:@"location"] objectForKey:@"latitude"] doubleValue];
    
    NSLog(@"%f %f", locCoordinate.latitude, locCoordinate.longitude);
    [self refreshPlaceMarkOnMap:locCoordinate];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        [NowPlaying saveNowPlaying:[persistentID doubleValue]];
        [[DataModelManager sharedManager] saveToPersistentStore];
    }
    else {
        if (!webView.hidden){
            [buttonArrow setFrame:CGRectMake(37.5 + buttonLength + buttonInterval, 120, 15, 5)];
            infoLabel.text = @"YouTube";
        } else if (!sameAlbumBg.hidden){
            [buttonArrow setFrame:CGRectMake(37.5 + (buttonLength + buttonInterval)*2, 120, 15, 5)];
            infoLabel.text = @"Album Info";
        } else if (!lyricsBg.hidden) {
            [buttonArrow setFrame:CGRectMake(37.5 + (buttonLength + buttonInterval)*3, 120, 15, 5)];
            infoLabel.text = @"Lyrics";
        } else {
            [buttonArrow setFrame:CGRectMake(37.5 + (buttonLength + buttonInterval)*4, 120, 15, 5)];
            infoLabel.text = @"Comments";
        }
    }
}

#pragma mark - UITextViewDelegate

#pragma mark - LBSManagerDelegate
- (void)locationFounded:(CustomPlacemark *)placeMark region:(MKCoordinateRegion)region
{
    NSLog(@"Geo Info:%f %f", region.center.latitude, region.center.longitude);
    
    [self removeAnnotationsInMapView];
    
	[mapView addAnnotation:placeMark];
	[placeMark release];
	[mapView setRegion:region animated:TRUE];
    
//    [lbsManager searchAddressFromCoordinate:region.center];
    [lbsManager apiGraphSearchPlace:region.center];
//    [lbsManager searchAddressFromCoordinateWithCLGeocoder:region.center];
}

- (void)setRegion:(MKCoordinateRegion)region
{
	[mapView setRegion:region];
}

- (void)removeAnnotationsInMapView
{
	NSArray *annotationArrs = mapView.annotations;
	if(annotationArrs!=nil)
	{
		//NSLog(@"Remove all annotations!");
		[mapView removeAnnotations:annotationArrs];
	}
}

- (void)addAnnotation:(Annotation *)annotation
{
//	[mapView addAnnotation:annotation];


}

- (void)receivedSearchPlace:(NSArray *)places
{
    [mapTableViewIndicator stopAnimating];
    self.searchedPlace = places;
    [mapTableView reloadData];
}

#pragma mark - MAP Associate Function
- (void)refreshPlaceMarkOnMap:(CLLocationCoordinate2D)coordinate
{
    [self removeAnnotationsInMapView];
    
    MKCoordinateRegion region;
	MKCoordinateSpan span;
	span.latitudeDelta = 0.002;
	span.longitudeDelta = 0.002;
	CLLocationCoordinate2D resultCoord = coordinate;	
	
	region.span = span;
	region.center = resultCoord;
	
	CustomPlacemark *currentPlaceMark = [[CustomPlacemark alloc] initWithRegion:region];
    [mapView addAnnotation:currentPlaceMark];
    [currentPlaceMark release];
    [mapView setRegion:region];
}

#pragma mark - UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)aSearchBar
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];    
    [commentView2 setFrame:CGRectMake(10, 120, 290, 120)];
    [mapTableView setFrame:CGRectMake(10, 50, 270, 60)];
    [UIView commitAnimations];

    [aSearchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)aSearchBar
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0];    
    [commentView2 setFrame:CGRectMake(10, 240, 290, 215)];
    [mapTableView setFrame:CGRectMake(10, 50, 270, 155)];
    [UIView commitAnimations];
    
	[lbsManager searchCoordinatesForAddress:[aSearchBar text]];
	[aSearchBar resignFirstResponder];
}


- (void)searchBarCancelButtonClicked:(UISearchBar *)aSearchBar
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0];    
    [commentView2 setFrame:CGRectMake(10, 240, 290, 215)];
    [mapTableView setFrame:CGRectMake(10, 50, 270, 155)];
    [UIView commitAnimations];

    [aSearchBar resignFirstResponder];
}

#pragma mark - FBManagerDelegate
- (void)fbDidLogin
{
    facebookBtn.selected = YES;
    [UserDefaultHelper setFBAssociteState:YES];
}

- (void)fbDidLogout
{
    facebookBtn.selected = NO;
    [UserDefaultHelper setFBAssociteState:NO];
}
    
- (void)uploadFBFinished
{
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:@"페이스북 공유에 성공하였습니다." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}
//=============================================================================================================================
#pragma mark - SA_OAuthTwitterEngineDelegate
- (void) storeCachedTwitterOAuthData: (NSString *) data forUsername: (NSString *) username {
	NSUserDefaults			*defaults = [NSUserDefaults standardUserDefaults];
    
	[defaults setObject: data forKey: @"authData"];
	[defaults synchronize];
}

- (NSString *) cachedTwitterOAuthDataForUsername: (NSString *) username {
	return [[NSUserDefaults standardUserDefaults] objectForKey: @"authData"];
}

- (void) twitterOAuthConnectionFailedWithData: (NSData *) data
{
    NSLog(@"Error");
}

- (void)imageUploaded
{
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:@"트위터 공유에 성공하였습니다." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}
//=============================================================================================================================
#pragma mark - TwitterEngineDelegate
- (void) requestSucceeded: (NSString *) requestIdentifier {
	NSLog(@"Request %@ succeeded", requestIdentifier);
}

- (void) requestFailed: (NSString *) requestIdentifier withError: (NSError *) error {
	NSLog(@"Request %@ failed with error: %@", requestIdentifier, error);
}

#pragma mark - SA_OAuthTwitterControllerDelegate
- (void) OAuthTwitterController: (SA_OAuthTwitterController *) controller authenticatedWithUsername: (NSString *) username
{
    twitterBtn.selected = YES;
    [UserDefaultHelper setTWAssociteState:YES];
}

- (void) OAuthTwitterControllerCanceled: (SA_OAuthTwitterController *) controller
{
    twitterBtn.selected = NO;
    [UserDefaultHelper setTWAssociteState:NO];

}
@end
