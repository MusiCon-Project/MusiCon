//
//  LocalPushHelper.m
//  iLivinMusicUIUX
//
//  Created by jaehoon lee on 4/4/12.
//  Copyright (c) 2012 Kaist. All rights reserved.
//

#import "LocalPushHelper.h"
@implementation LocalPushHelper
static UILocalNotification *localNotif;
+ (void)registerLocalPush:(NSDate *)today songURL:(NSString *)songURL
{    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy"];
    NSString *year = [df stringFromDate:[NSDate date]];
    [df setDateFormat:@"MM"];
    NSString *month = [df stringFromDate:[NSDate date]];
    [df setDateFormat:@"dd"];
    NSString *day = [df stringFromDate:[NSDate date]];

    
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
	NSDateComponents *dateComps = [[NSDateComponents alloc] init];
	[dateComps setYear:[year intValue]];
	[dateComps setMonth:[month intValue]];
	[dateComps setDay:[day intValue]];
	[dateComps setHour:16];
	[dateComps setMinute:49];
	[dateComps setSecond:0];
	NSDate *date = [calendar dateFromComponents:dateComps];
	[dateComps release];
    
    localNotif = [[UILocalNotification alloc]init];
	if (localNotif != nil) 
	{
		//통지시간 
		localNotif.fireDate = date;
		localNotif.timeZone = [NSTimeZone defaultTimeZone];
        
		//Payload
		localNotif.alertBody = [NSString stringWithFormat:@"내부통지 %@",date];
		localNotif.alertAction = @"상세보기";
//		localNotif.soundName = UILocalNotificationDefaultSoundName;
        localNotif.soundName = songURL;
		localNotif.applicationIconBadgeNumber = 1;
		
		//Custom Data
		NSDictionary *infoDict = [NSDictionary dictionaryWithObject:@"mypage" forKey:@"page"];
		localNotif.userInfo = infoDict;
		
		//Local Notification 등록
		[[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
		
	}
	[localNotif release];
}

+ (void)removeLocalPush
{
    [[UIApplication sharedApplication] cancelLocalNotification:localNotif];
}
@end
