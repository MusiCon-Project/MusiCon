//
//  PlayPickerImageView.h
//  iLivinMusicUIUX
//
//  Created by jaehoon lee on 3/28/12.
//  Copyright (c) 2012 Kaist. All rights reserved.
//

#import <UIKit/UIKit.h>

@class record;
@interface PlayPickerImageView : UIImageView
{
    record * _record;
    
    CGPoint origin;
    CGPoint currentTouch;
    
    double radius;
    UIImageView * playPicker;
    double preRadian;
    double touchUpAngle;
    
    double totalPlaytime;
}
@property(nonatomic, retain) record * record;
@property(readwrite) double totalPlaytime;
@property(readwrite) CGPoint origin;
@end
