//
//  AudioHelper.h
//  MusicCancel
//
//  Created by jaehoon lee on 11/20/11.
//  Copyright 2011 Kaist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVAudioSession.h>
#import <AudioToolbox/AudioToolbox.h>
#import <MediaPlayer/MediaPlayer.h>

@protocol AudioHelperDelegate <NSObject>
- (void)iPodItemReceived:(NSDictionary *)iPoditem;
- (void)iPodItemsReceived:(NSArray *)iPoditems;
@end

@interface AudioHelper : NSObject <AVAudioPlayerDelegate>
{
    dispatch_queue_t enumerationQueue;
    id<AudioHelperDelegate> delegate;
    
}
@property(nonatomic, retain) id<AudioHelperDelegate> delegate;
+ (AudioHelper *)sharedObject;
- (void)play;
- (void)stop;
- (void)pause;

- (void)setRepeatMode:(MPMusicRepeatMode)repeatMode;
- (void)setShuffleMode:(MPMusicShuffleMode)shuffleMode;

- (BOOL)getPlayState;
- (void)volumeDownWithFloat:(CGFloat)down;

- (void)updateIPodLibrary;
@end
