//
//  albumInfoViewController.m
//  iLivinMusicUIUX
//
//  Created by jaehoon lee on 5/28/12.
//  Copyright (c) 2012 Kaist. All rights reserved.
//

#import "albumInfoViewController.h"
#import "album.h"
#import "selfMusicHistoryCell.h"
#import "NowPlaying.h"
#import "DataModelManager.h"
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
    }
    return self;
}

- (void)dealloc
{
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

    [self setYoutubeView];
    [self setSameAlbumView];
    [self setLyricView];
    [self setCommentView];
    
    [self setButtonView];
    
    closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(270, 0, 50, 30)];
    [closeBtn setImage:[UIImage imageNamed:@"pop_yellow_album_storage_bubble.png"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(cancelOnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeBtn];
    [closeBtn release];
    
    UIButton * imageEdit = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    imageEdit.frame = CGRectMake(70, 0, 50, 20);
    [imageEdit setTitle:@"이미지" forState:UIControlStateNormal];
    [imageEdit addTarget:self action:@selector(imageEditOnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:imageEdit];    
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
    
    emotion = [[UIButton alloc] initWithFrame:CGRectMake(250, 35, 30, 30)];
    [emotion setImage:[UIImage imageNamed:@"pop_yellow_like_2.png"] forState:UIControlStateNormal];
    [emotion addTarget:self action:@selector(emoticonButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:emotion];
    [emotion release];
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
    
    chatTextView = [[UITextView alloc] initWithFrame:CGRectMake(43, 18, 203, 84)];
    [chatTextView setBackgroundColor:[UIColor clearColor]];
    [commentView addSubview:chatTextView];
    [chatTextView release];

    emotionBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 45, 30, 30)];
    [emotionBtn setImage:[UIImage imageNamed:@"pop_yellow_album_info_sns_emotion.png"] forState:UIControlStateNormal];
    [emotionBtn setImage:[UIImage imageNamed:@"pop_yellow_album_info_sns_emotion_selected.png"] forState:UIControlStateSelected];
    [emotionBtn addTarget:self action:@selector(commentButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [commentView addSubview:emotionBtn];
    [emotionBtn release];
    
    albumJacketView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 270, 195)];
    albumJacketView.image = [History readImage:albumHistory.albumImageURL title:albumHistory.title];
    [commentView2 addSubview:albumJacketView];
    [albumJacketView release];

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
    
    searchedPlace = nil;
    
    [self commentButtonAction:chatBtn];
}

- (void)emotionImageConf
{
    emotionsBg = [[UIImageView alloc] initWithFrame:CGRectMake(96, 20, 170, 85)];
    [emotionsBg setImage:[UIImage imageNamed:@"pop_yellow_like_tag.png"]];
    emotionsBg.userInteractionEnabled = YES;
    [self.view addSubview:emotionsBg];
    [emotionsBg release];
    
    for(int i = 0; i < 7; i++)
    {
        int j = i / 6.0; int k = i - j * 6;
        UIButton * emotionOpt = [[UIButton alloc] initWithFrame:CGRectMake(10 + 26 * k, 5 + 26 * j, 20, 20)];
        [emotionOpt addTarget:self action:@selector(emotionButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [emotionOpt setImage:[UIImage imageNamed:@"pop_yellow_like_selected.png"] forState:UIControlStateSelected];
        UIImageView * emotionImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        NSString *imageName = [NSString stringWithFormat:@"pop_yellow_like_%d.png", i];
        [emotionImg setImage:[UIImage imageNamed:imageName]];
        [emotionOpt addSubview:emotionImg];
        [emotionsBg addSubview:emotionOpt];
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
    }
}

- (void)emotionButtonAction:(id)sender
{
    UIButton * emotionOpt = (UIButton *)sender;
    emotionOpt.selected = !emotionOpt.selected;
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
        emotionBtn.selected = NO;
        albumJacketView.hidden = YES;
        mapBtn.selected = NO;
        mapView.hidden = YES;
        searchBar.hidden = YES;
        mapTableView.hidden = YES;
    }
    else if([commentBtn isEqual:emotionBtn])
    {
        [commentArrow setFrame:CGRectMake(40, 55, 5, 10)];
        commentView2.hidden = NO;
        chatBtn.selected = NO;
        [chatTextView resignFirstResponder];
        emotionBtn.selected = YES;
        albumJacketView.hidden = NO;
        mapBtn.selected = NO;
        mapView.hidden = YES;
        searchBar.hidden = YES;
        mapTableView.hidden = YES;
    }
    else 
    {
        [commentArrow setFrame:CGRectMake(40, 90, 5, 10)];
        commentView2.hidden = NO;
        [chatTextView resignFirstResponder];
        chatBtn.selected = NO;
        emotionBtn.selected = NO;
        albumJacketView.hidden = YES;
        mapBtn.selected = YES;
        mapView.hidden = NO;
        searchBar.hidden = NO;
        mapTableView.hidden = NO;

        [lbsManager setCurrentLocationWithDesiredAccuracy:kCLLocationAccuracyBest distanceFilter:kCLDistanceFilterNone];
    }
}

- (void)socialButtonOnAction:(id)sender
{
    UIButton * socialBtn = (UIButton *)sender;
    socialBtn.selected = !socialBtn.selected;
    
    if([socialBtn isEqual:facebookBtn])
    {
        if ([fbManager Logined]==NO) {
            fbManager = [FBManager sharedObject];
            [fbManager setDelegate:self];
            //        NSLog(@"ACCESS:%@ EXPRIATIONDATE:%@",fbManager.facebook.accessToken, fbManager.facebook.expirationDate);
            [fbManager login];
        }
    }
    else if([socialBtn isEqual:twitterBtn])
    {

    }
    else if([socialBtn isEqual:sendBtn]){
        
    }
}

- (void)mainButtonAction:(UIButton *)mainbutton
{
    if(mainbutton.tag == 0)
    {
        [buttonArrow setFrame:CGRectMake(37.5, 120, 15, 5)];
        UIAlertView * nowPlayingAlert = [[UIAlertView alloc] initWithTitle:nil message:@"앨범을 플레이리스트에 추가하시겠습니까?" delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"확인", nil];
        [nowPlayingAlert show];
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
    albumView.image = [self combineWithEmoticon:nil];
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

- (UIImage * )combineWithEmoticon:(UIImage *)emoticonImg
{
    UIImage * selImage = _album.recordStroke;
    CGImageRef cRef = CGImageRetain(selImage.CGImage);
    NSData * pixelData = (NSData*)CGDataProviderCopyData(CGImageGetDataProvider(cRef));
    size_t width = CGImageGetWidth(cRef);
    size_t height = CGImageGetHeight(cRef);
    unsigned char * pixelBytes = (unsigned char *)[pixelData bytes];
    
    UIImage * selImage2 = [UIImage imageNamed:@"pop_yellow_like_0.png"];
    CGImageRef cRef2 = CGImageRetain(selImage2.CGImage);
    NSData * pixelData2 = (NSData*)CGDataProviderCopyData(CGImageGetDataProvider(cRef2));
    size_t comWidth = CGImageGetWidth(cRef2);
    size_t comHeight = CGImageGetHeight(cRef2);
    unsigned char * pixelBytes2 = (unsigned char *)[pixelData2 bytes];

    for(int y = 0; y < comHeight; y++) {
        for(int x = 0; x < comWidth; x++) {
            
            int index = 4 * y * width + 4 * x;
            int index2 = 4 * y * comWidth + 4 * x;
            
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

- (void)cancelDone
{
    [self.view removeFromSuperview];
    [self release];
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
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        NSDictionary * place = [searchedPlace objectAtIndex:indexPath.row];
        cell.textLabel.text = [place objectForKey:@"name"];
    }
	
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
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
        } else if (!sameAlbumBg.hidden){
            [buttonArrow setFrame:CGRectMake(37.5 + (buttonLength + buttonInterval)*2, 120, 15, 5)];
        } else if (!lyricsBg.hidden) {
            [buttonArrow setFrame:CGRectMake(37.5 + (buttonLength + buttonInterval)*3, 120, 15, 5)];
        } else {
            [buttonArrow setFrame:CGRectMake(37.5 + (buttonLength + buttonInterval)*4, 120, 15, 5)];
        }
    }
}

#pragma mark - UITextViewDelegate

#pragma mark - LBSManagerDelegate
- (void)locationFounded:(CustomPlacemark *)placeMark region:(MKCoordinateRegion)region
{
    NSLog(@"Geo Info:%f %f", region.center.latitude, region.center.longitude);
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
	[mapView addAnnotation:annotation];
}

- (void)receivedSearchPlace:(NSArray *)places
{
    self.searchedPlace = places;
    [mapTableView reloadData];
}

#pragma mark - UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];    
    [commentView2 setFrame:CGRectMake(10, 120, 290, 120)];
    [mapTableView setFrame:CGRectMake(10, 50, 270, 60)];
    [UIView commitAnimations];

}

- (void)searchBarSearchButtonClicked:(UISearchBar *)aSearchBar
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0];    
    [commentView2 setFrame:CGRectMake(10, 240, 290, 215)];
    [mapTableView setFrame:CGRectMake(10, 50, 270, 155)];
    [UIView commitAnimations];
//	[lbsManager searchCoordinatesForAddress:[aSearchBar text]];
//	[aSearchBar resignFirstResponder];
}

#pragma mark - FBManagerDelegate
- (void)fbDidLogin
{
    NSLog(@"fbDidLogin");
}
- (void)fbDidLogout
{

}
    
@end
