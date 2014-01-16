//
//  BasicCompViewController.m
//  MnFramework
//
//  Created by  on 12. 4. 10..
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BasicCompViewController.h"
#import "BasicCompHelper.h"
#import <QuartzCore/QuartzCore.h>
@implementation BasicCompViewController

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
	[self.view addSubview:[BasicCompHelper labelCreation:CGRectMake(10, 10, 150, 20) labelText:@"라벨 test" fontSize:20.0]];
	[self.view addSubview:[BasicCompHelper imageCreation:CGRectMake(10, 35, 100, 50) imageName:@"yuna.jpg"]];
	[self.view addSubview:[BasicCompHelper buttonCreation:CGRectMake(10, 90, 70, 30) normalButtonImage:@"btn_set_nor.png" highlightButtonImage:@"btn_set_pre.png" target:self buttonAction:@selector(buttonAction:)]];

	[self.view addSubview:[BasicCompHelper textFieldCreation:CGRectMake(10, 125, 100, 30) fontSize:12.0f delegate:self]];
	[self.view addSubview:[BasicCompHelper detailTextFieldCreation:CGRectMake(120, 125, 100, 30) font:[UIFont fontWithName:@"ArialRoundedMTBold" size:12.0f] textColor:RGB(0, 50, 100) borderStyle:UITextBorderStyleLine delegate:self returnKeyType:UIReturnKeySearch secureTextEntry:NO]];
	
	[self.view addSubview:[BasicCompHelper segmentedControlCreation:CGRectMake(10, 160, 140, 30) items:[NSArray arrayWithObjects:@"아이폰", @"안드로이드", nil] target:self selector:@selector(segmentTestOnAction:) fontSize:12.0f]]; 
	[self.view addSubview:[BasicCompHelper detailSegmentedControlCreation:CGRectMake(160, 160, 140, 30) items:[NSArray arrayWithObjects:@"아이폰", @"안드로이드", nil] target:self selector:@selector(segmentTestOnAction:) segmentControlStyle:UISegmentedControlStyleBordered tintColor:[UIColor grayColor] font:[UIFont fontWithName:@"ArialRoundedMTBold" size:12.0f]]];

	[self.view addSubview:[BasicCompHelper textViewCreation:CGRectMake(10, 200, 150, 70) delegate:self fontSize:12.0f]];
	UITextView * textView = [BasicCompHelper detailTextViewCreation:CGRectMake(165, 200, 150, 70) delegate:self font:[UIFont fontWithName:@"ArialRoundedMTBold" size:12.0f] textColor:[UIColor blueColor] bgColor:[UIColor grayColor] keyBoardType:UIKeyboardTypeAlphabet];
	[self.view addSubview:textView];
	[BasicCompHelper textViewBoundarySetting:textView cornerRadius:5.0f borderColor:[UIColor blackColor] borderWidth:1.0f];

	
	[self.view addSubview:[BasicCompHelper sliderCreation:CGRectMake(10, 275, 150, 20) target:self action:@selector(sliderOnAction:)]];
	UISlider * slider = [BasicCompHelper detailSliderCreation:CGRectMake(165, 275, 150, 20) target:self action:@selector(sliderOnAction:) maxValue:1.0f minValue:0.0f value:0.5f];
	[self.view addSubview:slider];
	UIImage * minImage = [[UIImage imageNamed:@"yellowslide.png"] stretchableImageWithLeftCapWidth:8 topCapHeight:2.25];
	UIImage * maxImage = [[UIImage imageNamed:@"orangeslide.png"] stretchableImageWithLeftCapWidth:8 topCapHeight:2.25];

	[BasicCompHelper sliderSetting:slider minImage:minImage maxImage:maxImage];

	UIProgressView * progressView_01 = [BasicCompHelper progressViewCreation:CGRectMake(10, 300, 150, 20) progressValue:0.5 style:UIProgressViewStyleDefault];
	[BasicCompHelper progressViewSetting:progressView_01 progressImage:minImage trackImage:maxImage progressTintColor:nil trackTintColor:nil];
	[self.view addSubview:progressView_01];	
	UIProgressView * progressView_02 = [BasicCompHelper progressViewCreation:CGRectMake(165, 300, 150, 20) progressValue:0.5 style:UIProgressViewStyleDefault];
	[BasicCompHelper progressViewSetting:progressView_02 progressImage:nil trackImage:nil progressTintColor:[UIColor yellowColor] trackTintColor:[UIColor blueColor]];
	[self.view addSubview:progressView_02];
}

- (void)buttonAction:(id)sender
{
	
}

- (void)segmentTestOnAction:(id)sender
{
	UISegmentedControl * segCtl = sender;
	if ([segCtl selectedSegmentIndex] == 0) 
	{
		
	}
	else if ([segCtl selectedSegmentIndex] == 1) 
	{
		
	}
}

- (void)sliderOnAction:(UISlider *)sender
{
	NSLog(@"%f", sender.value);
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

#pragma mark - TextField Delegate
//TextField 편집이 시작했을 때
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
}

//TextField 완료 버튼을 눌렀을 때
- (BOOL)textFieldShouldReturn:(UITextField *)aTextField;
{	
	[aTextField resignFirstResponder];
	return YES;
}

//TextField에서 글자가 하나하나 입력될 때
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	return YES;
}

#pragma mark - TextView Delegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
	[self.view setFrame:CGRectMake(0, -70, self.view.frame.size.width, self.view.frame.size.height)];
}

- (void)textViewDidEndEditing:(UITextView *)textView;
{
	[self.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
}

//밑에 함수와 비슷한 기능을 수행하나... 복사 붙여넣기 햇을떄는 해당 함수만 호출됨.
- (void)textViewDidChange:(UITextView *)aTextView
{

}

- (BOOL)textView:(UITextView *)aTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
	if([text isEqualToString:@"\n"])
	{
		[aTextView resignFirstResponder];
		
		return NO;
	}
	
	return YES;
}

@end
