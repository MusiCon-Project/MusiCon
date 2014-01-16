//
//  hourMinuteHand.h
//  iLivinMusicUIUX
//
//  Created by jaehoon lee on 4/1/12.
//  Copyright (c) 2012 Kaist. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum
{
    TimerHourType,
    AlarmHourType,
    AlarmMinuteType,
}hourMinuteType;

@protocol hourMinuteHandDelegate <NSObject>
- (void) minuteHandChanged:(double)changedAngle;
@end

@class record;
@interface hourMinuteHand : UIImageView
{
    CGPoint touch;
    CGPoint currentTouch;
    
    CGPoint origin;
    hourMinuteType curHourMinuteType;
    
    record * delegate;
}
@property(readwrite) hourMinuteType curHourMinuteType;
@property(nonatomic, retain) record * delegate;
@end
