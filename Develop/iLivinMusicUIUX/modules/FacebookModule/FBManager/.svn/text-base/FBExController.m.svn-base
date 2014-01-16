//
//  FBExController.m
//  MnFramework
//
//  Created by  on 12. 4. 26..
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FBExController.h"
#import "BasicCompHelper.h"

@implementation FBExController

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

- (void)viewDidLoad
{
    [super viewDidLoad];

	fbManager = [FBManager sharedObject];
	[fbManager setDelegate:self];

	loginButton = [BasicCompHelper buttonCreationWithStyle:UIButtonTypeRoundedRect rect:CGRectMake(20, 30, 280, 40) title:@"로그아웃" target:self buttonAction:@selector(fbloginOnAction)];
	[self.view addSubview:loginButton];
	
	if([fbManager Logined])
	{
		[loginButton setTitle:@"로그아웃" forState:UIControlStateNormal];
	
		[self buttonConfiguration];
		
		infoTextView = [BasicCompHelper textViewCreation:CGRectMake(20, 110, 220, 70) delegate:self fontSize:12.0f];
		profileImage = [BasicCompHelper imageCreation:CGRectMake(125, 220, 70, 70) imageName:nil];
		uploadText = [BasicCompHelper textFieldCreation:CGRectMake(20, 330, 220, 30) fontSize:12.0f delegate:self];
		
		[self.view addSubview:[BasicCompHelper labelCreation:CGRectMake(20, 80, 280, 20) labelText:@"개인정보" fontSize:12.0f]];
		[self.view addSubview:infoTextView];
		[self.view addSubview:[BasicCompHelper labelCreation:CGRectMake(20, 190, 280, 20) labelText:@"이미지" fontSize:12.0f]];
		[self.view addSubview:profileImage];
		[self.view addSubview:[BasicCompHelper labelCreation:CGRectMake(20, 300, 220, 20) labelText:@"텍스트와 이미지 업로드" fontSize:12.0f]];
		[self.view addSubview:uploadText];
	}
	else
		[loginButton setTitle:@"로그인" forState:UIControlStateNormal];
}

- (void)buttonConfiguration
{
	getInfoButton = [BasicCompHelper buttonCreationWithStyle:UIButtonTypeRoundedRect rect:CGRectMake(245, 110, 50, 70) title:@"가져\n오기" target:self buttonAction:@selector(fbGetInfo:)];
	getInfoButton.titleLabel.numberOfLines = 2;
	getInfoButton.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
	getInfoButton.tag = 0; 
	
	textUploadButton = [BasicCompHelper buttonCreationWithStyle:UIButtonTypeRoundedRect rect:CGRectMake(245, 330, 50, 30) title:@"업로드" target:self buttonAction:@selector(upload:)];
	textUploadButton.tag = 0;
	positionUploadButton = [BasicCompHelper buttonCreationWithStyle:UIButtonTypeRoundedRect rect:CGRectMake(205, 370, 90, 30) title:@"위치 업로드" target:self buttonAction:@selector(upload:)];
	positionUploadButton.tag = 1;
	
	[self.view addSubview:getInfoButton];
	[self.view addSubview:textUploadButton];
	[self.view addSubview:positionUploadButton];
}

- (void)fbloginOnAction
{
	if([fbManager Logined])
		[fbManager logout];
	else
		[fbManager login];
}

- (void)fbGetInfo:(UIButton *)button
{
	switch (button.tag) {
		case 0:
			[fbManager getWholeData];
			break;
		case 1:
//			[fbManager getWholeData];
			break;
		default:
			break;
	}

}

- (void)upload:(UIButton *)button
{
	switch (button.tag) {
		case 0:
			break;
		case 1:
			[fbManager PosUpload:@"111664535537155" message:@"테스트장소" tags:[NSArray arrayWithObjects: @"test", @"test", nil]];
			break;
		default:
			break;
	}	
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
    
    infoTextView.text = APPENDSTRING(infoTextView.text, @"%@", profile);
	
	[dateFormatter release];
}

- (void)setProfileOnInterestText:(NSDictionary *)result
{
    //취미(Interests / Arts and Entertainment(Music, Add books, Add Films, Add TV Program, Add games)
	infoTextView.text = APPENDSTRING(infoTextView.text, @"%@'s name:%@\n", [result objectForKey:@"category"], [result objectForKey:@"name"]);
}

- (void)setFriendList:(NSArray *)result
{
    for(int i = 0 ; i < [result count] ; i++)
        infoTextView.text = APPENDSTRING(infoTextView.text, @"%@, ", [[result objectAtIndex:i] objectForKey:@"name"]);
}


#pragma mark - fbDelegate
- (void)fbDidLogin
{
	[loginButton setTitle:@"로그아웃" forState:UIControlStateNormal];	
	[self viewDidLoad];
}

- (void)fbDidLogout
{
	[loginButton setTitle:@"로그인" forState:UIControlStateNormal];
}

- (void)receivedWholeData:(NSArray *)wholeDatas
{
	for(int i = 0 ; i < [wholeDatas count]; i++) //0:Profile 1~6:Interest 7:FriendList 8:ProfileImage
	{
		NSLog(@"Received:%d", i);
		if(i == 1)
			infoTextView.text = APPENDSTRING(infoTextView.text, @"\n%@\n", @"Interest");
		else if(i == 7)
			infoTextView.text = APPENDSTRING(infoTextView.text, @"\n%@\n", @"Friends");
		
		if(i == 0)
			[self setProfileOnText:[wholeDatas objectAtIndex:i]];
		else if(i == 7)
			[self setFriendList:[wholeDatas objectAtIndex:i]];
		else if(i == 8)
//			[self.view addSubview:[wholeDatas objectAtIndex:i]];
			[profileImage setImage:[wholeDatas objectAtIndex:i]];
		else
		{
			if([[wholeDatas objectAtIndex:i] count] != 0)
				[self setProfileOnInterestText:[[wholeDatas objectAtIndex:i] objectAtIndex:0]];
		}
	}
}

- (void)receivedFailed
{
	
}
@end
