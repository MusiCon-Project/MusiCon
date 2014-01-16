//
//  FBManager.h
//  VariousModule
//
//  Created by JHLee on 11. 6. 16..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/**
 @file      FBManager.h
 */

#import <Foundation/Foundation.h>
#import "Facebook.h"
#import	"FBHTTPManager.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

#define MnTalk2_AppID @"238091526308588"

typedef enum
{
	profileWholeDataType,
	
	profileType,
	interestType,
	friendListType,
	profileImageType,
    searchPlaceNearByType,
	
	FacebookTextUpload,
	FacebookImageUpload,
	FacebookPosUpload,
	
	interestImageType,
}requestInfoType;

/**
 @brief     FBManager가 로그인/로그아웃 호출을 하거나, 개인정보 요청을 했을 경우 불려지는 delegate.
 @author	이재훈
 */

@protocol FBManagerDelegate <NSObject>
@optional
/**
 * @brief	로그인 하면 호출된다. 
 */
- (void)fbDidLogin;
/**
 * @brief	다이어로그 끄면 호출된다.
 */
- (void)fbDidNotLogin:(BOOL)cancelled;
/**
 * @brief	로그아웃 하면 호출된다. 
 */
- (void)fbDidLogout;

/**
* @brief	개인 관련 모든 데이터를 가져온다. [fbManager getWholeData]를 호출하면 불려진다. 
* @param	wholeDatas 	0 : Profile (NSDictionary)
						1~6 : Interest(1:Interest 2:Book 3:Film 4:Music 5:TVProgram 6:Game) (NSArray)
						7 : FriendList (NSArray)
						8 : ProfileImage가 있다. (UIImageView) 
*/
- (void)receivedWholeData:(NSArray *)wholeDatas;

/**
 * @brief	개인 정보를 가져온다. [fbManager getProfile]를 호출하면 불려진다. 
 * @param	profileDatas 개인정보를 담고 있는 NSDictionary. 
 */

- (void)receivedProfileData:(NSDictionary *)profileDatas;

/**
 * @brief	관심사를 가져온다. [fbManager getInterest]를 호출하면 불려진다. 
 * @param	interestDatas  개인관심사 카테고리를 담고 있는 NSArray(0:Interest 1:Book 2:Film 3:Music 4:TVProgram 5:Game) 
						   각 카테고리들도 NSArray로 카테고리에 해당하는 원소(NSDictionary)를 담고 있다. 
 */
- (void)receivedInterestData:(NSArray *)interestDatas;

/**
 * @brief	개인과 관련된 페이스북 친구 리스트를 가져온다. [fbManager getFriendList]를 호출하면 불려진다.
 * @param	interestDatas  친구 리스트를 담고 있는 NSArray. 원소들은 NSDictionary다. 
 */
- (void)receivedFriendListData:(NSArray *)friendListDatas;

/**
 * @brief	개인의 프로필 이미지를 가져온다. [fbManager getProfileImage]를 호출하면 불려진다.
 * @param	image	개인 프로필 이미지
 */
- (void)receivedProfileImage:(UIImageView *)image;

- (void)receivedInterestImages:(NSArray *)interestImages;

- (void)receivedInterestImageURL:(NSArray *)interestURLs;

- (void)receivedSearchPlace:(NSArray *)place;

- (void)receivedFailed;

- (void)uploadFBFinished;
@end

/**
 @class		FBManager
 @brief     Facebook API(FBConnect)를 편리하게 사용할 수 있도록 도와주는 Class
 @author	이재훈
*/


@interface FBManager : NSObject<FBDialogDelegate, FBRequestDelegate, FBSessionDelegate, FBHTTPManagerDelegate> 
{    
    Facebook * facebook;
    NSArray * permissions; //"email", "read_stream", "user_photos", "publish_stream"s 
    NSMutableArray * profileDatas;
	NSMutableArray * imageDatas; //used For Interest Images
	NSMutableArray * imageURLs;
    id<FBManagerDelegate> _delegate;
	FBHTTPManager * httpManager;
	
	NSInteger getMessageType;
	requestInfoType getInfoType;
	BOOL logined;
	NSInteger imageNum;
}

+ (FBManager *)sharedObject;
- (void)login;
- (void)logout;
- (BOOL)Logined;

- (void)TextUpload;
- (void)TextUpload:(NSString *)text;
- (void)PicUploadWithImage:(UIImage *)image withText:(NSString *)text;
- (void)PicUploadWithImage:(UIImage *)image withText:(NSString *)text place:(NSString *)place;
- (void)PosUpload:(NSString *)place message:(NSString *)message tags:(NSArray *)tags;

- (void)getWholeData;
- (void)getProfile;
- (void)getInterest;
- (void)getFriendList;
- (void)getProfileImage;
- (void)getSearchSuggestion;
- (void)getGraphSearchPlaceNearBy:(CLLocationCoordinate2D)location;

@property(nonatomic, retain) id<FBManagerDelegate> delegate;
@property(nonatomic, retain) Facebook * facebook;
@property(nonatomic, retain) NSMutableArray * profileDatas;
@end
