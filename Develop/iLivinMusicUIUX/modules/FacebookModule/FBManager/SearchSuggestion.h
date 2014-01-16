//
//  SearchSuggestion.h
//  Modules
//
//  Created by JHLee on 11. 6. 12..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchSuggestion : NSObject {
    NSString	* Text;
	NSString	* Description;
	NSString	* Url;
	NSString	* ImageSource;
	UIImage		* Image;
}

@property (nonatomic, retain) NSString * Text;
@property (nonatomic, retain) NSString * Description;
@property (nonatomic, retain) NSString * Url;
@property (nonatomic, retain) NSString * ImageSource;
@property (nonatomic, retain) UIImage * Image;

@end
