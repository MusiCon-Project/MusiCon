//
//  UserDefaultHelper.m
//  iLivinMusicUIUX
//
//  Created by jaehoon lee on 6/6/12.
//  Copyright (c) 2012 Kaist. All rights reserved.
//

#import "UserDefaultHelper.h"


@implementation UserDefaultHelper
NSString *root = @"iLuvMusicUserDefaults";
+ (NSMutableDictionary *)_defaultDictionary{
    NSMutableDictionary *dictionary;
    dictionary = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:root]];
    if (!dictionary) {
        dictionary = [NSMutableDictionary dictionary];
    }
    return dictionary;
}

#pragma mark Set Methods
+ (void)setObject:(id)object forKey:(NSString *)key{
    NSMutableDictionary *dictionary = [self _defaultDictionary];
    if (object == nil) {
        [dictionary removeObjectForKey:key];
    }
    else {
        [dictionary setObject:object forKey:key];
    }
    [[NSUserDefaults standardUserDefaults] setObject:dictionary forKey:root];
}

+ (void)setBool:(BOOL)value forKey:(NSString *)key
{
    NSMutableDictionary *dictionary = [self _defaultDictionary];
    [dictionary setObject:[NSNumber numberWithBool:value] forKey:key];
    [[NSUserDefaults standardUserDefaults] setObject:dictionary forKey:root];
}

+ (void)setInteger:(NSInteger)value forKey:(NSString *)key
{
    NSMutableDictionary *dictionary = [self _defaultDictionary];
    [dictionary setObject:[NSNumber numberWithInteger:value] forKey:key];
    [[NSUserDefaults standardUserDefaults] setObject:dictionary forKey:root];
}

+ (void)setLongLongInteger:(long long)value forKey:(NSString *)key
{
    NSMutableDictionary *dictionary = [self _defaultDictionary];
    [dictionary setObject:[NSNumber numberWithLongLong:value] forKey:key];
    [[NSUserDefaults standardUserDefaults] setObject:dictionary forKey:root];
}

#pragma mark - Get Methods
+ (id)objectForKey:(NSString *)key{
    NSMutableDictionary *dictionary = (NSMutableDictionary *)[self _defaultDictionary];
    return [dictionary objectForKey:key];
}

+ (BOOL)boolForKey:(NSString *)key{
    NSMutableDictionary *dictionary = (NSMutableDictionary *)[self _defaultDictionary];
    return [[dictionary objectForKey:key] boolValue];
}

+ (NSInteger)integerForKey:(NSString *)key{
    NSMutableDictionary *dictionary = (NSMutableDictionary *)[self _defaultDictionary];
    return [[dictionary objectForKey:key] integerValue];
}

+ (long long)longLongIntegerForKey:(NSString *)key{
    NSMutableDictionary *dictionary = (NSMutableDictionary *)[self _defaultDictionary];
    return [[dictionary objectForKey:key] longLongValue];
}

#pragma mark - NSUserDefault Record
+ (void)setCurrentRecordType:(recordType)rcdType
{
    [self setInteger:rcdType forKey:@"recordType"];
}

+ (NSInteger)getCurrentRecordType
{
    return [self integerForKey:@"recordType"];
}

+ (void)setTimerState:(BOOL)state
{
    [self setBool:state forKey:@"timerState"];
}

+ (BOOL)getTimerState
{
    return [self boolForKey:@"timerState"];
}

+ (void)setAlarmState:(BOOL)state
{
    [self setBool:state forKey:@"alarmState"];
}

+ (BOOL)getAlarmState
{
    return [self boolForKey:@"alarmState"];
}

+ (void)setAutoTimerState:(BOOL)state
{
    [self setBool:state forKey:@"autoTimerState"];
}

+ (BOOL)getAutoTimerState
{
    return [self boolForKey:@"autoTimerState"];
}

+ (void)setAutoAlarmState:(BOOL)state
{
    [self setBool:state forKey:@"autoAlarmState"];
}

+ (BOOL)getAutoAlarmState
{
    return [self boolForKey:@"autoAlarmState"];
}

#pragma mark - Purchase Status


#pragma mark - SocialNetworkAssociate Status
+ (BOOL)getFBAssociteState
{
    return [self boolForKey:@"FBAssociateState"];
}

+ (void)setFBAssociteState:(BOOL)state
{
    [self setBool:state forKey:@"FBAssociateState"];
}

+ (BOOL)getTWAssociteState
{
    return [self boolForKey:@"TWAssociateState"];
}

+ (void)setTWAssociteState:(BOOL)state
{
    [self setBool:state forKey:@"TWAssociateState"];
}

@end
