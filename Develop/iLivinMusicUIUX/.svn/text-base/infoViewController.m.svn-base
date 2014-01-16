//
//  infoViewController.m
//  iLivinMusicUIUX
//
//  Created by jaehoon lee on 5/27/12.
//  Copyright (c) 2012 Kaist. All rights reserved.
//

#import "infoViewController.h"
#import "iLivinMusicMainViewController.h"

@interface infoViewController ()

@end

@implementation infoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(10, 20, 300, 50);
    [button setTitle:@"닫기" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(cancelOnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)cancelOnAction
{
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDuration:0.6];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(cancelDone)];
    self.view.frame = CGRectMake(albumStorageAlbumSpace, 460, 320, 460);
    [UIView commitAnimations];
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

@end
