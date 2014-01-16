//
//  AlbumGestureRecognizer.h
//  iLivinMusicUIUX
//
//  Created by jaehoon lee on 4/1/12.
//  Copyright (c) 2012 Kaist. All rights reserved.
//

#import <Foundation/Foundation.h>
@class album;
@interface AlbumGestureRecognizer : UILongPressGestureRecognizer
{
    CGPoint touch;
    CGPoint currentTouch;
    
    album * receivedView;
}
@property(nonatomic, retain) album * receivedView;
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;

@end
