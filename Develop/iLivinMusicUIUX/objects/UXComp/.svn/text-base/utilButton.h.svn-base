//
//  utilButton.h
//  iLivinMusicUIUX
//
//  Created by jaehoon lee on 3/25/12.
//  Copyright (c) 2012 Kaist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "hourMinuteHand.h"
#import "record.h"
typedef enum 
{
    LeftButton,
    RightButton,
}buttonPos;

@interface utilButton : UIButton <UIAlertViewDelegate>
{
    CGPoint touch;
    CGPoint currentTouch;
    CGPoint initialTouch;
    
    buttonPos _buttonPos;
    recordType _buttonType;
    BOOL activated;
    
    BOOL buttonEventReceived;
    
    hourMinuteHand * _hourMinuteHand;
    record * _record;
    
    UIImageView * AutoImage;
}
@property(nonatomic, retain) record * Record;
@property(readwrite) recordType _buttonType;
@property(readwrite) BOOL activated;
- (void)setButtonImageWithType:(recordType)preRecordType;
- (void)setAutoImage;
- (id)initWithFrame:(CGRect)frame withButtonType:(recordType)btnType buttonPos:(buttonPos)bPos;
@end
