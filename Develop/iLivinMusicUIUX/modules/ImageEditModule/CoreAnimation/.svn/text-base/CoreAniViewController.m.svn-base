//
//  CoreAniViewController.m
//  MnFramework
//
//  Created by  on 11. 6. 16..
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CoreAniViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation CoreAniViewController

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
	UIImage * img = [UIImage imageNamed:@"yuna.jpg"];
	
	CALayer * sub = [CALayer layer];
	sub.contents = img.CGImage;
	sub.frame = CGRectMake(0, 0, 320, 460);
	
	[self.view.layer addSublayer:sub];
	
	CABasicAnimation * ani = [CABasicAnimation animationWithKeyPath:@"opacity"];
	ani.duration = 2.0;
	ani.repeatCount = HUGE_VALF;
	ani.autoreverses = YES;
	ani.fromValue = [NSNumber numberWithFloat:0.0];
	ani.toValue = [NSNumber numberWithFloat:1.0];
	ani.timingFunction = [CAMediaTimingFunction	functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	
	[sub addAnimation:ani forKey:@"opacity"];
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

@end
