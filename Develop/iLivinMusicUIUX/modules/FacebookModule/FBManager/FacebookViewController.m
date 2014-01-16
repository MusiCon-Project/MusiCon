//
//  FacebookViewController.m
//  VariousModule
//
//  Created by JHLee on 11. 6. 16..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FacebookViewController.h"

//typedef enum
//{
//	ProfileInterestRequest,
//	SuggestionListImageRequest,
//}ImageRequestType;

@implementation FacebookViewController

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
    if(fbManager)
        [fbManager release];
    [super dealloc];
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
//    callGraphAPI.hidden = YES;
//    callRestAPI.hidden = YES;
//    TextUpLoad.hidden = YES;
//    PicUpload.hidden = YES;
//    PicDownload.hidden = YES;
    
    IsLogin = NO;
    interestProfile = @"";
    friendlist = @"";
    // Do any additional setup after loading the view from its nib.
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

#pragma mark - FaceViewController Utilities for show views
- (void)setProfileOnText:(NSDictionary *)result
{
	//============ Code Piece For NSDate =============//
    NSString * profile = @"";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	
	[dateFormatter setDateFormat:@"dd/MM/YYYY"];
	NSDate * dateFromString;
	dateFromString = [dateFormatter dateFromString:[result objectForKey:@"birthday"]];
	
	[dateFormatter setDateFormat:@"YYYY.MM.dd"];
	NSString * birthday = [dateFormatter stringFromDate:dateFromString];
	//============ Code Piece For NSDate =============//
	
	
	
    //기본 신상정보
    APPENDSTRING(profile, @"name : %@\n", [result objectForKey:@"name"]);
    APPENDSTRING(profile, @"sex : %@\n", [result objectForKey:@"gender"]);
    APPENDSTRING(profile, @"birthday : %@\n", birthday);
    APPENDSTRING(profile, @"location : %@\n", [[result objectForKey:@"location"] objectForKey:@"name"]);
    
    //네트워크(학교/직장)
    NSArray * schools = [result objectForKey:@"education"];
    for(int i = 0 ; i < [schools count]; i++)
    {
        APPENDSTRING(profile, @"school : %@\n", [[[schools objectAtIndex:i] objectForKey:@"school"] objectForKey:@"name"]);
    }
    
    NSArray * works = [result objectForKey:@"work"];
    for(int i = 0 ; i < [works count]; i++)
    {
        APPENDSTRING(profile, @"company : %@\n", [[[works objectAtIndex:i] objectForKey:@"employer"] objectForKey:@"name"]);
    }
    
    text.text = profile;

	[dateFormatter release];
}

- (void)setProfileOnInterestText:(NSDictionary *)result
{
    //취미(Interests / Arts and Entertainment(Music, Add books, Add Films, Add TV Program, Add games)
    interestText.text = APPENDSTRING(interestProfile, @"%@'s name:%@\n", [result objectForKey:@"category"], [result objectForKey:@"name"]);
}

- (void)setFriendList:(NSArray *)result
{
    for(int i = 0 ; i < [result count] ; i++)
        friends.text = APPENDSTRING(friendlist, @"%@, ", [[result objectAtIndex:i] objectForKey:@"name"]);
}
    

#pragma mark - IBAction
- (IBAction)buttonOnClicked
{   

    if ([fbManager Logined]==NO) {
        fbManager = [FBManager sharedObject];
        [fbManager setDelegate:self];
//        NSLog(@"ACCESS:%@ EXPRIATIONDATE:%@",fbManager.facebook.accessToken, fbManager.facebook.expirationDate);
        [fbManager login];
    }else{
//        [fbManager logout];        
    }
    
//    IsLogin = !IsLogin;
}

- (IBAction)buttonOnClickedCallGraphAPI
{
    [fbManager getWholeData];
}

- (IBAction)buttonOnClickedCallRestAPI
{
//    [fbManager CallRestAPI];
//	[fbManager getFriendList];
	[fbManager getInterest];
}

- (IBAction)buttonOnClickedTextUpload
{
	view = [[UIView alloc] initWithFrame:CGRectMake(60, 30, 200, 120)];
	[view setBackgroundColor:[UIColor orangeColor]];

	textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, 180, 70)];
	UIButton * button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[button setFrame:CGRectMake(10, 85, 180, 30)];
	[button setTitle:@"확인" forState:UIControlStateNormal];
	[button addTarget:self action:@selector(sendTextToFacebook) forControlEvents:UIControlEventTouchUpInside];
	
	[view addSubview:textView];
	[view addSubview:button];
	
	[self.view addSubview:view];
	[view release];
	[textView release];
}

- (void)sendTextToFacebook
{
	[fbManager TextUpload:textView.text];
	
	UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:@"" message:@"글이 전송되었습니다." delegate:self cancelButtonTitle:@"확인" otherButtonTitles: nil];
	[alertview show];
	
	[view removeFromSuperview];
}

- (IBAction)buttonOnClickedPicUpload
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:picker.sourceType];
    
    [self presentModalViewController:picker animated:YES];
    [picker release];
    
//    [fbManager PicUpload];
}

- (IBAction)buttonOnClickedPicDownload
{
//    [fbManager PicDownload];
}

- (IBAction)buttonOnClickedFriendsDownload
{
	[fbManager getFriendList];
}

- (IBAction)buttonOnClickedGetProfileImage
{
    [fbManager getProfileImage];
}

- (IBAction)buttonOnClickedGetSearchSuggstion
{
	
	if(!searchList)
	{
		UIView					* searchBackground = [[UIView alloc] initWithFrame:CGRectMake(20, 60, 280, 40)];
		[searchBackground	setBackgroundColor:[UIColor orangeColor]];
		searchList  = [[UITextField alloc] initWithFrame:CGRectMake(5, 5, 270, 30)];
		[searchList		addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
		[searchList		setBackgroundColor:[UIColor whiteColor]];
		[searchBackground addSubview:searchList];
		[self.view addSubview:searchBackground];
	}
	
	
	
	
//	HTTPManager				* httpManager = [HTTPManager sharedObject];
//						"&%@", fbManager.facebook.accessToken];
//	NSString * encoded = [query stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
//	NSString * encoded = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)@"{google}", NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);
//	NSString * query = [NSString stringWithFormat:@"format=xml&q=%@", encoded];
//	[httpManager	request:@"http://www.facebook.com/search/opensearch_typeahead.php?" query:@"format=xml&q=%7Bgoogle%7D" httpMethod:@"POST"];

//	[httpManager	request:@"http://www.facebook.com/search/opensearch_typeahead.php?format=xml&q=%7Bgoogle%7D" query:@"" httpMethod:@"POST"];
	
//	[fbManager getSearchSuggestion];
}

- (void)getInterestImage:(NSString *)url index:(NSInteger)interestIndex
{
	//getImageURL
	httpManager = [FBHTTPManager sharedObject];
	[httpManager setDelegate:self];
	[httpManager setIndex:interestIndex];
	[httpManager setRequestType:ProfileInterestRequest];
	[httpManager request:url query:@"" httpMethod:@"GET"];
}

#pragma mark - TextFieldDelegate
- (void)textFieldDidChange:(UITextField *)textField
{
	if(httpManager)
	{
		if ([httpManager OperationExistInQueue]) 
		{
			[httpManager removeOperationInQueue];
		}
	}
	
	FBXMLParser				* fbXMLParser = [FBXMLParser sharedObject];
	[fbXMLParser setDelegate:self];
//	[fbXMLParser setSearchKeyword:textField.text];
	[fbXMLParser parseOnBackGroundThread:textField.text]; 
	
}

#pragma mark - FBXMLParserDelegate
/*
- (void)giveSuggestList:(NSArray *)suggestList	
{
//	suggestList = suggestListInst;
	
	//get ImageView
	int index = 0;
	
	httpManager = [FBHTTPManager sharedObject];
	[httpManager setDelegate:self];
	[httpManager setRequestType:SuggestionListImageRequest];
	[httpManager setIndex:index];
	
	for (SearchSuggestion * item in suggestList) {

		[httpManager request:item.ImageSource query:@"" httpMethod:@"GET"];
		index++;
	}
	
	//add SearchScrollView and add text & image
	if(searchSuggestScrollView)
	{
		[searchSuggestScrollView removeFromSuperview];
		[searchSuggestScrollView release];
	}
	
	searchSuggestScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(20, 120, 280, 70)];
	[searchSuggestScrollView setContentSize:CGSizeMake(index * (100 + 5), 70)];
	[searchSuggestScrollView setScrollEnabled:YES];
	[searchSuggestScrollView setDelegate:self];
	[self.view addSubview:searchSuggestScrollView];
	
	index = 0;
	for (SearchSuggestion * item in suggestList) {
		UILabel * test = [[UILabel alloc] initWithFrame:CGRectMake(5 + index * 105, 5, 100, 20)];
		[text setTextColor:[UIColor blackColor]];
		[test setFont:[UIFont fontWithName:@"ArialRoundedMTBold" size:12]];
		[test setText:item.Text];
		[searchSuggestScrollView addSubview:test];
		//		[self.view addSubview:test];
		[test release];
		
		index++;
	}
}
*/
- (void)giveSuggestList:(NSArray *)suggestList	
{
	//	suggestList = suggestListInst;
	
	//get ImageView
	int index = 0;
	
	httpManager = [FBHTTPManager sharedObject];
	[httpManager setDelegate:self];
	[httpManager setRequestType:SuggestionListImageRequest];
	[httpManager setIndex:index];
	
	for (SearchSuggestion * item in suggestList) {
		
		[httpManager request:item.ImageSource query:@"" httpMethod:@"GET"];
		index++;
	}
	
	//add SearchScrollView and add text & image
	if(searchSuggestScrollView)
	{
		[searchSuggestScrollView removeFromSuperview];
		[searchSuggestScrollView release];
	}
	
	searchSuggestScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(20, 120, 280, 70)];
	[searchSuggestScrollView setContentSize:CGSizeMake(index * (100 + 5), 70)];
	[searchSuggestScrollView setScrollEnabled:YES];
	[searchSuggestScrollView setDelegate:self];
	[self.view addSubview:searchSuggestScrollView];
	
	index = 0;
	for (SearchSuggestion * item in suggestList) {
		/*
		UILabel * test = [[UILabel alloc] initWithFrame:CGRectMake(5 + index * 105, 5, 100, 20)];
		[text setTextColor:[UIColor blackColor]];
		[test setFont:[UIFont fontWithName:@"ArialRoundedMTBold" size:12]];
		[test setText:item.Text];
		[searchSuggestScrollView addSubview:test];
		//		[self.view addSubview:test];
		[test release];
		*/
		UIButton *networkItemButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[networkItemButton setFrame:CGRectMake(7, 7 + (34 + 7 + 7 + 7) * index , 204, 34	+	7	+7)];
		[networkItemButton.titleLabel setFrame:CGRectMake(12, 7, 166, 34)];
		[networkItemButton.titleLabel setFont:[UIFont fontWithName:@"ArialRoundedMTBold" size:15]];
		[networkItemButton.titleLabel setText:item.Text];
		[searchSuggestScrollView addSubview:networkItemButton];
		
		index++;
	}
	
	[searchSuggestScrollView setFrame:CGRectMake(23, searchSuggestScrollView.frame.origin.y, 204, 7 + (34 + 7 + 7 + 7) * index)];
	
	
}
#pragma mark - FBHTTPManagerDelegate
- (void)giveImageResource:(UIImage *)image index:(NSInteger)index searchList:(NSArray *)searchList requestType:(NSInteger)requestType
{
	if(requestType == SuggestionListImageRequest)
	{
		SearchSuggestion * item = [suggestList objectAtIndex:index];
		item.Image = [image retain];
		
		UIImageView * test2 = [[UIImageView alloc] initWithFrame:CGRectMake(5 + index * 105, 27, 50, 50)];
		[test2 setImage:image];
		[test2 setBackgroundColor:[UIColor blackColor]];
		[searchSuggestScrollView addSubview:test2];
	//	[self.view addSubview:test2];
		[test2 release];
	}
//	else if(requestType == ProfileInterestRequest)
//	{
//		int HeightIndex = (5 + index * 55) / 320;
//		int WidthIndex = (5 + index * 55) % 320;
//		UIImageView * test3 = [[UIImageView alloc] initWithFrame:CGRectMake(WidthIndex, 27 + HeightIndex * 55, 50, 50)];
//		[test3 setImage:image];
//		[self.view addSubview:test3];
//		[test3 release];
//	}
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    /*
    UIImageView * imageView = [[UIImageView alloc] initWithImage:[info objectForKey:UIImagePickerControllerEditedImage]]; 
    [imageView setFrame:CGRectMake(20, 20, 500, 500)];
    [self.view addSubview:imageView];
    */
    
    [fbManager PicUploadWithImage:[info objectForKey:UIImagePickerControllerEditedImage] withText:@"image Filter"];
    NSLog(@"URL:%@", [info objectForKey:UIImagePickerControllerMediaURL]);
    [picker dismissModalViewControllerAnimated:YES];
    //[fbManager PicUploadWithURL:[info objectForKey:UIImagePickerControllerMediaURL]];
    //[fbManager  RenderVideo:[info objectForKey:UIImagePickerControllerMediaURL]];
}

#pragma mark - FBManagerDelegate
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

- (void)request:(FBRequest *)request didLoad:(id)result;
{

	if([result isKindOfClass:[UIImage class]])
	{
		[self.view addSubview:result];
		[result release];
	}
	
}

- (void)fbDidLogin
{
    [facebookLogin setTitle:@"Logout" forState:UIControlStateNormal];
    text.hidden = NO;
    text.text = @"LoginedIn";
}

- (void)fbDidLogout
{
    [facebookLogin setTitle:@"Login" forState:UIControlStateNormal];
    
    text.hidden = NO;
    text.text = @"Please Login";
}


- (void)receivedWholeData:(NSArray *)wholeDatas
{
	for(int i = 0 ; i < [wholeDatas count]; i++) //0:Profile 1~6:Interest 7:FriendList 8:ProfileImage
	{
		if(i == 0)
			[self setProfileOnText:[wholeDatas objectAtIndex:i]];
		else if(i == 7)
			[self setFriendList:[wholeDatas objectAtIndex:i]];
		else if(i == 8)
			[self.view addSubview:[wholeDatas objectAtIndex:i]];
		else
		{
			if([[wholeDatas objectAtIndex:i] count] != 0)
				[self setProfileOnInterestText:[[wholeDatas objectAtIndex:i] objectAtIndex:0]];
		}
	}
}

- (void)receivedProfileData:(NSDictionary *)profileDatas
{
	[self setProfileOnText:profileDatas];
}

- (void)receivedInterestData:(NSArray *)interestDatas
{
	interestProfile = @"";
	interestIndex = 0;
	for(int i = 0 ; i < [interestDatas count]; i++) //0:Interest 1:Book 2:Film 3:Music 4:TVProgram 5:Game
	{
		for (NSDictionary * item in [interestDatas objectAtIndex:i]) 
		{
			[self setProfileOnInterestText:item];
		}
	}
}

- (void)receivedFriendListData:(NSArray *)friendListDatas
{
	friendlist = @"";
	[self setFriendList:friendListDatas];
}

- (void)receivedProfileImage:(UIImageView *)profileImage
{
	[self.view addSubview:profileImage];
	[profileImage release];
}

- (void)receivedInterestImageURL:(NSArray *)urls
{
//	[self getInterestImage:url index:interestIndex];
//	interestIndex++;
	for (NSString * item in urls) {
		NSLog(@"%@", item);
	}
}

- (void)receivedInterestImages:(NSArray *)interestImages
{
	for(int index = 0; index < [interestImages count]; index++)
	{
		int HeightIndex = (5 + index * 55) / 320;
		int WidthIndex = (5 + index * 55) % 320;
		UIImageView * test3 = [[UIImageView alloc] initWithFrame:CGRectMake(WidthIndex, 27 + HeightIndex * 55, 50, 50)];
		[test3 setImage:[interestImages objectAtIndex:index]];
		[self.view addSubview:test3];
		[test3 release];
	}
}
@end