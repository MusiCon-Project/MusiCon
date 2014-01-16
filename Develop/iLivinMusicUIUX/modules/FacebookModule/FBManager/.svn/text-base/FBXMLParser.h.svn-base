//
//  FBXMLParser.h
//  Modules
//
//  Created by JHLee on 11. 6. 12..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMLParser.h"
#import "SearchSuggestion.h"
@protocol FBXMLParserDelegate <NSObject>
- (void)giveSuggestList:(NSArray *)suggestList;
@end

@interface FBXMLParser : XMLParser {
	SearchSuggestion	*item;
	id<FBXMLParserDelegate>		delegate;
}
+ (FBXMLParser *)sharedObject;
- (void)destroySharedObject;
- (void)parseOnBackGroundThread:(NSString *)keywordInst;

@property(nonatomic, retain) id<FBXMLParserDelegate> delegate;
@end
