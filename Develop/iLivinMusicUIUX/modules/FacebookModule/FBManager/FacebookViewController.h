//
//  FacebookViewController.h
//  VariousModule
//
//  Created by JHLee on 11. 6. 16..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBManager.h"
#import "Facebook.h"
#import "FBXMLParser.h"
#import "FBHTTPManager.h"
#import "SearchSuggestion.h"

@interface FacebookViewController : UIViewController <FBManagerDelegate, FBXMLParserDelegate, FBHTTPManagerDelegate, UIScrollViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate> {
    FBManager * fbManager;
@public
    IBOutlet UILabel * text;
    IBOutlet UILabel * interestText;
    IBOutlet UILabel * friends; 
    
    
    IBOutlet UIButton * facebookLogin;
    IBOutlet UIButton * callGraphAPI;
    IBOutlet UIButton * callRestAPI;
    IBOutlet UIButton * TextUpLoad;
    IBOutlet UIButton * PicUpload;
    IBOutlet UIButton * PicDownload;
    IBOutlet UIButton * getProfileImage;
	IBOutlet UIButton * getSearchSuggestions;
    
    BOOL IsLogin;
    
    int clickedButtonType;
    
	UITextView * textView;
	UIView * view;
	
@private
    NSString * interestProfile;
    NSString * friendlist;
    UIScrollView * searchSuggestScrollView;
	NSArray * suggestList;
	UITextField	* searchList;
	
	FBHTTPManager	* httpManager;
	NSInteger		  interestIndex;
}

@end
