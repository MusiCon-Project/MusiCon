//
//  FBManager.m
//  VariousModule
//
//  Created by JHLee on 11. 6. 16..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FBManager.h"
#import "SBJSON.h"
#import <MediaPlayer/MediaPlayer.h>

typedef enum 
{
    ProfileClicked,
    ProfileInterestClicked,
    ProfileMusicClicked,
    ProfileBookClicked,
    ProfileFilmClicked,
    ProfileTVProgramClicked,
    ProfileGameClicked,
    RestAPIClicked,
    TextUploadClicked,
    PicUploadClicked,
    PicDownloadClicked,
    FriendListClicked,
    GetProfileImageClicked,
}
requestMessageType;

static FBManager * fbManager;
@implementation FBManager
@synthesize delegate;
@synthesize facebook;
@synthesize profileDatas;

+ (FBManager *)sharedObject 
{
    @synchronized(self)
    {
        if(fbManager == nil)
        {
            fbManager = [[FBManager alloc] init];
        }
    }
    return fbManager;
}

- (void)destroySharedObject
{
    if(fbManager)
        [fbManager release];
}

- (id)init
{
    if((self = [super init]))
    {
        facebook = [[Facebook alloc] initWithAppId:MnTalk2_AppID andDelegate:self];
        facebook.sessionDelegate = self;
        permissions = [[NSArray alloc] initWithObjects:@"read_stream", @"publish_stream", @"user_birthday", @"user_location", @"user_interests", @"user_likes", @"offline_access", @"email", @"user_checkins", @"friends_checkins", @"publish_checkins",nil];
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        if ([defaults objectForKey:@"FBAccessTokenKey"] && [defaults objectForKey:@"FBExpirationDateKey"]) {
            facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
            facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
			NSLog(@"facebook.accessToken = %@",facebook.accessToken);
        }
	
		NSString *url = [NSString stringWithFormat:@"fb%@://authorize",MnTalk2_AppID];
        BOOL bSchemeInPlist = NO; // find out if the sceme is in the plist file.
        NSArray* aBundleURLTypes = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleURLTypes"];
        if ([aBundleURLTypes isKindOfClass:[NSArray class]] &&
            ([aBundleURLTypes count] > 0)) {
            NSDictionary* aBundleURLTypes0 = [aBundleURLTypes objectAtIndex:0];
            if ([aBundleURLTypes0 isKindOfClass:[NSDictionary class]]) {
                NSArray* aBundleURLSchemes = [aBundleURLTypes0 objectForKey:@"CFBundleURLSchemes"];
                if ([aBundleURLSchemes isKindOfClass:[NSArray class]] &&
                    ([aBundleURLSchemes count] > 0)) {
                    NSString *scheme = [aBundleURLSchemes objectAtIndex:0];
                    if ([scheme isKindOfClass:[NSString class]] &&
                        [url hasPrefix:scheme]) {
                        bSchemeInPlist = YES;
                    }
                }
            }
        }
        // Check if the authorization callback will work
        BOOL bCanOpenUrl = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString: url]];
        if (!bSchemeInPlist || !bCanOpenUrl) {
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"Setup Error"
                                      message:@"Invalid or missing URL scheme. You cannot run the app until you set up a valid URL scheme in your .plist."
                                      delegate:self
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil,
                                      nil];
            [alertView show];
            [alertView release];
        }

		
    }
    return self;
}

- (void)dealloc
{
    [facebook release];
    [permissions release];
	
    if(profileDatas)
		[profileDatas release];
	if(imageDatas)
		[imageDatas release];
	if(imageURLs)
		[imageURLs release];
    
    [super dealloc];
}

- (void)setDelegate:(id<FBManagerDelegate>)delegateInst
{
    _delegate = delegateInst;
}

#pragma - FaceBook API Wrapping Functions
- (void)login
{
    if(![facebook isSessionValid])
        [facebook authorize:permissions]; 
	else
		[self fbDidLogin];
}

- (void)logout
{
    [facebook logout:self];
}

- (BOOL)Logined
{	
	//TODO:ExpirateionDate Have to Considered
	
	logined = [[NSUserDefaults standardUserDefaults] boolForKey:@"isLogined"];
	return logined;
}

- (void)CallGraphAPI:(NSString *)Connection
{
	if([Connection isEqualToString:@"me/picture"])
	{
		NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//									   @"large", @"type",
									   nil];
		
		[facebook requestWithGraphPath:@"me/picture"
							 andParams:params
						 andHttpMethod:@"GET"
						   andDelegate:self];
		
		return;
	}
	
	[facebook requestWithGraphPath:Connection andDelegate:self];
}

- (void)CallRestAPI
{
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    @"SELECT uid,name FROM user WHERE uid=4", @"query",
                                    nil];
    [facebook requestWithMethodName:@"fql.query"
                           andParams:params
                       andHttpMethod:@"POST"
                         andDelegate:self];
}

- (void)TextUpload
{
    SBJSON *jsonWriter = [[SBJSON new] autorelease];
    
    NSDictionary* actionLinks = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:
                                                           @"Always Running",@"text",@"http://itsti.me/",@"href", nil], nil];
    
    NSString *actionLinksStr = [jsonWriter stringWithObject:actionLinks];
    NSDictionary* attachment = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"a long run", @"name",
                                @"The Facebook Running app", @"caption",
                                @"it is fun", @"description",
                                @"http://itsti.me/", @"href", nil];
    NSString *attachmentStr = [jsonWriter stringWithObject:attachment];
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"Share on Facebook",  @"user_message_prompt",
                                   actionLinksStr, @"action_links",
                                   attachmentStr, @"attachment",
                                   nil];
    
    
    [facebook dialog:@"feed"
           andParams:params
         andDelegate:self];
}

- (void)TextUpload:(NSString *)text
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   text, @"message",
                                   nil];
    
    [facebook requestWithGraphPath:@"me/feed"
                         andParams:params
                     andHttpMethod:@"POST"
                       andDelegate:self];
	
	getInfoType = FacebookTextUpload;
}

- (void)PicUploadWithImage:(UIImage *)image withText:(NSString *)text
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                image, @"picture", text, @"message",
                                   nil];

//    NSString* url = [FBRequest serializeURL:@"https://graph.facebook.com/me/photos" params:params httpMethod:@"POST"];
//    NSLog(@"URL:%@",url );
    
    [facebook requestWithGraphPath:@"me/photos"
                          andParams:params
                      andHttpMethod:@"POST"
                       andDelegate:self];
	
	getInfoType = FacebookImageUpload;
    
}

- (void)PicUploadWithImage:(UIImage *)image withText:(NSString *)text place:(NSString *)place
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   image, @"picture", text, @"message", place, @"place",
                                   nil];
    
    //    NSString* url = [FBRequest serializeURL:@"https://graph.facebook.com/me/photos" params:params httpMethod:@"POST"];
    //    NSLog(@"URL:%@",url );
    
    [facebook requestWithGraphPath:@"me/photos"
                         andParams:params
                     andHttpMethod:@"POST"
                       andDelegate:self];
	
	getInfoType = FacebookImageUpload;
    
}

- (void)PosUpload:(NSString *)place message:(NSString *)message tags:(NSArray *)tags
{    
	SBJSON * jsonWriter = [[SBJSON new] autorelease];
	NSMutableDictionary * coordinatesDicationary = 
	[NSMutableDictionary dictionaryWithObjectsAndKeys:@"1.0", @"latitude", 
	 @"1.0", @"longitude", nil];
	
	NSArray * nameArr = [[NSArray alloc] initWithObjects:@"100001076964058", @"100001114216964", nil];	
	NSString * coordinates = [jsonWriter stringWithObject:coordinatesDicationary];
	NSString * nameStr = [jsonWriter stringWithObject:nameArr];
	
	NSLog(@"Coords:%@ nameStr:%@", coordinates, nameStr);

	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   place, @"place",
								   coordinates, @"coordinates",
								   message, @"message",
//								   nameStr, @"tags",
                                   nil];
	
    [facebook requestWithGraphPath:@"me/checkins"
                         andParams:params
                     andHttpMethod:@"POST"
                       andDelegate:self];
	
	getInfoType = FacebookPosUpload;
}


- (void)PicDownload
{
    [facebook requestWithGraphPath:@"me/albums" andDelegate:self];
}

- (void)getWholeData
{
    if(profileDatas)
    {
        [profileDatas release];
    }
    profileDatas = [[NSMutableArray alloc] init];
	[self CallGraphAPI:@"me"];
	getMessageType = ProfileClicked;
	getInfoType = profileWholeDataType;
}

- (void)getProfile
{
	[self CallGraphAPI:@"me"];
	getInfoType = profileType;
}

- (void)getInterest
{
	if(profileDatas)
    {
        [profileDatas release];
    }
    profileDatas = [[NSMutableArray alloc] init];
	[self CallGraphAPI:@"me/interests"];
	getMessageType = ProfileInterestClicked;
	getInfoType = interestType;
}

- (void)getFriendList
{
	[self CallGraphAPI:@"me/friends"];
	getInfoType = friendListType;
}

- (void)getProfileImage
{
    [self CallGraphAPI:@"me/picture"];
	getInfoType = profileImageType;
}

- (void)getGraphSearchPlaceNearBy:(CLLocationCoordinate2D)location
{
    NSString *centerLocation = [[NSString alloc] initWithFormat:@"%f,%f",
                                location.latitude,
                                location.longitude];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"place",  @"type",
                                   centerLocation, @"center",
                                   @"1000",  @"distance",
                                   nil];
    [centerLocation release];
    getInfoType = searchPlaceNearByType;
    [facebook requestWithGraphPath:@"search" andParams:params andDelegate:self]; 
}

- (void)getSearchSuggestion;
{
//	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                   text, @"message",
//                                   nil];
    
//    [facebook requestWithGraphPath:@"me/feed"
//                         andParams:params
//                     andHttpMethod:@"POST"
//                       andDelegate:self];
	
//	[facebook openUrl:@"http://www.facebook.com/search/opensearch_typeahead.php?format=xml&q=%7Bgoogle&7D"
//		   params:[NSMutableDictionary dictionary]
//	   httpMethod:@"GET"
//		 delegate:self];
	
	getInfoType = FacebookImageUpload;
}

- (void)getInterestImageURL
{
	imageNum = 0;
	if(imageDatas)
	{
		[imageDatas release];
	}
	imageDatas = [[NSMutableArray alloc] init];
	
	for (NSArray * InterestItems in profileDatas) {
		for (NSDictionary * item in InterestItems) {
			imageNum++;
		}
	}
	
	for (NSArray * InterestItems in profileDatas) {
		for (NSDictionary * item in InterestItems){
			[self CallGraphAPI:[item objectForKey:@"id"]];
			getInfoType = interestImageType;
		}
	}
	
	if(imageURLs)
	{
		[imageURLs release];
	}
	imageURLs = [[NSMutableArray alloc] init];
	
	//관심사가 없을 경우(위의 CallGraphAPI는 호출하지 않게 된다.) 따라서 바로 delegate호출.
	if(imageNum == 0)
	{
		[_delegate receivedInterestImageURL:imageURLs];
	}
}

- (void)RenderVideo:(NSString *)urlString
{
    MPMoviePlayerController* theMovie=[[MPMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:urlString]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myMovieFinishedCallback:) name:MPMoviePlayerPlaybackDidFinishNotification object:theMovie];
	[theMovie play];
}

#pragma mark - process Received Data
- (void)processWholeData:(requestMessageType)messageType withResult:(id)result
{
	UIImageView * image;
	NSURL *  url;
	switch (getMessageType) {
		case ProfileClicked:
			getMessageType = ProfileInterestClicked;
			[fbManager CallGraphAPI:@"me/interests"];
			[profileDatas addObject:result];
			return;
		case ProfileInterestClicked:
			getMessageType = ProfileBookClicked;
			[fbManager CallGraphAPI:@"me/books"];
			break;
		case ProfileBookClicked:
			getMessageType = ProfileFilmClicked;
			[fbManager CallGraphAPI:@"me/movies"];
			break;
		case ProfileFilmClicked:
			getMessageType = ProfileMusicClicked;
			[fbManager CallGraphAPI:@"me/music"];
			break;
		case ProfileMusicClicked:
			getMessageType = ProfileTVProgramClicked;
			[fbManager CallGraphAPI:@"me/television"];
			break;
		case ProfileTVProgramClicked:
			getMessageType = ProfileGameClicked;
			[fbManager CallGraphAPI:@"me/games"];
			break;
		case ProfileGameClicked:
			getMessageType = FriendListClicked;
			[fbManager CallGraphAPI:@"me/friends"];
			break;
		case FriendListClicked:
			getMessageType = GetProfileImageClicked;
//			[fbManager CallGraphAPI:@"me/picture"];
			break;
		case GetProfileImageClicked:
			return;
		default:
			break;
	}
	
	if([result objectForKey:@"data"])
		[profileDatas addObject:[result objectForKey:@"data"]]; //0:profile(NSDic *) 1 ~ 6:interest(NSDic *) 7:FriendList(NSDic *) 8:ProfileImage(UIImageView *)

	if(getMessageType == GetProfileImageClicked)
	{
		url =[NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/me/picture?access_token=%@", facebook.accessToken]];
		NSData * data = [NSData dataWithContentsOfURL:url];
		//			image = [[UIImageView alloc] initWithImage:[UIImage imageWithData:result]];
		//			image.frame = CGRectMake(20, 20, image.frame.size.width, image.frame.size.height);
		//			[profileDatas addObject:image];
		//			[image release];
		if(data != nil)
			[profileDatas addObject:[UIImage imageWithData:data]];
		[_delegate receivedWholeData:profileDatas];
	}

}

- (void)processProfileWithResult:(id)result
{
	[_delegate receivedProfileData:result];
}

- (void)processInterest:(requestMessageType)messageType withResult:(id)result
{
	switch (getMessageType) {
		case ProfileInterestClicked:
			getMessageType = ProfileBookClicked;
			[fbManager CallGraphAPI:@"me/books"];
			break;
		case ProfileBookClicked:
			getMessageType = ProfileFilmClicked;
			[fbManager CallGraphAPI:@"me/movies"];
			break;
		case ProfileFilmClicked:
			getMessageType = ProfileMusicClicked;
			[fbManager CallGraphAPI:@"me/music"];
			break;
		case ProfileMusicClicked:
			getMessageType = ProfileTVProgramClicked;
			[fbManager CallGraphAPI:@"me/television"];
			break;
		case ProfileTVProgramClicked:
			getMessageType = ProfileGameClicked;
			[fbManager CallGraphAPI:@"me/games"];
			break;
		case ProfileGameClicked:
			[profileDatas addObject:[result objectForKey:@"data"]];
			[_delegate receivedInterestData:profileDatas];
			
			[self getInterestImageURL];
			return;
		default:
			break;
	}
	
	[profileDatas addObject:[result objectForKey:@"data"]];
}

- (void)processFriendListWithResult:(id)result
{
	[_delegate receivedFriendListData:[result objectForKey:@"data"]];
}

- (void)processProfileImageWithResult:(id)result
{
	UIImageView * image;
	image = [[UIImageView alloc] initWithImage:[UIImage imageWithData:result]];
	image.frame = CGRectMake(20, 20, image.frame.size.width, image.frame.size.height);
	[_delegate receivedProfileImage:[image retain]];
	[image release];
	
}

- (void)processInterestImageURL:(id)result
{
	NSLog(@"result:%@ Picture:%@", result, [result objectForKey:@"picture"]);
//	[_delegate receivedInterestImageURL:[result objectForKey:@"picture"]];
	
	NSString * url = [result objectForKey:@"picture"];
	if(url == nil)
	{
//		imageNum--;
//		return;
		url = @"";
	}
		
	[imageURLs addObject:url];
	
	if([imageURLs count] == imageNum)
	{
		[_delegate receivedInterestImageURL:imageURLs];
	}
	
	
	httpManager = [FBHTTPManager sharedObject];
	[httpManager setDelegate:self];
	[httpManager setRequestType:ProfileInterestRequest];
	[httpManager request:url query:@"" httpMethod:@"GET"];
}

- (void) processGraphSearchPlaceNearBy:(id)result
{
    NSMutableArray *places = [[NSMutableArray alloc] initWithCapacity:1];
    NSArray *resultData = [result objectForKey:@"data"];
    for (NSUInteger i=0; i<[resultData count] && i < 5; i++) {
        [places addObject:[resultData objectAtIndex:i]];
        NSLog(@"Geo Infomation : %@", [resultData objectAtIndex:i]);
    }
    
    NSLog(@"Delegate%@", _delegate);
    [_delegate receivedSearchPlace:places];
}
#pragma mark - FBRequestDelegate
/**
 서버에서 처리된 메시지를 응답 받을 떄 실행되는 함수이다.
 
 - (FBRequest*)requestWithMethodName:(NSString *)methodName
 andParams:(NSMutableDictionary *)params
 andHttpMethod:(NSString *)httpMethod
 andDelegate:(id <FBRequestDelegate>)delegate;
 
 - (FBRequest*)requestWithGraphPath:(NSString *)graphPath
 andDelegate:(id <FBRequestDelegate>)delegate;
 
 등의 함수가 실행될 때 delegate에 넣으면 응답을 받는다. 
 */

- (void)requestLoading:(FBRequest *)request
{
    
}

- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response;
{
    
}

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error;
{
	NSLog(@"error:%@", error);
	if(![[error  domain] isEqualToString:NSURLErrorDomain])
	{
		[self logout];
	}
	if ([_delegate performSelector:@selector(receivedFailed)]) 
		[_delegate receivedFailed];
}

- (void)request:(FBRequest *)request didLoad:(id)result;
{
    NSLog(@"%@",result);
    if([result isKindOfClass:[NSArray class]])
    {
        result = [result objectAtIndex:0];
    }
//    NSLog(@"%@",result);
    
    //    NSString * name = [result objectForKey:@"name"];
	
	//Get Whole Infomation of me
	if(getInfoType == profileWholeDataType)
	{
		[self processWholeData:getMessageType withResult:result];
    }
	else if(getInfoType == profileType)
	{
		[self processProfileWithResult:result];
	}
	else if(getInfoType == interestType)
	{
		[self processInterest:getMessageType withResult:result];
	}
	else if(getInfoType == friendListType)
	{
		[self processFriendListWithResult:result];
	}
	else if(getInfoType == profileImageType)
	{
		[self processProfileImageWithResult:result];
	}
	else if(getInfoType == interestImageType)
	{
		[self processInterestImageURL:result];
	}
    else if(getInfoType == searchPlaceNearByType)
    {
        [self processGraphSearchPlaceNearBy:result];
    }
    else if(getInfoType == FacebookImageUpload)
    {
        [delegate uploadFBFinished];
    }
	else
	{
		NSLog(@"request Type is Upload");
		[[NSNotificationCenter defaultCenter] postNotificationName:@"facebookUploadDidFinishNotification" object:nil];
	}
   
}

- (void)request:(FBRequest *)request didLoadRawResponse:(NSData *)data;
{
    
}


#pragma - FBSessionDelegate
- (void)fbDidLogin
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[facebook expirationDate] forKey:@"FBExpirationDateKey"];
	[defaults setBool:YES forKey:@"isLogined"];
    [defaults synchronize];
	if([_delegate respondsToSelector:@selector(fbDidLogin)] == YES)
		[_delegate fbDidLogin];   
	
	logined = YES;
}

- (void)storeAuthData:(NSString *)accessToken expiresAt:(NSDate *)expiresAt {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:accessToken forKey:@"FBAccessTokenKey"];
    [defaults setObject:expiresAt forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
}

-(void)fbDidExtendToken:(NSString *)accessToken expiresAt:(NSDate *)expiresAt {
    NSLog(@"token extended");
    [self storeAuthData:accessToken expiresAt:expiresAt];
}

- (void)fbDidNotLogin:(BOOL)cancelled
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setBool:NO forKey:@"isLogined"];
	if([_delegate respondsToSelector:@selector(fbDidNotLogin:)] == YES)
		[_delegate fbDidNotLogin:cancelled];   
	
	logined = NO;	
}

- (void)fbDidLogout
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setBool:NO forKey:@"isLogined"];
	if([_delegate respondsToSelector:@selector(fbDidLogout)] == YES)
		[_delegate fbDidLogout];

	logined = NO;
}


#pragma mark - FBHTTPManagerDelegate
- (void)giveImageResource:(id)image
{
	// 재훈앙
	//	[imageDatas addObject:image];
	
	if([imageDatas count] == imageNum)
	{
//		[_delegate receivedInterestImageURL:@""];
		[_delegate receivedInterestImages:imageDatas];
	}
}

@end
