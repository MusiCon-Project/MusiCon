//
//  iLivinMusicMainViewController.m
//  iLivinMusicUIUX
//
//  Created by jaehoon lee on 2/11/12.
//  Copyright (c) 2012 Kaist. All rights reserved.
//

#import "iLivinMusicMainViewController.h"
#import "DataModelManager.h"
#import "History.h"
#import "AlbumInfo.h"
#import "FolderInfo.h"
#import "Album.h"
#import "NowPlaying.h"
#import "infoViewController.h"
#import "albumInfoViewController.h"
#import "UserDefaultHelper.h"
#import "UIImage+Transform.h"

@interface iLivinMusicMainViewController (internal)
- (void)setGesture;
- (void)setRecordView;
- (void)setAlbumView:(int)albumTotalCount;
- (void)setAlbumBgView;
- (void)setTableView;
- (void)setTimerAlarmView;
- (void)historyDataInitialize;
@end

typedef enum
{
    SongType,
    ArtistType,
    AlbumType,
    FolderType,
}MenuType;

@implementation iLivinMusicMainViewController
@synthesize record = _record;
@synthesize albumArray;
@synthesize opened;
@synthesize shouldSwipe;
@synthesize folderArray;
@synthesize slideButton;
@synthesize subMenus;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.frame = CGRectMake(0, 20, albumStorageOriginX + albumStorageAlbumSpace, self.view.frame.size.height);
//    UIImageView * bg = [[UIImageView alloc] initWithFrame:CGRectMake(albumOriginX, 0, AlbumStrokeLength  + albumStorageAlbumSpace/2, 460)];
    
    albumArray = [[NSMutableArray alloc] init];
    selectedAlbumArray = [[NSMutableArray alloc] init];
    subMenus = [[NSMutableArray alloc] init];
    albumsInFolderArr = [[NSMutableArray alloc] init];
    showingAlbumArray = [[NSMutableArray alloc] init];
    folderArray = [[NSMutableArray alloc] init];

    [self setRecordView];
    [self setTableView];
//    [self setTimerAlarmView];
    
//    [self setGesture];
//    [self setAlbumStorageCoverView];
    
    opened = NO;
    opening = NO;
    shouldSwipe = NO;
    shouldOneClickMove = NO;
    lastTouchX = 0.0;
    lastTouchY = 0.0;
    shouldScroll = NO;
    mainViewMoveMargin = albumStorageWidth - albumOriginX + albumStorageOriginX;
    albumVerticalMoveStarted = NO;
    albumVerticalMoveStartY = 0.0;
    tagOpened = NO;
    tagShuoldSwipe = NO;
    
    
    longLeftSwipeDetected = NO;
    folderAddActivated = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(volumeChanged) name:MPMusicPlayerControllerVolumeDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alarmNotification) name:ALARM_NOTI object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timerNotification) name:TIMER_NOTI object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(autoAlarmNotification) name:AUTO_ALARM_NOTI object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(autoTimerNotification) name:AUTO_TIMER_NOTI object:nil];
    [musicPlayer beginGeneratingPlaybackNotifications];
    
    audioHelper = [AudioHelper sharedObject];
    [audioHelper setDelegate:self];
    [audioHelper updateIPodLibrary];
    [self setAlbumBgView];
    
    //disable storage buttons
    [self disableAlbumStorageButtons:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [musicPlayer endGeneratingPlaybackNotifications];
    [albumArray release];
    [selectedAlbumArray release];
    [folderArray release];
    [showingAlbumArray release];
    
    [subMenus release];
    [albumsInFolderArr release];
    [super dealloc];
}

#pragma mark - View Configuration & History
- (void)setRecordView
{
    // album bg
    bg = [[UIImageView alloc] initWithFrame:CGRectMake(albumStorageOriginX, 0, 80.5, 529)];
    [bg setImage:[UIImage imageNamed:@"pop_yellow_album_storage_bg.png"]];
    [self.view addSubview:bg];
    [bg release];
    
    bgTop = [[UIImageView alloc] initWithFrame:CGRectMake(albumStorageOriginX, 0, 80.5, 460)];
    [bgTop setImage:[UIImage imageNamed:@"pop_yellow_album_storage_check.png"]];
    [self.view addSubview:bgTop];
    [bgTop release];

    //record
    _record = [[record alloc] initWithFrame:CGRectMake((albumOriginX - recordLength) / 2, recordMargin, recordLength, recordLength) type:RecordType];
    _record.parentViewCon = self;
    [self.view addSubview:_record];
    [_record release];  
    
    //volumeView
    musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
    NSInteger volumeSize = musicPlayer.volume * 15.0;
    volumeView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 70, 40, 120)];
    [volumeView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"pop_yellow_volume%d.png", volumeSize]]];
    [self.view addSubview:volumeView];
    [volumeView release];
    
    //recordLine
    recordLine * _recordLine = [[recordLine alloc] initWithFrame:CGRectMake(43, 23.5, recordLineWidth, recordLineHeight)];
    [_recordLine setDelegate:self];
    [self.view addSubview:_recordLine];
    [_recordLine release];  
    
    //set RecordLine in _record
    _record.RecordLine = _recordLine;
    
    //repeatButton
    repeatButton = [[UIButton alloc] initWithFrame:CGRectMake(255, 30, 35, 35)];
    [repeatButton setImage:[UIImage imageNamed:@"Repeat0.png"] forState:UIControlStateNormal];
    [repeatButton addTarget:self action:@selector(repeatButtonOnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:repeatButton];
    [repeatButton release];
    repeat = 0;
    
    //shuffleButton
    shuffleButton = [[UIButton alloc] initWithFrame:CGRectMake(270, 70, 30, 30)];
    [shuffleButton setImage:[UIImage imageNamed:@"shuffle_off.png"] forState:UIControlStateNormal];
    [shuffleButton addTarget:self action:@selector(shuffleButtonOnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shuffleButton];
    [shuffleButton release];
    shuffle = 0;
    
    MPVolumeView * mpview = [[MPVolumeView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
//    mpview.hidden = YES;
    [self.view addSubview:mpview];
    [mpview release];
}

- (void)setAlbumBgView
{   
    //slideButton
    slideButton = [[sliderButton alloc] initWithFrame:CGRectMake(270, 0, 50, 30)];
    [slideButton setImage:[UIImage imageNamed:@"pop_yellow_album_storage_bubble.png"] forState:UIControlStateNormal];
//    [slideButton addTarget:self action:@selector(slideButtonOnAction:) forControlEvents:UIControlEventTouchUpInside];
    [slideButton setDelegate:self];
    [self.view addSubview:slideButton];
    [slideButton release];

    //buttons
    shopButton = [[UIButton alloc] initWithFrame:CGRectMake(albumStorageOriginX + albumStorageWidth + 10 - 40, 0, 40, 40)];
    [shopButton setImage:[UIImage imageNamed:@"pop_yellow_album_storage_shop_icon.png"] forState:UIControlStateNormal];
    [shopButton addTarget:self action:@selector(basicButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shopButton];
    [shopButton release];

    infoTrashButton = [[UIButton alloc] initWithFrame:CGRectMake(albumStorageOriginX + albumStorageWidth + 10 - 40, 460 - 40, 40, 40)];
    [infoTrashButton setImage:[UIImage imageNamed:@"pop_yellow_album_storage_info.png"] forState:UIControlStateNormal];
    [infoTrashButton addTarget:self action:@selector(infoButtonOnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:infoTrashButton];
    [infoTrashButton release];
    
    recentMusicButton = [[UIButton alloc] initWithFrame:CGRectMake(albumStorageOriginX, 0, AlbumStrokeLength, AlbumStrokeLength)];
    recentMusicButton.tag = 0;
    [recentMusicButton setImage:[UIImage imageNamed:@"pop_yellow_album_storage_now_playing.png"] forState:UIControlStateNormal];
    [recentMusicButton addTarget:self action:@selector(basicButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:recentMusicButton];
    [recentMusicButton release];
    
    menuButton = [[UIButton alloc] initWithFrame:CGRectMake(albumStorageOriginX + albumStorageWidth + 10 - AlbumStrokeLength, AlbumStrokeLength * 3/4, AlbumStrokeLength, AlbumStrokeLength)];
    menuButton.tag = 1;
    [menuButton setImage:[UIImage imageNamed:@"pop_yellow_album_storage_song.png"] forState:UIControlStateNormal];
    [menuButton addTarget:self action:@selector(basicButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:menuButton];
    [menuButton release];
    
    selectAllButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, AlbumStrokeLength, AlbumStrokeLength)];
    [selectAllButton setImage:[UIImage imageNamed:@"pop_yellow_album_storage_clickall.png"] forState:UIControlStateNormal];
    [selectAllButton addTarget:self action:@selector(selectAll:) forControlEvents:UIControlEventTouchUpInside];
    [selectAllButton setHidden:YES];
    [self.view addSubview:selectAllButton];
    [selectAllButton release];
    
    selectedFolderButton = [[folderButton alloc] initWithFrame:CGRectMake(0, 0, AlbumStrokeLength, AlbumStrokeLength)];
    [selectedFolderButton setCover:YES];
    [selectedFolderButton setHidden:YES];
    [selectedFolderButton setSelected:YES];
    [selectedFolderButton addTarget:self action:@selector(folderButtonOnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:selectedFolderButton];
    [selectedFolderButton release];
    
    albumsIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(320 + 20.25, 215, 30, 30)];
    [albumsIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    [self.view addSubview:albumsIndicator];
    [albumsIndicator startAnimating];
    [albumsIndicator release];
    
    preSelectedmenu = 0;
    preSelectedAlbumStorageMenu = 2;
}

- (void)setTableView
{
    //retrieve Data from DataModel
    [self historyDataInitialize];
    
    //header View
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 260, albumOriginX, HistoryHeaderHeight)];    
    UIView * line01 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, HistoryHeaderLineLength, 2)];
    [line01 setBackgroundColor:[UIColor grayColor]];
    UIView * line02 = [[UIView alloc] initWithFrame:CGRectMake(albumOriginX - HistoryHeaderLineLength, 0, HistoryHeaderLineLength, 2)];
    [line02 setBackgroundColor:[UIColor grayColor]];
    UILabel * dateTitle = [[UILabel alloc] initWithFrame:CGRectMake(120, 0, 80, HistoryHeaderHeight)];
    [dateTitle setFont:[UIFont fontWithName:@"ArialRoundedMTBold" size:10.0f]];
    [dateTitle setText:@"TODAY"];
    [dateTitle setTextAlignment:UITextAlignmentCenter];
    [dateTitle setTextColor:[UIColor grayColor]];
//    [headerView addSubview:line01];
//    [headerView addSubview:line02];
    [headerView addSubview:dateTitle];
    [line01 release];
    [line02 release];
    [dateTitle release];
    [self.view addSubview:headerView];
    
    //HistoryTableView    
    _musicHistoryTableView = [[musicHistoryTableView alloc] initWithFrame:CGRectMake(0, 270, albumStorageOriginX, 460-270)];
    _musicHistoryTableView.delegate = _musicHistoryTableView;
    _musicHistoryTableView.dataSource = _musicHistoryTableView;
    _musicHistoryTableView.parentViewCon = self;
    _musicHistoryTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_musicHistoryTableView];
    [_musicHistoryTableView release];
}

- (void)setTimerAlarmView
{
    timerButton = [[utilButton alloc] initWithFrame:CGRectMake(timeButtonMargin, 200, 50, 59) withButtonType:TimerType buttonPos:LeftButton];
    timerButton.Record = _record;
    [self.view addSubview:timerButton];
    [timerButton release];
    
    alarmButton = [[utilButton alloc] initWithFrame:CGRectMake(albumOriginX - timeButtonMargin - 50, 200, 50, 59) withButtonType:AlarmType buttonPos:RightButton];
    alarmButton.Record = _record;
    [self.view addSubview:alarmButton];
    [alarmButton release];
}

//Added by The Finest Artist at 6.11
- (void)setAlbumStorageCoverView
{
    // album storage cover
    UIImageView * bg_cover = [[UIImageView alloc] initWithFrame:CGRectMake(albumStorageOriginX, 0, 70, 460)];
    [bg_cover setImage:[UIImage imageNamed:@"pop_yellow_album_storage_bg_check@2x.png"]];
    [self.view addSubview:bg_cover];
    [bg_cover release];
}

- (void)setGesture
{
    UITapGestureRecognizer *tapGesture;
    tapGesture = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureTapped:)] autorelease]; 
    tapGesture.delegate = self; 
    tapGesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapGesture];
}

- (void)gestureTapped:(UIGestureRecognizer *)sender{
    if (sender.state == UIGestureRecognizerStateEnded) {
        for (album * _album in albumArray) {
            [_album setSelect:NO];
        }
    }
}

#pragma mark - albumConfiguration
//Modified by The Finest Artist at 5.29
- (void)setAlbumView:(int)albumTotalNum
{
    //select All
    [selectAllButton setFrame:CGRectMake(albumStorageOriginX, (albumStorageAlbumSpace/2.0)*2, AlbumStrokeLength, AlbumStrokeLength)];
    [selectAllButton setHidden:NO];
    
    //albums
    for (int i = 0; i < albumTotalNum; i++) 
    {
        album * _album;
        if(i%2 != 0)
        {
            _album = [[album alloc] initWithFrame:CGRectMake(albumStorageOriginX, (albumStorageAlbumSpace/2.0) * (i+3), AlbumStrokeLength, AlbumStrokeLength)];
        }
        else
        {
            _album = [[album alloc] initWithFrame:CGRectMake(albumStorageOriginX + albumStorageAlbumSpace/2.0, (albumStorageAlbumSpace/2.0) * (i+3), AlbumStrokeLength, AlbumStrokeLength)];
        }
        _album.userInteractionEnabled = NO;
        [_album setDelegate:self];
        [_album setMainViewCon:self];
        
        [self.view addSubview:_album];
        [albumArray addObject:_album];
    }
}

- (void)setArtistSortView
{
    //set Folder Arr
    [folderArray removeAllObjects];
    
    //selectAll
    [selectAllButton setHidden:YES];
    
    NSMutableDictionary * artistDic = [[NSMutableDictionary alloc] init];
    
    for (album * _album in albumArray) 
    {
        folderButton * artistFol = [artistDic objectForKey:_album.artist];
        if(artistFol == nil)
        {
            artistFol = [[folderButton alloc] init];
            artistFol.albumJacket.image = _album.albumjaket.image;
            artistFol.recordStroke = _album.recordStroke;
            artistFol.mainViewCon = self;
            artistFol.artist = _album.artist;
            [artistFol setCover:NO];
//            [artistFol setAlbumjaket:_album.smalljaket bigImage:_album.bigjaket recordImage:_album.recordStroke];
            [artistDic setObject:artistFol forKey:_album.artist];
        }
    }
        
    int i = 2;
    for (NSString * key in [artistDic allKeys]) 
    {
        folderButton * _album = [artistDic objectForKey:key];
        _album.index = i - 2;
        _album.folderType = ArtistButtonType;
        [_album addTarget:self action:@selector(folderButtonOnAction:) forControlEvents:UIControlEventTouchUpInside];
        if(i%2 ==0)
        {
            _album.frame = CGRectMake(albumStorageOriginX, (albumStorageAlbumSpace/2.0) * i, AlbumStrokeLength, AlbumStrokeLength);
//            _album.initialFrame = CGRectMake(albumStorageOriginX, 1 + (albumStorageAlbumSpace/2) * i, AlbumStrokeLength, AlbumStrokeLength);
        }
        else
        {
            _album.frame = CGRectMake(albumStorageOriginX + albumStorageAlbumSpace/2.0, (albumStorageAlbumSpace/2.0) * i, AlbumStrokeLength, AlbumStrokeLength);
//            _album.initialFrame = CGRectMake(albumStorageOriginX, 1 + (albumStorageAlbumSpace/2) * i, AlbumStrokeLength, AlbumStrokeLength);
        }
//        [_album setDelegate:self];
//        [_album setMainViewCon:self];
        
        [self.view addSubview:_album];
        [_album release];
        [subMenus addObject:_album];
        
        i++;
    }    
}

- (void)setAlbumTitleSortView
{
    //selectAll
    [selectAllButton setHidden:YES];
    
    NSMutableDictionary * artistDic = [[NSMutableDictionary alloc] init];
    
    for (album * _album in albumArray) 
    {
        folderButton * artistFol = [artistDic objectForKey:_album.albumTitle];
        if(artistFol == nil)
        {
            artistFol = [[folderButton alloc] init];
            artistFol.albumJacket.image = _album.albumjaket.image;
            artistFol.albumTitle = _album.albumTitle;
            artistFol.recordStroke = _album.recordStroke;
            artistFol.mainViewCon = self;

            [artistFol setCover:NO];
//            [artistFol setAlbumjaket:_album.smalljaket bigImage:_album.bigjaket recordImage:_album.recordStroke];
            [artistDic setObject:artistFol forKey:_album.albumTitle];
        }
    }
    
    int i = 2;
    for (NSString * key in [artistDic allKeys]) 
    {
        folderButton * _album = [artistDic objectForKey:key];
        _album.index = i - 2;
        _album.folderType = AlbumTitleButtonType;
        [_album addTarget:self action:@selector(folderButtonOnAction:) forControlEvents:UIControlEventTouchUpInside];
        if(i%2 ==0)
        {
            _album.frame = CGRectMake(albumStorageOriginX, (albumStorageAlbumSpace/2.0) * i, AlbumStrokeLength, AlbumStrokeLength);
        }
        else
        {
            _album.frame = CGRectMake(albumStorageOriginX + albumStorageAlbumSpace/2.0, (albumStorageAlbumSpace/2.0) * i, AlbumStrokeLength, AlbumStrokeLength);
        }
        
        [self.view addSubview:_album];
        [_album release];
        [subMenus addObject:_album];
        i++;
    }
}

- (void)setNowPlayingView
{
    //selectAll
    [selectAllButton setFrame:CGRectMake(albumStorageOriginX, (albumStorageAlbumSpace/2.0)*2, AlbumStrokeLength, AlbumStrokeLength)];
    [selectAllButton setHidden:NO];
    
    NSMutableArray * nowPlayings = [NowPlaying readNowPlayings];
    int i = 3;
    for (NowPlaying * nowPlaying in nowPlayings) {
        for (album * _album in albumArray) 
        {
            if([_album.persistentID doubleValue]== nowPlaying.persistentID)
            {
                album * playedAlbum = [[album alloc] init];
                playedAlbum.albumjaket.image = _album.smalljaket;
                [playedAlbum setAlbumjaket:_album.smalljaket bigImage:_album.bigjaket recordImage:_album.recordStroke];
                if(i%2 ==0)
                {
                    [playedAlbum setFrameWithInitialFrame:CGRectMake(albumStorageOriginX, (albumStorageAlbumSpace/2.0) * i, AlbumStrokeLength, AlbumStrokeLength)];
                }
                else
                {
                    [playedAlbum setFrameWithInitialFrame:CGRectMake(albumStorageOriginX + albumStorageAlbumSpace/2.0, (albumStorageAlbumSpace/2.0) * i, AlbumStrokeLength, AlbumStrokeLength)];
                }
                [playedAlbum setDelegate:self];
                [playedAlbum setMainViewCon:self];
                playedAlbum.userInteractionEnabled = YES;
                
                [self.view addSubview:playedAlbum];
                [subMenus addObject:playedAlbum];
                i++;
            }
        }
    }
}

- (void)setShopView
{
    folderButton * folderBtn = [[folderButton alloc] init];
    [folderBtn setImage:[UIImage imageNamed:@"pop_yellow_album_storage_shop_timer.png"] forState:UIControlStateNormal];
    folderBtn.frame = CGRectMake(albumStorageOriginX, (albumStorageAlbumSpace/2.0) * 2, AlbumStrokeLength, AlbumStrokeLength);
    [self.view addSubview:folderBtn];
    [folderBtn release];
    [subMenus addObject:folderBtn];
    
    folderBtn = [[folderButton alloc] init];
    [folderBtn setImage:[UIImage imageNamed:@"pop_yellow_album_storage_shop_theme.png"] forState:UIControlStateNormal];
    folderBtn.frame = CGRectMake(albumStorageOriginX  + albumStorageAlbumSpace/2.0, (albumStorageAlbumSpace/2.0) * 3, AlbumStrokeLength, AlbumStrokeLength);
    [self.view addSubview:folderBtn];
    [folderBtn release];
    [subMenus addObject:folderBtn];

    folderBtn = [[folderButton alloc] init];
    [folderBtn setImage:[UIImage imageNamed:@"pop_yellow_album_storage_shop_alarm.png"] forState:UIControlStateNormal];
    folderBtn.frame = CGRectMake(albumStorageOriginX, (albumStorageAlbumSpace/2.0) * 4, AlbumStrokeLength, AlbumStrokeLength);
    [self.view addSubview:folderBtn];
    [folderBtn release];
    [subMenus addObject:folderBtn];

//    folderBtn.frame = CGRectMake(albumStorageOriginX  + albumStorageAlbumSpace/2, 1 + (albumStorageAlbumSpace/2) * i, AlbumStrokeLength, AlbumStrokeLength)
}

- (void)showAlbum:(BOOL)show
{
    //select All
    [selectAllButton setFrame:CGRectMake(albumStorageOriginX, (albumStorageAlbumSpace/2.0)*2, AlbumStrokeLength, AlbumStrokeLength)];
    [selectAllButton setHidden:NO];
    
    for (album * _album in albumArray) 
        [_album setHidden:!show];
//    NSLog(@"albumArray : %d",[albumArray count]);
}

- (void)showAlbumTag:(BOOL)show
{
    for (album * _album in albumArray)
//        [_album.nameTag setHidden:!show];
            [_album showNameTag:show];
}

- (void)collectSelectedAlbumToMovingAlbum:(CGRect)pos mainAlbum:(album *)mainAlbum
{
    for (album * _album in selectedAlbumArray) 
    {
        [UIView beginAnimations:@"" context:_album];
        [UIView setAnimationDuration:0.3];
        if(![_album isEqual:mainAlbum])
            [UIView setAnimationDelegate:self];
        _album.frame = pos;
        _album.albumStroke.frame = CGRectMake(_album.albumStroke.frame.origin.x - AlbumStrokeLength / 2.0, _album.albumStroke.frame.origin.y - AlbumStrokeLength / 2.0, AlbumStrokeLength * 2, AlbumStrokeLength * 2);
//        [_album.albumStroke setImage:_album.bigStroke];
        _album.albumjaket.frame = CGRectMake(_album.albumjaket.frame.origin.x - AlbumLength / 2.0, _album.albumjaket.frame.origin.y - AlbumLength / 2.0, AlbumLength * 2, AlbumLength * 2);
        [_album.albumjaket setImage:_album.bigjaket];
        [_album.albumjaketlayer setCornerRadius:AlbumLength];
        [UIView commitAnimations];
    }
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    album * _album = context;
    _album.hidden = YES;
}

- (void)selectedAlbumBackToInitialPos:(CGRect)pos
{    
    for (album * _album in selectedAlbumArray)     
    {
        _album.hidden = NO;
        _album.frame = pos;
    }
    
    for (album * _album in selectedAlbumArray) 
    {
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.3];
        _album.albumStroke.frame = CGRectMake(_album.albumStroke.frame.origin.x + AlbumStrokeLength / 2.0, _album.albumStroke.frame.origin.y + AlbumStrokeLength / 2.0, AlbumStrokeLength, AlbumStrokeLength);
//        [_album.albumStroke setImage:_album.smallStroke];
        _album.albumjaket.frame = CGRectMake(_album.albumjaket.frame.origin.x + AlbumLength / 2.0, _album.albumjaket.frame.origin.y + AlbumLength / 2.0, AlbumLength, AlbumLength);
        [_album.albumjaket setImage:_album.smalljaket];
        [_album.albumjaketlayer setCornerRadius:AlbumLength / 2.0];
        _album.frame = _album.initialFrame;
        [UIView commitAnimations];
    }
}

- (void)addAlbumInSelectedAlbumArr:(album *)_album
{
    [selectedAlbumArray removeObjectIdenticalTo:_album];
    [selectedAlbumArray addObject:_album];
}

- (void)removeAlbumFromSelectedAlbumArr:(album *)_album
{
    [selectedAlbumArray removeObjectIdenticalTo:_album];

    //back to normal menu mode
    [menuButton removeTarget:nil action:NULL forControlEvents:UIControlEventTouchUpInside];
    [menuButton addTarget:self action:@selector(basicButtonAction:) forControlEvents:UIControlEventTouchUpInside];

}

- (void)setFolders
{
    //selectAll
    [selectAllButton setHidden:YES];
    
    UIButton * folderAdd = [[UIButton alloc] initWithFrame:CGRectMake(albumStorageOriginX, albumStorageAlbumSpace/2.0 * 2, AlbumStrokeLength, AlbumStrokeLength)];
    [folderAdd setImage:[UIImage imageNamed:@"pop_yellow_album_storage_folder_add.png"] forState:UIControlStateNormal];
    [folderAdd addTarget:self action:@selector(folderAddButtonOnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:folderAdd];
    [folderAdd release];
    [subMenus addObject:folderAdd];
    
    //set Folder Arr
    [folderArray removeAllObjects];
    for(FolderInfo * folder in [FolderInfo readFolders])
        [folderArray addObject:folder];
    
    int i = 3;
    for (FolderInfo * folder in folderArray) 
    {
        folderButton * folderBtn = [[folderButton alloc] init];
        folderBtn.folderType = UserSelButtonType;
        folderBtn.index = i - 3;
        folderBtn.mainViewCon = self;

        [folderBtn setImage:[UIImage imageNamed:@"pop_yellow_album_storage_folder_closed_blue.png"] forState:UIControlStateNormal];
        [self.view addSubview:folderBtn];
        [folderBtn release];
        
        [subMenus addObject:folderBtn];
        folderBtn.selected = NO;
        
        if(i%2 ==0)
            folderBtn.frame = CGRectMake(albumStorageOriginX, (albumStorageAlbumSpace/2.0) * i, AlbumStrokeLength, AlbumStrokeLength);
        else
            folderBtn.frame = CGRectMake(albumStorageOriginX  + albumStorageAlbumSpace/2.0, (albumStorageAlbumSpace/2.0) * i, AlbumStrokeLength, AlbumStrokeLength);
        i++;
    }
}

- (void)removeSubMenus
{
    for (id subMenu in subMenus) 
        [subMenu removeFromSuperview];

    for (id albumsInFolder in albumsInFolderArr) 
        [albumsInFolder removeFromSuperview];

    [subMenus removeAllObjects];
    [albumsInFolderArr removeAllObjects];
    [selectedFolderButton setHidden:YES];
}

- (void)historyDataInitialize
{
    //    historyArray = [[NSMutableArray alloc] init];
//    historyArray = [History readHistorys];
    historyArray = [History readHistorys];
}

- (void)setCurrentHistory:(UIImage *)albumImage Title:(NSString*)title artist:(NSString *)artist
{

}

#pragma mark - Button Action 
- (void)basicButtonAction:(UIButton *)button
{
    //0:shop 1:now playing 2:menu
    //0:song 1:artist 2:album 3:folder
    if(button != shopButton)
        [shopButton setImage:[UIImage imageNamed:@"pop_yellow_album_storage_shop_icon.png"] forState:UIControlStateNormal]; 
    else
    {
        [shopButton setImage:[UIImage imageNamed:@"pop_yellow_album_storage_shop_icon_chosen.png"] forState:UIControlStateNormal];
        [self showAlbum:NO];
        if(preSelectedAlbumStorageMenu != 0)
        {
            [self removeSubMenus];
            [self setShopView];
        }
        preSelectedAlbumStorageMenu = 0;
    }
        
    if(button != recentMusicButton)
        [recentMusicButton setImage:[UIImage imageNamed:@"pop_yellow_album_storage_now_playing.png"] forState:UIControlStateNormal]; 
    else
    {
        [recentMusicButton setImage:[UIImage imageNamed:@"pop_yellow_album_storage_now_playing_chosen.png"] forState:UIControlStateNormal]; 
        [self showAlbum:NO];
        if(preSelectedAlbumStorageMenu != 1)
        {
            [self removeSubMenus];
            [self setNowPlayingView];
        }
        preSelectedAlbumStorageMenu = 1;
    }
           
    if(button != menuButton)
    {
        if(preSelectedmenu == SongType)
            [menuButton setImage:[UIImage imageNamed:@"pop_yellow_album_storage_song.png"] forState:UIControlStateNormal]; 
        else if(preSelectedmenu == ArtistType)
            [menuButton setImage:[UIImage imageNamed:@"pop_yellow_album_storage_artist.png"] forState:UIControlStateNormal]; 
        else if(preSelectedmenu == AlbumType)
            [menuButton setImage:[UIImage imageNamed:@"pop_yellow_album_storage_album.png"] forState:UIControlStateNormal]; 
        else
            [menuButton setImage:[UIImage imageNamed:@"pop_yellow_album_storage_folder.png"] forState:UIControlStateNormal]; 
    }
    else
    {
        [self removeSubMenus];
        folderAddActivated = NO;
        if (preSelectedAlbumStorageMenu == 2) {
            preSelectedmenu++;
            if (preSelectedmenu == 4)
                preSelectedmenu = 0;
        }
        preSelectedAlbumStorageMenu = 2;
    
        if(preSelectedmenu == SongType)
        {
            [menuButton setImage:[UIImage imageNamed:@"pop_yellow_album_storage_song_chosen.png"] forState:UIControlStateNormal]; 
            [self showAlbum:YES];
            preSelectedmenu = 0;
        }
        else if(preSelectedmenu == ArtistType)
        {
            [menuButton setImage:[UIImage imageNamed:@"pop_yellow_album_storage_artist_chosen.png"] forState:UIControlStateNormal]; 
            [self showAlbum:NO];
            [self setArtistSortView];
            preSelectedmenu = 1;
        }
        else if(preSelectedmenu == AlbumType)
        {
            [menuButton setImage:[UIImage imageNamed:@"pop_yellow_album_storage_album_chosen.png"] forState:UIControlStateNormal]; 
            [self setAlbumTitleSortView];
            preSelectedmenu = 2;
        }
        else if(preSelectedmenu == FolderType)
        {
            [menuButton setImage:[UIImage imageNamed:@"pop_yellow_album_storage_folder_chosen.png"] forState:UIControlStateNormal]; 
            [self setFolders];
            preSelectedmenu = 3;
        }
    }
}

- (void)folderAddButtonOnAction
{
    NSString * defaultName = [NSString stringWithFormat:@"Folder#%d", [folderArray count]];
    [FolderInfo saveFolder:defaultName];
    [[DataModelManager sharedManager] saveToPersistentStore];
    
    [self removeSubMenus];
    [self setFolders];
}

- (void)selectAll:(id)sender
{
    if(preSelectedmenu == 0)
    {
        if ([albumArray count] == [selectedAlbumArray count]) 
        {
            for (album * _album in albumArray) {
                [_album setSelect:NO];
            }
        }
        else 
        {
            for (album * _album in albumArray) {
                [_album setSelect:YES];
            }
        }
    }
    else {
        if ([albumsInFolderArr count] == [selectedAlbumArray count]) 
        {
            for (album * _album in albumsInFolderArr) {
                [_album setSelect:NO];
            }        
        }
        else 
        {
            for (album * _album in albumsInFolderArr) {
                [_album setSelect:YES];
            }
        }

    }    
}

- (void)unSelectAll
{
    if([selectedAlbumArray count] == 0)
        return;
    
    if(preSelectedmenu == 0)
    {
        for (album * _album in albumArray) {
            [_album setSelect:NO];
        }
    }
    else {
        for (album * _album in albumsInFolderArr) {
            [_album setSelect:NO];
        }        
    } 
}

- (void)folderButtonOnAction:(id)sender
{
    folderButton * folderBtn = (folderButton *)sender;
    
    int albumIndex = folderBtn.index + 1 + 2 + 1;
    int albumInFolderNum = 0;
    
    //Artist
    if(folderBtn.folderType == ArtistButtonType)
    {
        if(folderBtn.selected == NO)
        {
            for (id subMenu in subMenus) 
                [subMenu setHidden:YES];
            
            [selectedFolderButton setFrame:CGRectMake(albumStorageOriginX, albumStorageAlbumSpace, AlbumStrokeLength, AlbumStrokeLength)];
            selectedFolderButton.albumJacket.image = folderBtn.albumJacket.image;
            [selectedFolderButton setCover:YES];
            selectedFolderButton.albumTitle = folderBtn.albumTitle;
            selectedFolderButton.artist = folderBtn.artist;
            selectedFolderButton.recordStroke = folderBtn.recordStroke;
            selectedFolderButton.mainViewCon = self;
            [selectedFolderButton setHidden:NO];

            
            [selectAllButton setFrame:CGRectMake(albumStorageOriginX + albumStorageAlbumSpace/2.0, albumStorageAlbumSpace/2.0*3, AlbumStrokeLength, AlbumStrokeLength)];
            [selectAllButton setHidden:NO];
            
            
            for (album * _album in albumArray) 
            {
                //show album
                if([_album.artist isEqualToString:folderBtn.artist])
                {
                    album * albumInFolder = [[album alloc] init];
                    albumInFolder.delegate = self;
                    albumInFolder.artist = _album.artist;
                    albumInFolder.folderIndex = folderBtn.index;
                    albumInFolder.albumjaket.image = _album.smalljaket;
                    albumInFolder.mainViewCon = self;
                    albumInFolder.userInteractionEnabled = YES;
                    [albumInFolder setAlbumjaket:_album.smalljaket bigImage:_album.bigjaket recordImage:_album.recordStroke];
                    
                    if(albumInFolderNum % 2 != 0)
                        [albumInFolder setFrameWithInitialFrame:CGRectMake(albumStorageOriginX + albumStorageAlbumSpace/2.0, albumStorageAlbumSpace + (albumInFolderNum + 2) * (albumStorageAlbumSpace/2.0), AlbumStrokeLength, AlbumStrokeLength)];
                    else
                        [albumInFolder setFrameWithInitialFrame:CGRectMake(albumStorageOriginX, albumStorageAlbumSpace + (albumInFolderNum + 2) * (albumStorageAlbumSpace/2.0), AlbumStrokeLength, AlbumStrokeLength)];
                    
                    [self.view addSubview:albumInFolder];
                    [albumsInFolderArr addObject:albumInFolder];
                    [albumInFolder release];
                    albumIndex++;
                    albumInFolderNum++;
                }
            }
        }
    }
    
    //Album
    if(folderBtn.folderType == AlbumTitleButtonType)
    {
        if(folderBtn.selected == NO)
        {
            for (id subMenu in subMenus) 
                [subMenu setHidden:YES];
            
            [selectedFolderButton setFrame:CGRectMake(albumStorageOriginX, albumStorageAlbumSpace, AlbumStrokeLength, AlbumStrokeLength)];
            selectedFolderButton.albumJacket.image = folderBtn.albumJacket.image;
            [selectedFolderButton setCover:YES];
            selectedFolderButton.albumTitle = folderBtn.albumTitle;
            selectedFolderButton.artist = folderBtn.artist;
            selectedFolderButton.recordStroke = folderBtn.recordStroke;
            selectedFolderButton.mainViewCon = self;
            [selectedFolderButton setHidden:NO];
            [selectAllButton setFrame:CGRectMake(albumStorageOriginX + albumStorageAlbumSpace/2.0, albumStorageAlbumSpace/2.0*3, AlbumStrokeLength, AlbumStrokeLength)];
            [selectAllButton setHidden:NO];
            
            for (album * _album in albumArray) 
            {
                //show album
                if([_album.albumTitle isEqualToString:folderBtn.albumTitle])
                {
                    album * albumInFolder = [[album alloc] init];
                    albumInFolder.delegate = self;
                    albumInFolder.artist = _album.artist;
                    albumInFolder.folderIndex = folderBtn.index;
                    albumInFolder.albumjaket.image = _album.smalljaket;
                    albumInFolder.mainViewCon = self;
                    albumInFolder.userInteractionEnabled = YES;
                    [albumInFolder setAlbumjaket:_album.smalljaket bigImage:_album.bigjaket recordImage:_album.recordStroke];
                    
                    if(albumInFolderNum % 2 != 0)
                        [albumInFolder setFrameWithInitialFrame:CGRectMake(albumStorageOriginX + albumStorageAlbumSpace/2.0, albumStorageAlbumSpace + (albumInFolderNum + 2) * (albumStorageAlbumSpace/2.0), AlbumStrokeLength, AlbumStrokeLength)];
                    else
                        [albumInFolder setFrameWithInitialFrame:CGRectMake(albumStorageOriginX, albumStorageAlbumSpace + (albumInFolderNum + 2) * (albumStorageAlbumSpace/2.0), AlbumStrokeLength, AlbumStrokeLength)];
                    
                    [self.view addSubview:albumInFolder];
                    [albumsInFolderArr addObject:albumInFolder];
                    [albumInFolder release];
                    albumIndex++;
                    albumInFolderNum++;
                }
            }
        }
    }
    
    //Folder
    if(folderBtn.folderType == UserSelButtonType)
    {
        if(folderBtn.selected == NO)
        {
            for (id subMenu in subMenus) 
                [subMenu setHidden:YES];
            
            [selectedFolderButton setFrame:CGRectMake(albumStorageOriginX, albumStorageAlbumSpace, AlbumStrokeLength, AlbumStrokeLength)];
            [selectedFolderButton.albumJacket setImage:[UIImage imageNamed:@"pop_yellow_album_storage_folder_opend_blue.png"]];
            [selectedFolderButton setCoverHidden];
            selectedFolderButton.albumTitle = folderBtn.albumTitle;
            selectedFolderButton.artist = folderBtn.artist;
            selectedFolderButton.recordStroke = folderBtn.recordStroke;
            selectedFolderButton.mainViewCon = self;
            [selectedFolderButton setHidden:NO];
            
            [selectAllButton setFrame:CGRectMake(albumStorageOriginX + albumStorageAlbumSpace/2.0, albumStorageAlbumSpace/2.0*3, AlbumStrokeLength, AlbumStrokeLength)];
            [selectAllButton setHidden:NO];
            
            FolderInfo * folder = [[FolderInfo readFolders] objectAtIndex:folderBtn.index];
            NSLog(@"folderCount:%d",[[folder.album allObjects] count]);
            for(AlbumInfo * albumInfo in [folder.album allObjects])
            {
                for (album * _album in albumArray)
                {
                    if([_album.musicTitle isEqualToString:albumInfo.name])
                    {
                        album * albumInFolder = [[album alloc] init];
                        albumInFolder.delegate = self;
                        albumInFolder.artist = _album.artist;
                        albumInFolder.folderIndex = folderBtn.index;
                        albumInFolder.albumjaket.image = _album.smalljaket;
                        albumInFolder.mainViewCon = self;
                        albumInFolder.userInteractionEnabled = YES;
                        [albumInFolder setAlbumjaket:_album.smalljaket bigImage:_album.bigjaket recordImage:_album.recordStroke];
                        
                        if(albumInFolderNum % 2 != 0)
                            [albumInFolder setFrameWithInitialFrame:CGRectMake(albumStorageOriginX + albumStorageAlbumSpace/2.0, albumStorageAlbumSpace + (albumInFolderNum + 2) * (albumStorageAlbumSpace/2.0), AlbumStrokeLength, AlbumStrokeLength)];
                        else
                            [albumInFolder setFrameWithInitialFrame:CGRectMake(albumStorageOriginX, albumStorageAlbumSpace + (albumInFolderNum + 2) * (albumStorageAlbumSpace/2.0), AlbumStrokeLength, AlbumStrokeLength)];
                        
                        [self.view addSubview:albumInFolder];
                        [albumsInFolderArr addObject:albumInFolder];
                        [albumInFolder release];
                        albumIndex++;
                        albumInFolderNum++;
                    }
                }
            }
        }
    }
    
    if(folderBtn.selected == YES)
    {
        for (id subMenu in subMenus) 
            [subMenu setHidden:NO];
        [selectAllButton setHidden:YES];
        [selectedFolderButton setHidden:YES];
        
        NSMutableArray * albumInFolderCopy = [[albumsInFolderArr copy] autorelease];
        for (album * _album in albumInFolderCopy) 
        {
            if([_album.artist isEqualToString:folderBtn.artist])
            {
                [_album removeFromSuperview];
                [albumsInFolderArr removeObject:_album];
                albumInFolderNum--;
            }
        }
    }
}

- (void)FlipToAlbumSelectedAction:(album *)selAlbum
{
    [shopButton setImage:[UIImage imageNamed:@"pop_yellow_album_storage_play.png"] forState:UIControlStateNormal];
    [recentMusicButton setImage:[UIImage imageNamed:@"pop_yellow_album_storage_add_now_playing.png"] forState:UIControlStateNormal];
    [menuButton setImage:[UIImage imageNamed:@"pop_yellow_album_storage_folder_chosen.png"] forState:UIControlStateNormal];
    [infoTrashButton setImage:[UIImage imageNamed:@"pop_yellow_album_storage_bin.png"] forState:UIControlStateNormal];
    
    CABasicAnimation* moveAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];

    moveAnimation.fromValue = [NSNumber numberWithFloat:1.0];
	moveAnimation.toValue = [NSNumber numberWithFloat:0.0];

    moveAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	moveAnimation.autoreverses = YES;
    moveAnimation.duration= 0.3;
    moveAnimation.repeatCount = 2;
	moveAnimation.delegate = self;
    
	[shopButton.layer addAnimation:moveAnimation forKey:@"animateOpacity"];
	[recentMusicButton.layer addAnimation:moveAnimation forKey:@"animateOpacity"];
	[menuButton.layer addAnimation:moveAnimation forKey:@"animateOpacity"];
	[infoTrashButton.layer addAnimation:moveAnimation forKey:@"animateOpacity"];
    
    //menu adding album in folder mode + 휴지통 + nowPlaying
    [shopButton removeTarget:nil action:NULL forControlEvents:UIControlEventTouchUpInside];
    [shopButton addTarget:self action:@selector(playButtonOnAction) forControlEvents:UIControlEventTouchUpInside];
    
    [recentMusicButton removeTarget:nil action:NULL forControlEvents:UIControlEventTouchUpInside];
    [recentMusicButton addTarget:self action:@selector(addNowPlayingButtonOnAction) forControlEvents:UIControlEventTouchUpInside];
    
    [menuButton removeTarget:nil action:NULL forControlEvents:UIControlEventTouchUpInside];
    [menuButton addTarget:self action:@selector(folderAddMenuButtonOnAction) forControlEvents:UIControlEventTouchUpInside];
    
    [infoTrashButton removeTarget:nil action:NULL forControlEvents:UIControlEventTouchUpInside];
    [infoTrashButton addTarget:self action:@selector(trashButtonOnAction:) forControlEvents:UIControlEventTouchUpInside]; 
}

- (BOOL)checkAllAlbumDeselected
{
    return [selectedAlbumArray count] == 0;
}

- (void)FlipToAlbumDeselectedAction:(album *)selAlbum
{
    if ([self checkAllAlbumDeselected]) {
        [shopButton setImage:[UIImage imageNamed:@"pop_yellow_album_storage_shop_icon.png"] forState:UIControlStateNormal];
        [recentMusicButton setImage:[UIImage imageNamed:@"pop_yellow_album_storage_now_playing.png"] forState:UIControlStateNormal];
        if (preSelectedmenu == 0) {
            [menuButton setImage:[UIImage imageNamed:@"pop_yellow_album_storage_song_chosen.png"] forState:UIControlStateNormal];
        } else if (preSelectedmenu == 1) {
            [menuButton setImage:[UIImage imageNamed:@"pop_yellow_album_storage_artist_chosen.png"] forState:UIControlStateNormal];
        } else if (preSelectedmenu == 2) {
            [menuButton setImage:[UIImage imageNamed:@"pop_yellow_album_storage_album_chosen.png"] forState:UIControlStateNormal];
        } else {
            [menuButton setImage:[UIImage imageNamed:@"pop_yellow_album_storage_folder_chosen.png"] forState:UIControlStateNormal];
        }
        
        if (preSelectedAlbumStorageMenu == 0) {
            [shopButton setImage:[UIImage imageNamed:@"pop_yellow_album_storage_shop_choosen.png"] forState:UIControlStateNormal];
        } else if (preSelectedAlbumStorageMenu == 1){
            [recentMusicButton setImage:[UIImage imageNamed:@"pop_yellow_album_storage_now_playing_chosen.png"] forState:UIControlStateNormal];
        } 
        if (preSelectedAlbumStorageMenu != 2) {
            if (preSelectedmenu == 0) {
                [menuButton setImage:[UIImage imageNamed:@"pop_yellow_album_storage_song.png"] forState:UIControlStateNormal];
            } else if (preSelectedmenu == 1) {
                [menuButton setImage:[UIImage imageNamed:@"pop_yellow_album_storage_artist.png"] forState:UIControlStateNormal];
            } else if (preSelectedmenu == 2) {
                [menuButton setImage:[UIImage imageNamed:@"pop_yellow_album_storage_album.png"] forState:UIControlStateNormal];
            } else {
                [menuButton setImage:[UIImage imageNamed:@"pop_yellow_album_storage_folder.png"] forState:UIControlStateNormal];
            }
        }
        
        [infoTrashButton setImage:[UIImage imageNamed:@"pop_yellow_album_storage_info.png"] forState:UIControlStateNormal];
        
        CABasicAnimation* moveAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        
        moveAnimation.fromValue = [NSNumber numberWithFloat:1.0];
        moveAnimation.toValue = [NSNumber numberWithFloat:0.0];
        
        moveAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        moveAnimation.autoreverses = YES;
        moveAnimation.duration= 0.3;
        moveAnimation.repeatCount = 2;
        moveAnimation.delegate = self;
        
        [shopButton.layer addAnimation:moveAnimation forKey:@"animateOpacity"];
        [recentMusicButton.layer addAnimation:moveAnimation forKey:@"animateOpacity"];
        [menuButton.layer addAnimation:moveAnimation forKey:@"animateOpacity"];
        [infoTrashButton.layer addAnimation:moveAnimation forKey:@"animateOpacity"];
        
        //menu adding album in folder mode + 휴지통 + nowPlaying
        [shopButton removeTarget:nil action:NULL forControlEvents:UIControlEventTouchUpInside];
        [shopButton addTarget:self action:@selector(basicButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [recentMusicButton removeTarget:nil action:NULL forControlEvents:UIControlEventTouchUpInside];
        [recentMusicButton addTarget:self action:@selector(basicButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [menuButton removeTarget:nil action:NULL forControlEvents:UIControlEventTouchUpInside];
        [menuButton addTarget:self action:@selector(basicButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [infoTrashButton removeTarget:nil action:NULL forControlEvents:UIControlEventTouchUpInside];    
        [infoTrashButton addTarget:self action:@selector(infoButtonOnAction:) forControlEvents:UIControlEventTouchUpInside];
    } 
}

- (void)animationDidStop:(CABasicAnimation *)anim finished:(BOOL)flag
{
    if([anim.keyPath isEqualToString:@"opacity"])
    {
    }
}

- (void)infoButtonOnAction
{
    infoViewController * _infoViewController = [[infoViewController alloc] init];
    _infoViewController.view.frame = CGRectMake(albumStorageAlbumSpace, 460, 320, 460);
    [self.view addSubview:_infoViewController.view];
    
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDuration:1.0];
    _infoViewController.view.frame = CGRectMake(albumStorageAlbumSpace, 0, 320, 460);
    [UIView commitAnimations];
}

- (void)timerButtonOnAction
{
    UIAlertView * timerAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Timer를 켜시겠습니까?" delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"확인", nil];
    [timerAlert setDelegate:self];
    [timerAlert show];
    [timerAlert release];
}

- (void)alarmButtonOnAction
{
    UIAlertView * alarmAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Alarm를 켜시겠습니까?" delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"확인", nil];
    [alarmAlert setDelegate:self];
    [alarmAlert show];
    [alarmAlert release];
}

- (void)swipeHandler:(UISwipeGestureRecognizer *)gestureRecognizer
{
//    if(gestureRecognizer.direction == UISwipeGestureRecognizerDirectionLeft)
//    {
//        [UIView beginAnimations:@"" context:nil];
//        [UIView setAnimationDuration:0.1];
//        if (!opened) {
//            self.view.frame = CGRectMake(-albumStorageAlbumSpace, 20, self.view.frame.size.width, self.view.frame.size.height);
//            opened = !opened;
//        }
//        [UIView commitAnimations];
//    }else 
//    if(gestureRecognizer.direction == UISwipeGestureRecognizerDirectionRight)
//    {
//        [UIView beginAnimations:@"" context:nil];
//        [UIView setAnimationDuration:0.1];
//        if (opened) {
//            self.view.frame = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height);
//            opened = !opened;
//            [self showAlbumTag:NO];
//        }
//        [UIView commitAnimations];
//    }
}

#pragma mark - Button Action After Folder Add Clicked
- (void)playButtonOnAction
{
    
}

- (void)addNowPlayingButtonOnAction
{
    
}

- (void)folderAddMenuButtonOnAction
{
    preSelectedmenu--;
    folderAddActivated = YES;
    [self showAlbum:NO]; //hide album       
    [self setFolders]; //show folders
    
    for (folderButton * folderBtn in subMenus) 
    {
        if([folderBtn isKindOfClass:[folderButton class]])
            folderBtn.folderAddMode = YES;
    }    
    
    //noraml folder mode + 휴지통 + nowPlaying
    [menuButton removeTarget:nil action:NULL forControlEvents:UIControlEventTouchUpInside];
    [menuButton addTarget:self action:@selector(basicButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [infoTrashButton setImage:[UIImage imageNamed:@"pop_yellow_album_storage_info.png"] forState:UIControlStateNormal];
    [infoTrashButton removeTarget:nil action:NULL forControlEvents:UIControlEventTouchUpInside];
    [infoTrashButton addTarget:self action:@selector(infoButtonOnAction) forControlEvents:UIControlEventTouchUpInside];    
}

- (void)trashButtonOnAction
{
    
}

- (void)saveAlbumsInFolder:(folderButton *)folderBtn
{
    FolderInfo * folderInfo = [[FolderInfo readFolders] objectAtIndex:folderBtn.index];
    for(album * _album in selectedAlbumArray)
    {
        [AlbumInfo saveAlbum:_album.musicTitle imageURL:nil inFolder:folderInfo];
        [_album setSelect:NO];
    }
    [[DataModelManager sharedManager] saveToPersistentStore];
    
    [self folderButtonOnAction:folderBtn];
}

#pragma mark - UITableView Delegate & DataSource
- (void)reloadTableView
{
    [_musicHistoryTableView reloadData];
}
#pragma mark - Notification Selector
- (void)volumeChanged
{
    NSLog(@"volume:%f", musicPlayer.volume * 15.0);
    NSInteger volumeSize = musicPlayer.volume * 15.0;
    [volumeView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"pop_yellow_volume%d.png", volumeSize]]];
}

- (void)alarmNotification
{
    BOOL alarmBool = [UserDefaultHelper getAlarmState];  
    [_musicHistoryTableView reloadData];
    [_record setBoardToAlarmUI:alarmBool];
}

- (void)timerNotification
{
    BOOL timerBool = [UserDefaultHelper getTimerState];    
    [_musicHistoryTableView reloadData];
    [_record setBoardToTimerUI:timerBool];
}

- (void)autoAlarmNotification
{
    [_musicHistoryTableView reloadData];
//    if(alarmButton.buttonType == AlarmType)
//        [alarmButton setAutoImage];
//    else 
//        [timerButton setAutoImage];
}

- (void)autoTimerNotification
{
    [_musicHistoryTableView reloadData];
//    if(alarmButton.buttonType == AlarmType)
//        [alarmButton setAutoImage];
//    else 
//        [timerButton setAutoImage];
}

#pragma mark - AudioHelperDelegate
- (void)iPodItemReceived:(NSDictionary *)iPoditem
{
    
}

//Modified by The Finest Artist at 6.01
- (void)iPodItemsReceived:(NSArray *)iPoditem
{
    [self setAlbumView:[iPoditem count]];
    
    NSInteger index = 0;
    for (MPMediaItem *mediaItem in iPoditem) {
        NSNumber *persistentID = (NSNumber*)[mediaItem valueForProperty:MPMediaItemPropertyPersistentID];
        NSString *title = (NSString*)[mediaItem valueForProperty:MPMediaItemPropertyTitle];
        NSString *artist = (NSString*)[mediaItem valueForProperty:MPMediaItemPropertyArtist];
        NSString *albumTitle =(NSString*)[mediaItem valueForProperty:MPMediaItemPropertyAlbumTitle]; 
        MPMediaItemArtwork *artwork = [mediaItem valueForProperty: MPMediaItemPropertyArtwork];
        NSString * playBackDuration = [mediaItem valueForProperty:MPMediaItemPropertyPlaybackDuration];
        NSString * lyric = [mediaItem valueForProperty:MPMediaItemPropertyLyrics];
        NSURL * assetURL = [mediaItem valueForProperty:MPMediaItemPropertyAssetURL];
        UIImage * albumImage, * bigAlbumImage,  *recordImage;
        if (artwork) {
            albumImage = [artwork imageWithSize: CGSizeMake (AlbumStrokeLength, AlbumStrokeLength)];
            bigAlbumImage = [artwork imageWithSize: CGSizeMake (AlbumStrokeLength*2, AlbumStrokeLength*2)];
            recordImage = [artwork imageWithSize: CGSizeMake (176.0, 176.0)];
            
//            recordImage = [UIImage resizedImage:recordImage inRect:CGRectMake(0, 0, 176.0, 176.0)];
            recordImage = [UIImage resizedImage2:recordImage inSize:CGSizeMake(176.0, 176.0)];
            
            //TODO: Image Size
            NSLog(@"HelloImageSize:%f %f %f", albumImage.size.width, bigAlbumImage.size.width, recordImage.size.width);
        } else {
            albumImage = [UIImage imageNamed:@"pop_yellow_album_storage_album_default.png"];
            bigAlbumImage = [UIImage imageNamed:@"pop_yellow_album_storage_album_default_move.png"];
            recordImage = [UIImage imageNamed:@"pop_yellow_lp_player_lp_default.png"];
        }
        
        if(index < [albumArray count])
        {
            album * _album = [albumArray objectAtIndex:index++];
            _album.persistentID = persistentID;
            _album.musicTitle = title;
            _album.playTime = [playBackDuration doubleValue];
            _album.artist = artist;
            _album.assetURL = assetURL;
            _album.nameTagLabel.text =[NSString stringWithFormat:@"%@-%@",title, artist];
            _album.albumTitle = albumTitle;
            [_album setAlbumjaket:albumImage bigImage:bigAlbumImage recordImage:recordImage];
        }
       // NSLog(@"Lylic:%@", lyric);
//        NSLog(@"Title:%@ album:%d albumTitle:%@ persistentID:%@", title, [albumArray count], albumTitle, persistentID);
//        [Musics addObject:title];
    }
    
    [albumsIndicator stopAnimating];
    [self.view bringSubviewToFront:bgTop];
    [self.view bringSubviewToFront:slideButton];
    [self.view bringSubviewToFront:shopButton];
    [self.view bringSubviewToFront:recentMusicButton];
    [self.view bringSubviewToFront:menuButton];
    [self.view bringSubviewToFront:selectAllButton];
    
//    [MusicTable reloadData];
}

#pragma mark - album Delegate & recordLine Delegate
- (void)albumFinishEnlargeOnRecord:(UIImage *)_albumImage Title:(NSString *)title playTime:(double)time album:(album *)alb;
{
    selectedAlbum = alb;
    _record.recordBoard.image = _albumImage;
    _record.selAlbum = alb;
    _record.albumSelected = YES;
    
    [_record setPlayTime:time curTime:musicPlayer.currentPlaybackTime];
    
    //select Music
    MPMediaQuery *everything = [[MPMediaQuery alloc] init];
    MPMediaPropertyPredicate *artistNamePredicate = [MPMediaPropertyPredicate predicateWithValue:title forProperty: MPMediaItemPropertyTitle]; //also set to play Album
    [everything addFilterPredicate:artistNamePredicate];
    [musicPlayer setQueueWithQuery:everything];
    
    //Save in NowPlaying
    [NowPlaying saveNowPlaying:[alb.persistentID doubleValue]];
    [[DataModelManager sharedManager] saveToPersistentStore];
}

//Modified by The Finest Artist at 5.29
- (void)albumVerticalMove:(double)currentY albumY:(double)selectedAlbumY
{
    if (!albumVerticalMoveStarted) {
        albumVerticalMoveStartY = currentY;
        albumVerticalMoveStarted = YES;
    }
    
    double dy = cbrt((albumStorageAlbumSpace/4.0)*(albumStorageAlbumSpace/4.0)*((int)(currentY-(int)albumVerticalMoveStartY%(albumStorageAlbumSpace/2))%(albumStorageAlbumSpace/2)-(albumStorageAlbumSpace/4.0)))+(albumStorageAlbumSpace/4.0)+currentY-(int)albumVerticalMoveStartY%(albumStorageAlbumSpace/2)-(int)(currentY-(int)albumVerticalMoveStartY%(albumStorageAlbumSpace/2))%(albumStorageAlbumSpace/2)-selectedAlbumY;
    
    if(preSelectedAlbumStorageMenu == 0)
    {
    
    }
    else if(preSelectedAlbumStorageMenu == 1)
    {
        for(album * _album in subMenus)
        {
            _album.frame = CGRectMake(albumStorageOriginX + albumStorageAlbumSpace/2.0-abs((int)(dy+_album.frame.origin.y)%albumStorageAlbumSpace+dy+_album.frame.origin.y-(int)(dy+_album.frame.origin.y)-(albumStorageAlbumSpace/2.0)), dy + _album.frame.origin.y, _album.frame.size.width, _album.frame.size.height);
            _album.initialFrame = _album.frame;
            if ([_album checkNameTagShowed]) 
            {
                _album.nameTag.frame = CGRectMake(AlbumNameTagWidth - _album.frame.origin.x + 13, 10, -AlbumNameTagWidth + _album.frame.origin.x, _album.nameTag.frame.size.height);
                _album.nameTagLabel.frame = CGRectMake(5, 0, -AlbumNameTagWidth + _album.frame.origin.x - 13, _album.nameTagLabel.frame.size.height);
            }
        }
    }
    else if(preSelectedAlbumStorageMenu == 2)
    {
        if(preSelectedmenu == 0)
        {
            for(album * _album in albumArray)
            {
                _album.frame = CGRectMake(albumStorageOriginX + albumStorageAlbumSpace/2.0-abs((int)(dy+_album.frame.origin.y)%albumStorageAlbumSpace+dy+_album.frame.origin.y-(int)(dy+_album.frame.origin.y)-(albumStorageAlbumSpace/2.0)), dy + _album.frame.origin.y, _album.frame.size.width, _album.frame.size.height);
                _album.initialFrame = _album.frame;
                if ([_album checkNameTagShowed]) // showing
                {
                    _album.nameTag.frame = CGRectMake(AlbumNameTagWidth - _album.frame.origin.x + 13, 10, -AlbumNameTagWidth + _album.frame.origin.x, _album.nameTag.frame.size.height);
                    _album.nameTagLabel.frame = CGRectMake(5, 0, -AlbumNameTagWidth + _album.frame.origin.x - 13, _album.nameTagLabel.frame.size.height);
                    
                    if((_album.frame.origin.y > (albumStorageAlbumSpace/2.0) * 13)&& dy > 0)
                    {
                        [_album showNameTag:NO];
                    }
                }
                else // No showing
                {
                    if((_album.frame.origin.y < 460) && dy < 0)
                    {
                        [_album showNameTag:YES];
                    }
                }
            }
        }
        else 
        {
            for(id subMenu in subMenus)
            {
                if([subMenus isKindOfClass:[album class]])
                {
                    album * _album = (album *)subMenu;
                    _album.frame = CGRectMake(albumStorageOriginX + albumStorageAlbumSpace/2.0-abs((int)(dy+_album.frame.origin.y)%albumStorageAlbumSpace+dy+_album.frame.origin.y-(int)(dy+_album.frame.origin.y)-(albumStorageAlbumSpace/2.0)), dy + _album.frame.origin.y, _album.frame.size.width, _album.frame.size.height);
                    _album.initialFrame = _album.frame;
                    if ([_album checkNameTagShowed]) {
                        _album.nameTag.frame = CGRectMake(AlbumNameTagWidth - _album.frame.origin.x + 13, 10, -AlbumNameTagWidth + _album.frame.origin.x, _album.nameTag.frame.size.height);
                        _album.nameTagLabel.frame = CGRectMake(5, 0, -AlbumNameTagWidth + _album.frame.origin.x - 13, _album.nameTagLabel.frame.size.height);
                    }
                }
            } 
        }

    }
}

//Modified by The Finest Artist at 5.29
- (void)albumVerticalEnded
{
    album * firstAlbum, * lastAlbum;
    if(preSelectedAlbumStorageMenu == 1)
    {
        firstAlbum = [subMenus objectAtIndex:0];
        lastAlbum = [subMenus lastObject];
    }
    else 
    {
        firstAlbum = [albumArray objectAtIndex:0];
        lastAlbum = [albumArray lastObject];
    }
    
    if(firstAlbum.frame.origin.y > (albumStorageAlbumSpace/2.0) * 3)
    {
        for(int i = 0; i < [albumArray count]; i++)
        {
            album * _album = [albumArray objectAtIndex:i];
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:albumVerticalAnimationDuration];
            if(i%2 != 0)
            {
                _album.frame = CGRectMake(albumStorageOriginX, (albumStorageAlbumSpace/2.0) * (i+3), AlbumStrokeLength, AlbumStrokeLength);
            }
            else
            {
                _album.frame = CGRectMake(albumStorageOriginX + albumStorageAlbumSpace/2.0, (albumStorageAlbumSpace/2.0) * (i+3), AlbumStrokeLength, AlbumStrokeLength);
            }
            [UIView commitAnimations]; 
        }
        return;
    }

    if(lastAlbum.frame.origin.y < (albumStorageAlbumSpace/2.0) * 12)
    {
        for(int i = ([albumArray count] - 1); i >= 0 ; i--)
        {
            album * _album = [albumArray objectAtIndex:i];
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:albumVerticalAnimationDuration];
            
            int j = i - ([albumArray count] - 1) + 12; 
            
            if(j%2 == 0)
            {
                _album.frame = CGRectMake(albumStorageOriginX, (albumStorageAlbumSpace/2.0) * j, AlbumStrokeLength, AlbumStrokeLength);
            }
            else
            {
                _album.frame = CGRectMake(albumStorageOriginX + albumStorageAlbumSpace/2.0, (albumStorageAlbumSpace/2.0) * j, AlbumStrokeLength, AlbumStrokeLength);
            }
            [UIView commitAnimations]; 
        }
        return;
    }

    if(preSelectedAlbumStorageMenu == 1)
    {
        for(album * _album in subMenus)
        {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:albumVerticalAnimationDuration];
            _album.frame = CGRectMake(albumStorageOriginX + albumStorageAlbumSpace/2.0-abs((int)((int)_album.frame.origin.y+(albumStorageAlbumSpace/4.0)-(((int)_album.frame.origin.y*2+(albumStorageAlbumSpace/2))%(albumStorageAlbumSpace)/2.0))%albumStorageAlbumSpace-(albumStorageAlbumSpace/2)),(int)_album.frame.origin.y+(albumStorageAlbumSpace/4)-(((int)_album.frame.origin.y*2+(albumStorageAlbumSpace/2))%(albumStorageAlbumSpace))/2.0, _album.frame.size.width, _album.frame.size.height);
            _album.nameTag.frame = CGRectMake(AlbumNameTagWidth - _album.frame.origin.x + 13, 10, -AlbumNameTagWidth + _album.frame.origin.x, _album.nameTag.frame.size.height);
            _album.nameTagLabel.frame = CGRectMake(5, 0, -AlbumNameTagWidth + _album.frame.origin.x - 13, _album.nameTagLabel.frame.size.height);
            [UIView commitAnimations];
        }
    }
    else
    {
        for(album * _album in albumArray)
        {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:albumVerticalAnimationDuration];
            _album.frame = CGRectMake(albumStorageOriginX + albumStorageAlbumSpace/2.0-abs((int)((int)_album.frame.origin.y+(albumStorageAlbumSpace/4.0)-(((int)_album.frame.origin.y*2+(albumStorageAlbumSpace/2))%(albumStorageAlbumSpace)/2.0))%albumStorageAlbumSpace-(albumStorageAlbumSpace/2)),(int)_album.frame.origin.y+(albumStorageAlbumSpace/4)-(((int)_album.frame.origin.y*2+(albumStorageAlbumSpace/2))%(albumStorageAlbumSpace))/2.0, _album.frame.size.width, _album.frame.size.height);
            _album.nameTag.frame = CGRectMake(AlbumNameTagWidth - _album.frame.origin.x + 13, 10, -AlbumNameTagWidth + _album.frame.origin.x, _album.nameTag.frame.size.height);
            _album.nameTagLabel.frame = CGRectMake(5, 0, -AlbumNameTagWidth + _album.frame.origin.x - 13, _album.nameTagLabel.frame.size.height);
            [UIView commitAnimations];
        }
    }
    albumVerticalMoveStarted = NO;
    albumVerticalMoveStartY = 0.0;
}

- (void)playMusicFinished
{
    if(_record.albumSelected)
    {
        NSString * albumImgURL = [History saveImage:selectedAlbum.recordStroke title:selectedAlbum.musicTitle];
        [historyArray addObject:[History saveHistory:selectedAlbum.musicTitle albumTitle:selectedAlbum.albumTitle Artist:selectedAlbum.artist Emotion:0 AlbumImageURL:albumImgURL]];
        [[DataModelManager sharedManager] saveToPersistentStore];
        
        [_musicHistoryTableView updateHistory];
        [_musicHistoryTableView reloadData];   
    }
}

- (void)playMusic
{
    if(_record.albumSelected)
    {
        [_record setPlayPickerAndStart];
        [_record startRecordTimer];
        [musicPlayer play];
    }
}

- (void)stopMusic
{
    [_record stopPlayPicker];
    [musicPlayer stop];
}

#pragma mark - Folder Movements
- (void)folderVerticalMove:(double)currentY folderY:(double)selectedAlbumY
{
    if (!albumVerticalMoveStarted) {
        albumVerticalMoveStartY = currentY;
        albumVerticalMoveStarted = YES;
    }
    
    double dy = cbrt((albumStorageAlbumSpace/4.0)*(albumStorageAlbumSpace/4.0)*((int)(currentY-(int)albumVerticalMoveStartY%(albumStorageAlbumSpace/2))%(albumStorageAlbumSpace/2)-(albumStorageAlbumSpace/4.0)))+(albumStorageAlbumSpace/4.0)+currentY-(int)albumVerticalMoveStartY%(albumStorageAlbumSpace/2)-(int)(currentY-(int)albumVerticalMoveStartY%(albumStorageAlbumSpace/2))%(albumStorageAlbumSpace/2)-selectedAlbumY;
    for(folderButton * _album in subMenus)
    {
        if (![_album isKindOfClass:[folderButton class]]) 
            continue;
            
        _album.frame = CGRectMake(albumStorageOriginX + albumStorageAlbumSpace/2.0-abs((int)(dy+_album.frame.origin.y)%albumStorageAlbumSpace+dy+_album.frame.origin.y-(int)(dy+_album.frame.origin.y)-(albumStorageAlbumSpace/2.0)), dy + _album.frame.origin.y, _album.frame.size.width, _album.frame.size.height);
//        _album.initialFrame = _album.frame;
//        _album.nameTag.frame = CGRectMake(AlbumNameTagWidth - _album.frame.origin.x + 13, 10, -AlbumNameTagWidth + _album.frame.origin.x, _album.nameTag.frame.size.height);
//        _album.nameTagLabel.frame = CGRectMake(5, 0, -AlbumNameTagWidth + _album.frame.origin.x - 13, _album.nameTagLabel.frame.size.height);
    }
}

- (void)folderVerticalEnded
{
    int firstIndex;
    if((preSelectedmenu == 1) || (preSelectedmenu == 2))
        firstIndex = 0;
    else
        firstIndex = 1;
    
    folderButton * firstFolder = [subMenus objectAtIndex:firstIndex];    
    if(firstFolder.frame.origin.y > (albumStorageAlbumSpace/2.0) * 3)
    {
        for(int i = firstIndex; i < [subMenus count]; i++)
        {
            folderButton * _album = [subMenus objectAtIndex:i];
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:albumVerticalAnimationDuration];
            if(i%2 == 0)
            {
                _album.frame = CGRectMake(albumStorageOriginX, (albumStorageAlbumSpace/2.0) * (i+2), AlbumStrokeLength, AlbumStrokeLength);
            }
            else
            {
                _album.frame = CGRectMake(albumStorageOriginX + albumStorageAlbumSpace/2.0, (albumStorageAlbumSpace/2.0) * (i+2), AlbumStrokeLength, AlbumStrokeLength);
            }
            [UIView commitAnimations]; 
        }
        return;
    }
    
    folderButton * lastFolder = [subMenus lastObject];
    if(lastFolder.frame.origin.y < (albumStorageAlbumSpace/2.0) * 12)
    {
        for(int i = ([subMenus count] - 1); i >= firstIndex ; i--)
        {
            folderButton * _album = [subMenus objectAtIndex:i];
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:albumVerticalAnimationDuration];
            
            int j = i - ([subMenus count] - 1) + 12; 
            
            if(j%2 == 0)
            {
                _album.frame = CGRectMake(albumStorageOriginX, (albumStorageAlbumSpace/2.0) * j, AlbumStrokeLength, AlbumStrokeLength);
            }
            else
            {
                _album.frame = CGRectMake(albumStorageOriginX + albumStorageAlbumSpace/2.0, (albumStorageAlbumSpace/2.0) * j, AlbumStrokeLength, AlbumStrokeLength);
            }
            [UIView commitAnimations]; 
        }
        return;
    }

    for(folderButton * _album in subMenus)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:albumVerticalAnimationDuration];
        _album.frame = CGRectMake(albumStorageOriginX + albumStorageAlbumSpace/2.0-abs((int)((int)_album.frame.origin.y+(albumStorageAlbumSpace/4.0)-(((int)_album.frame.origin.y*2+(albumStorageAlbumSpace/2))%(albumStorageAlbumSpace)/2.0))%albumStorageAlbumSpace-(albumStorageAlbumSpace/2)),(int)_album.frame.origin.y+(albumStorageAlbumSpace/4)-(((int)_album.frame.origin.y*2+(albumStorageAlbumSpace/2))%(albumStorageAlbumSpace))/2.0, _album.frame.size.width, _album.frame.size.height);
//        _album.nameTag.frame = CGRectMake(AlbumNameTagWidth - _album.frame.origin.x + 13, 10, -AlbumNameTagWidth + _album.frame.origin.x, _album.nameTag.frame.size.height);
//        _album.nameTagLabel.frame = CGRectMake(5, 0, -AlbumNameTagWidth + _album.frame.origin.x - 13, _album.nameTagLabel.frame.size.height);
        [UIView commitAnimations];
    }
    albumVerticalMoveStarted = NO;
    albumVerticalMoveStartY = 0.0;
}
#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UISwipeGestureRecognizer *)gestureRecognizer
{
    NSLog(@"%f %f %f", [gestureRecognizer locationInView:self.view].x, [gestureRecognizer locationInView:self.view].y
                     , ABS(touch.x - [gestureRecognizer locationInView:self.view].x));
    
    CGFloat point_x = [gestureRecognizer locationInView:self.view].x;
    
//    if(point_x < 180) 
//        return NO;
    
    
//        && (gestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft))
//
//    else if((point_x < 210) && (gestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight))
//        return NO;
    
    return YES;
}

//Modified by The Finest Artist at 5.20
- (void)slideButtonOnAction:(id)slideButton
{
    [UIView beginAnimations:@"slideButton" context:nil];
    [UIView setAnimationDuration:albumStorageAnimationDuration*2];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    if (opened) {
        self.view.frame = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height);
        if (tagOpened) {
            if (preSelectedAlbumStorageMenu == 1) 
            {
                for (album * _album in subMenus)
                    [_album showNameTag:NO];                
            }
            else if(preSelectedAlbumStorageMenu == 2)
            {
                for (album * _album in albumArray)
                    [_album showNameTag:NO];
            }
            tagOpened = NO;
        }
    } else {
        self.view.frame = CGRectMake(-mainViewMoveMargin, 20, self.view.frame.size.width, self.view.frame.size.height);        
        if (preSelectedAlbumStorageMenu == 1) 
        {
            for (album * _album in subMenus)
                [_album showNameTag:YES];                            
        }
        else if(preSelectedAlbumStorageMenu == 2)
        {
            for (album * _album in albumArray)
                [_album showNameTag:YES];
        }
        tagOpened = YES;
    }
    [UIView commitAnimations];
    opened = !opened;
}

- (void)repeatButtonOnAction:(id)sender
{
    repeat++;
    if (repeat>2) {
        repeat = 0;
    }
    
    if (repeat == 0) {
        [repeatButton setImage:[UIImage imageNamed:@"Repeat0.png"] forState:UIControlStateNormal];
        [audioHelper setRepeatMode:MPMusicRepeatModeNone];
    } else if (repeat == 1) {
        [repeatButton setImage:[UIImage imageNamed:@"Repeat1.png"] forState:UIControlStateNormal];
        [audioHelper setRepeatMode:MPMusicRepeatModeOne];
    } else {
        [repeatButton setImage:[UIImage imageNamed:@"Repeat2.png"] forState:UIControlStateNormal];
        [audioHelper setRepeatMode:MPMusicRepeatModeAll];
    }
}

- (void)shuffleButtonOnAction:(id)sender
{
    shuffle++;
    if (shuffle>1) {
        shuffle = 0;
    }
    
    if (shuffle == 0) {
        [shuffleButton setImage:[UIImage imageNamed:@"shuffle_off.png"] forState:UIControlStateNormal];
        [audioHelper setShuffleMode:MPMusicShuffleModeOff];
    } else {
        [shuffleButton setImage:[UIImage imageNamed:@"shuffle_on.png"] forState:UIControlStateNormal];
        [audioHelper setShuffleMode:MPMusicShuffleModeSongs];
    }
}

#pragma mark - Touch Event
//Modified by The Finest Artist at 6.14
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self refreshAlbumStorage];
    
    NSArray *allTouches = [touches allObjects]; 
	int count = [allTouches count];
	if (count == 1) {
		currentTouch = [[allTouches objectAtIndex:0] locationInView:[self.view superview]]; 
        [self touchesBegan:currentTouch];
	}
    NSLog(@"opened : %d, shouldSwipe : %d, tagShouldSwipe : %d, shouldOneClickMove : %d shouldScroll : %d",opened, shouldSwipe, tagShuoldSwipe, shouldOneClickMove, shouldScroll);
}

//Modified by The Finest Artist at 6.14
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	NSArray *allTouches = [touches allObjects]; 
	int count = [allTouches count]; 
    
	if (count == 1) {
        currentTouch = [[allTouches objectAtIndex:0] locationInView:[self.view superview]];
        [self touchesMoved:currentTouch];
	}
}

//Modified by The Finest Artist at 6.14
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesEnded];
    [self unSelectAll];
}

#pragma mark - Global Touch Event
- (void)touchesBegan:(CGPoint)currentPoint
{
    currentTouch = currentPoint;
    //shouldOneClickMove
    if ((!opened && currentTouch.x > albumStorageOriginX - albumStorageOneClickMargin)
        || (opened && currentTouch.x > albumOriginX - albumStorageWidth - albumStorageOneClickMargin && currentTouch.x < albumOriginX - albumStorageAlbumSpace)) {
        shouldOneClickMove = YES;
    }
    
    //shouldSwipe
    if ((!opened && currentTouch.x > albumStorageOriginX - albumStorageSwipeMargin)
        || (opened && currentTouch.x > albumOriginX - albumStorageWidth - albumStorageSwipeMargin && currentTouch.x < albumOriginX - albumStorageAlbumSpace)) {
        shouldSwipe = YES;
    }
    
    //tagShouldSwipe
    if ((opened && tagOpened && currentTouch.x < albumOriginX - albumStorageWidth - albumStorageSwipeMargin)
        || (opened && !tagOpened && currentTouch.x < albumOriginX - albumStorageAlbumSpace / 2)) {
        tagShuoldSwipe = YES;
    }
    
    //shouldScroll
    if (opened && !shouldSwipe){
        shouldScroll = YES;
    }
    
    lastTouchX = currentTouch.x;
    albumVerticalMoveStartY = lastTouchY = currentTouch.y;
}

- (void)touchesMoved:(CGPoint)currentPoint
{
    currentTouch = currentPoint;
    shouldOneClickMove = NO;
    
    if (currentTouch.x > lastTouchX)
        opening = NO;
    if (currentTouch.x < lastTouchX)
        opening = YES;
    lastTouchX = currentTouch.x;
    
    if (shouldSwipe || tagShuoldSwipe) {
        if (currentTouch.x < albumOriginX - albumStorageWidth) {
            self.view.frame = CGRectMake(-mainViewMoveMargin, 20, self.view.frame.size.width, self.view.frame.size.height);
        } else{
            self.view.frame = CGRectMake(cbrt(mainViewMoveMargin*mainViewMoveMargin/4*(currentTouch.x-albumStorageOriginX+mainViewMoveMargin/2))-mainViewMoveMargin/2, 20, self.view.frame.size.width, self.view.frame.size.height);
        }
        
        //fade in-out
        if (currentTouch.x < albumOriginX - albumStorageWidth && currentTouch.x > albumOriginX - albumStorageWidth- albumStorageTagFadeMargin)
        {
            for(album * _album in albumArray)
            {
                _album.nameTag.frame = CGRectMake(AlbumNameTagStart -_album.frame.origin.x + 13, 10, -AlbumNameTagStart + _album.frame.origin.x, 20);
                _album.nameTagLabel.frame = CGRectMake(5, 0, -AlbumNameTagStart + _album.frame.origin.x - 13, 20);
                _album.nameTag.alpha = (albumOriginX - albumStorageWidth - currentTouch.x)/albumStorageTagFadeMargin;
                _album.nameTagLabel.alpha = (albumOriginX - albumStorageWidth - currentTouch.x)/albumStorageTagFadeMargin;
            }
        }
        
        //move left-right
        if (currentTouch.x < albumOriginX - albumStorageWidth - albumStorageTagFadeMargin && currentTouch.x > albumOriginX - albumStorageWidth -albumStorageTagFadeMargin - AlbumNameTagStart + AlbumNameTagWidth)
        {
            for(album * _album in albumArray)
            {
                _album.nameTag.frame = CGRectMake(AlbumNameTagStart -_album.frame.origin.x + 13 + currentTouch.x - albumOriginX + albumStorageWidth + albumStorageTagFadeMargin, 10, -AlbumNameTagStart + _album.frame.origin.x - currentTouch.x + albumOriginX - albumStorageWidth - albumStorageTagFadeMargin, 20);
                _album.nameTagLabel.frame = CGRectMake(5, 0, -AlbumNameTagStart + _album.frame.origin.x - currentTouch.x + albumOriginX - albumStorageWidth - albumStorageTagFadeMargin - 13, 20);
                _album.nameTag.alpha = 1.0;
                _album.nameTagLabel.alpha = 1.0;
            }
            opening = YES;
        }
        
        //name Tag open
        if (currentTouch.x < albumOriginX - albumStorageWidth - albumStorageTagMoveMargin) {
            tagOpened = YES;
        } else {
            tagOpened = NO;
        }
    }
    
    if (shouldScroll) {
        double dy = cbrt((albumStorageAlbumSpace/4.0)*(albumStorageAlbumSpace/4.0)*((int)(currentTouch.y-albumVerticalMoveStartY)%(albumStorageAlbumSpace)-(albumStorageAlbumSpace/4.0)))-cbrt((albumStorageAlbumSpace/4.0)*(albumStorageAlbumSpace/4.0)*((int)(lastTouchY-albumVerticalMoveStartY)%(albumStorageAlbumSpace/2)-(albumStorageAlbumSpace/4.0)));
        NSLog(@"current : %f, last : %f, start : %f, dy : %f",currentTouch.y,lastTouchY,albumVerticalMoveStartY,dy);
        //nameTag
        for(album * _album in albumArray)
        {
            _album.frame = CGRectMake(albumStorageOriginX + albumStorageAlbumSpace/2.0-abs((int)(dy+_album.frame.origin.y)%albumStorageAlbumSpace+dy+_album.frame.origin.y-(int)(dy+_album.frame.origin.y)-(albumStorageAlbumSpace/2)), dy + _album.frame.origin.y, _album.frame.size.width, _album.frame.size.height);
            _album.initialFrame = _album.frame;
            
            if (tagOpened) {
                _album.nameTag.frame = CGRectMake(AlbumNameTagWidth - _album.frame.origin.x + 13, 10, -AlbumNameTagWidth + _album.frame.origin.x, _album.nameTag.frame.size.height);
                _album.nameTagLabel.frame = CGRectMake(5, 0, -AlbumNameTagWidth + _album.frame.origin.x - 13, _album.nameTagLabel.frame.size.height);
            }
        }
        lastTouchY = currentTouch.y;
        if (abs(albumVerticalMoveStartY - lastTouchY)>=(albumStorageAlbumSpace/2.0)) {
            albumVerticalMoveStartY = lastTouchY;
        }
    }
}

- (void)touchesEnded
{
    //shouldOneClickMove
    if (shouldOneClickMove) {
        if (!opened) {
            [UIView beginAnimations:@"" context:nil];
            [UIView setAnimationDuration:albumStorageAnimationDuration/2];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
            self.view.frame = CGRectMake(-mainViewMoveMargin, 20, self.view.frame.size.width, self.view.frame.size.height);
            opened = YES;
            [UIView commitAnimations];   
            
            [self disableAlbumStorageButtons:NO];
        } else {
            [UIView beginAnimations:@"" context:nil];
            [UIView setAnimationDuration:albumStorageAnimationDuration/2];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
            self.view.frame = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height);
            opened = NO;
            [UIView commitAnimations];
            
            [self disableAlbumStorageButtons:YES];
        }
    }
    
    //shouldSwipe
    if (shouldSwipe && !shouldOneClickMove) {
        if (opening) {
            [UIView beginAnimations:@"" context:nil];
            [UIView setAnimationDuration:albumStorageAnimationDuration/2];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
            self.view.frame = CGRectMake(-mainViewMoveMargin, 20, self.view.frame.size.width, self.view.frame.size.height);
            opened = YES;
            [UIView commitAnimations]; 

            [self disableAlbumStorageButtons:NO];
        } else {
            [UIView beginAnimations:@"" context:nil];
            [UIView setAnimationDuration:albumStorageAnimationDuration/2];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
            self.view.frame = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height);
            opened = NO;
            [UIView commitAnimations];
            
            [self disableAlbumStorageButtons:YES];
        }
    }
    
    //TagOpen // Tag가 끝까지 열리게 하는 코드
    if (shouldSwipe && tagOpened) {
        for(album * _album in albumArray)
        {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:AlbumNameTagMoveAnimationDuration/2];
            _album.nameTag.frame = CGRectMake(AlbumNameTagWidth - _album.frame.origin.x + 13 , 10, -AlbumNameTagWidth + _album.frame.origin.x, 20);
            _album.nameTagLabel.frame = CGRectMake(5, 0, -AlbumNameTagWidth + _album.frame.origin.x - 13, 20);
            [UIView commitAnimations];
        }
    }
    
    //TagClose // Tag가 끝까지 닫히도록 완료시키는 코드
    if (shouldSwipe && !tagOpened) {
        for(album * _album in albumArray)
        {
            if (_album.nameTag.alpha != 1.0) {
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:AlbumNameTagFadeAnimationDuration/2];
                _album.nameTag.alpha = 0.0;
                _album.nameTagLabel.alpha = 0.0;
                [UIView commitAnimations];
            } else {
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:AlbumNameTagMoveAnimationDuration/2];
                _album.nameTag.frame = CGRectMake(AlbumNameTagStart -_album.frame.origin.x + 13, 10, -AlbumNameTagStart + _album.frame.origin.x, 20);
                _album.nameTagLabel.frame = CGRectMake(5, 0, -AlbumNameTagStart + _album.frame.origin.x - 13, 20);
                [UIView commitAnimations];
                
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:AlbumNameTagFadeAnimationDuration/2];
                [UIView setAnimationDelay:AlbumNameTagMoveAnimationDuration/2];
                _album.nameTag.alpha = 0.0;
                _album.nameTagLabel.alpha = 0.0;
                [UIView commitAnimations];
            }
        }
    }
    
    //shouldScroll (album 움직임 관련된 부분)
    if (shouldScroll){
        [self albumVerticalEnded];
    }
    
    [self refreshAlbumStorage]; //album Storage 중간에 걸칠경우를 해결하기 위한 부분
}

#pragma mark - TAEHWAN's Func
//ADDED by The Finest Artist at 6.14
-(void)refreshAlbumStorage
{
    //In case AlbumStorage stuck in the middle
    if (self.view.frame.origin.x < 0 && self.view.frame.origin.x > -mainViewMoveMargin) {
        NSLog(@"ERROR : AlbumStorage Stuck IN THE MIDDLE");
        //shouldOneClickMove, shouldSwipe, ELSE
        if (shouldOneClickMove) {
            if (!opened) {
                [UIView beginAnimations:@"" context:nil];
                [UIView setAnimationDuration:albumStorageAnimationDuration/2];
                [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
                self.view.frame = CGRectMake(-mainViewMoveMargin, 20, self.view.frame.size.width, self.view.frame.size.height);
                opened = YES;
                [UIView commitAnimations];        
            } else {
                [UIView beginAnimations:@"" context:nil];
                [UIView setAnimationDuration:albumStorageAnimationDuration/2];
                [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
                self.view.frame = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height);
                opened = NO;
                [UIView commitAnimations];
            }
        } else if (shouldSwipe) {
            if (opening) {
                [UIView beginAnimations:@"" context:nil];
                [UIView setAnimationDuration:albumStorageAnimationDuration/2];
                [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
                self.view.frame = CGRectMake(-mainViewMoveMargin, 20, self.view.frame.size.width, self.view.frame.size.height);
                opened = YES;
                [UIView commitAnimations]; 
            } else {
                [UIView beginAnimations:@"" context:nil];
                [UIView setAnimationDuration:albumStorageAnimationDuration/2];
                [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
                self.view.frame = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height);
                opened = NO;
                [UIView commitAnimations];
            }
        } else {
            if (self.view.frame.origin.x > -mainViewMoveMargin/2) {
                [UIView beginAnimations:@"" context:nil];
                [UIView setAnimationDuration:albumStorageAnimationDuration/2];
                [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
                self.view.frame = CGRectMake(-mainViewMoveMargin, 20, self.view.frame.size.width, self.view.frame.size.height);
                opened = YES;
                [UIView commitAnimations];    
            } else{
                [UIView beginAnimations:@"" context:nil];
                [UIView setAnimationDuration:albumStorageAnimationDuration/2];
                [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
                self.view.frame = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height);
                opened = NO;
                [UIView commitAnimations];
            }
        }
    }
    
    //Refresh opened
    if (self.view.frame.origin.x == 0){
        opened = NO;
        tagOpened = NO;
    }
    if (self.view.frame.origin.x == -mainViewMoveMargin)
        opened = YES;
    
    opening = NO;
    shouldSwipe = NO;
    shouldOneClickMove = NO;
    shouldScroll = NO;
    tagShuoldSwipe = NO;
    lastTouchX = lastTouchY = albumVerticalMoveStartY = 0.0;
}

#pragma mark - AlbumStorageButton Enable Disable
-(void)disableAlbumStorageButtons:(BOOL)dis
{
    if(dis == NO)
    {
        shopButton.userInteractionEnabled = YES;
        infoTrashButton.userInteractionEnabled = YES;
        recentMusicButton.userInteractionEnabled = YES;
        menuButton.userInteractionEnabled = YES;
        
        for (id subMenu in subMenus) 
        {
            UIView * view = (UIView *)subMenu;
            view.userInteractionEnabled = YES;
        }
        
        for (album * _album in albumArray) 
        {
            _album.userInteractionEnabled = YES;
        }
    }
    else 
    {
        shopButton.userInteractionEnabled = NO;
        infoTrashButton.userInteractionEnabled = NO;
        recentMusicButton.userInteractionEnabled = NO;
        menuButton.userInteractionEnabled = NO;
        
        for (id subMenu in subMenus) 
        {
            UIView * view = (UIView *)subMenu;
            view.userInteractionEnabled = NO;
        }
        
        for (album * _album in albumArray) 
        {
            _album.userInteractionEnabled = NO;
        }
    }
}

@end