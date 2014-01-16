//
//  AudioHelper.m
//  MusicCancel
//
//  Created by jaehoon lee on 11/20/11.
//  Copyright 2011 Kaist. All rights reserved.
//

#import "AudioHelper.h"

@implementation AudioHelper
@synthesize delegate;
static AudioHelper * audioHelper;
+ (AudioHelper *)sharedObject
{
    @synchronized(self)
    {
        if (audioHelper == nil) {
            audioHelper = [[AudioHelper alloc] init];
        }
    }
    return audioHelper;
}

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        enumerationQueue = dispatch_queue_create("Browser Enumeration Queue", DISPATCH_QUEUE_SERIAL);
		dispatch_set_target_queue(enumerationQueue, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0));
        
    }
    return self;
}

- (void) dealloc
{
    [super dealloc];
}

- (void) destroySharedObject
{
	[audioHelper release];
}

- (void)play
{
//   AVAudioPlayer * fireMusic = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"fire" ofType:@"wav"]] error:NULL];

}

- (void)stop
{
    NSError *setCategoryError = nil; 

//=============== Method to Stop Music from other App ================//
//    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryRecord error:&setCategoryError];
//    if (setCategoryError) NSLog(@"error AVAudioSession setCategory");
//    [[AVAudioSession sharedInstance] setActive:YES error:&activationError];
//    if (activationError) NSLog(@"error AVAudioSession setActive");
    
    MPMusicPlayerController * musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
    [musicPlayer play];
}

- (void)pause
{
    MPMusicPlayerController * musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
    [musicPlayer pause];
}

- (void)setRepeatMode:(MPMusicRepeatMode)repeatMode
{
    MPMusicPlayerController * musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
    [musicPlayer setRepeatMode:repeatMode];
}

- (void)setShuffleMode:(MPMusicShuffleMode)shuffleMode
{
    MPMusicPlayerController * musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
    [musicPlayer setShuffleMode:shuffleMode];
}

- (BOOL)getPlayState
{
    MPMusicPlayerController * musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
    return (musicPlayer.playbackState == MPMoviePlaybackStatePlaying);
}

- (void)volumeDownWithFloat:(CGFloat)down
{
    MPMusicPlayerController * musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
    musicPlayer.volume = musicPlayer.volume - down; // device volume will be changed to maximum value
        
    MPVolumeView * mpview = [[MPVolumeView alloc] initWithFrame:CGRectMake(30, 30, 100, 100)];
    mpview.hidden = YES;
}

#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    
}

#pragma mark - IPod Library
- (void)updateIPodLibrary
{
    static BOOL nextGet = NO;
	dispatch_async(enumerationQueue, ^(void) {
		// Grab videos from the iPod Library
		MPMediaQuery *videoQuery = [[MPMediaQuery alloc] init];
		
		NSMutableArray *items = [NSMutableArray arrayWithCapacity:0];
		NSArray *mediaItems = [videoQuery items];
        int index = 0;
//		for (MPMediaItem *mediaItem in mediaItems) {
//        for (int i = 0; i < max; i ++){
//            MPMediaItem *mediaItem = [mediaItems objectAtIndex:i];
//			NSURL *URL = (NSURL*)[mediaItem valueForProperty:MPMediaItemPropertyAssetURL];
//			
//			if (URL) {
//				NSString *title = (NSString*)[mediaItem valueForProperty:MPMediaItemPropertyTitle];
//                AVURLAsset * asset = [[AVURLAsset alloc] initWithURL:URL options:nil];
//                AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
//                
//                NSError *error = nil;
//                CMTime actualTime;
//                CGImageRef halfWayImage = [imageGenerator copyCGImageAtTime:kCMTimeZero actualTime:&actualTime error:&error];
//                UIImage * image = [UIImage imageWithCGImage:halfWayImage];
//
//
//                MPMediaItemArtwork *artwork = [mediaItem valueForProperty: MPMediaItemPropertyArtwork];
//                if (artwork) {
//                    image = [artwork imageWithSize: CGSizeMake (80, 80)];
//
//                }
//                
//                if(index == 1)
//                {
//                    if ([delegate respondsToSelector:@selector(iPodItemReceived:)]) 
//                    {
//                        NSMutableDictionary * itemDic = [NSMutableDictionary dictionary];                
//                        if(image != nil)
//                            [itemDic setObject:image forKey:@"image"];
//                        [itemDic setObject:title forKey:@"title"];
//                        
//                        [(UIViewController *)delegate performSelectorOnMainThread:@selector(iPodItemReceived:) withObject:itemDic waitUntilDone:NO];
////                        [delegate iPodItemReceived:itemDic];
//                    }
//                }
//
////				AssetBrowserItem *item = [[AssetBrowserItem alloc] initWithURL:URL title:title];
////				[items addObject:item];
////				[item release];
//                NSLog(@"%d : %@", index, title);
//			}
//            index++;
//		}
        
        if ([delegate respondsToSelector:@selector(iPodItemReceived:)]) 
        {
            [(UIViewController *)delegate performSelectorOnMainThread:@selector(iPodItemsReceived:) withObject:mediaItems waitUntilDone:NO];
        }
        
        [videoQuery release];       
		
		dispatch_async(dispatch_get_main_queue(), ^(void) {
//			[self updateBrowserItemsAndSignalDelegate:items];
		});
	});
    
    
}

- (void)updateBrowserItemsAndSignalDelegate:(NSArray*)newItems
{	
//	self.items = newItems;
    
	/* Ideally we would reuse the AssetBrowserItems which remain unchanged between updates.
	 This could be done by maintaining a dictionary of assetURLs -> AssetBrowserItems.
	 This would also allow us to more easily tell our delegate which indices were added/removed
	 so that it could animate the table view updates. */
	
//	if (self.delegate && [self.delegate respondsToSelector:@selector(assetBrowserSourceItemsDidChange:)]) {
//		[self.delegate assetBrowserSourceItemsDidChange:self];
//	}
}

@end
