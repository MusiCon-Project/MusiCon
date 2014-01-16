//
//  AlbumGestureRecognizer.m
//  iLivinMusicUIUX
//
//  Created by jaehoon lee on 4/1/12.
//  Copyright (c) 2012 Kaist. All rights reserved.
//

#import "AlbumGestureRecognizer.h"
#import "album.h"

@implementation AlbumGestureRecognizer
@synthesize receivedView;

#pragma mark - Touch Event
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSArray *allTouches = [touches allObjects]; 
	int count = [allTouches count];
	if (count == 1) {
		touch = [[allTouches objectAtIndex:0] locationInView:[receivedView superview]]; 
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        
        receivedView.frame = CGRectMake(receivedView.frame.origin.x - AlbumStrokeLength / 2, receivedView.frame.origin.y - AlbumStrokeLength / 2, AlbumStrokeLength * 2, AlbumStrokeLength * 2);

        receivedView.albumStroke.frame = CGRectMake(receivedView.albumStroke.frame.origin.x - AlbumStrokeLength / 2, receivedView.albumStroke.frame.origin.y - AlbumStrokeLength / 2, AlbumStrokeLength * 2, AlbumStrokeLength * 2);
//        [receivedView.albumStroke setImage:bigStroke];
        receivedView.albumjaket.frame = CGRectMake(receivedView.albumjaket.frame.origin.x - AlbumLength / 2, receivedView.albumjaket.frame.origin.y - AlbumLength / 2, AlbumLength * 2, AlbumLength * 2);
//        [receivedView.albumjaket setImage:bigjaket];
//        [albumjaketlayer setCornerRadius:AlbumLength];

//        [albumjaket setImage:bigjaket];
//        [albumjaketlayer setCornerRadius:AlbumLength];
        [UIView commitAnimations];
	}
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	NSArray *allTouches = [touches allObjects]; 
	int count = [allTouches count]; 
    
	if (count == 1) {
        {
            currentTouch = [[allTouches objectAtIndex:0] locationInView:[receivedView superview]]; 
            CGFloat dx = currentTouch.x - touch.x;
            CGFloat dy = currentTouch.y - touch.y;
            
            receivedView.frame = CGRectMake(receivedView.frame.origin.x + dx, receivedView.frame.origin.y + dy, receivedView.frame.size.width, receivedView.frame.size.height);
            
            touch = currentTouch;
            
		}
	}
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}
@end
