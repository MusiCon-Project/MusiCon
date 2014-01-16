//
//  recordLine.h
//  iLivinMusicUIUX
//
//  Created by jaehoon lee on 2/28/12.
//  Copyright (c) 2012 Kaist. All rights reserved.
//

#import <UIKit/UIKit.h>
#define recordLineWidth 70
#define recordLineHeight 175
@protocol recordLineDelegate <NSObject>
- (void)playMusicFinished;
- (void)playMusic;
- (void)stopMusic;
@end

@interface recordLine : UIView
{
    CGPoint touch;
    CGPoint currentTouch;
    
    CGRect initialFrame;
    CGAffineTransform transform;
    
    id<recordLineDelegate> delegate;
}
@property(nonatomic, retain) id<recordLineDelegate> delegate;
@end
