//
//  XMLParser.h
//  VariousModule
//
//  Created by JHLee on 11. 6. 15..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

//import Object From XML
#import "Book.h"

@interface XMLParser : NSObject <NSXMLParserDelegate> {

    NSURL * url;
    NSXMLParser * nsxmlParser;
    
    NSMutableArray * mainArray;
    NSString * currentString;
    
    Book * abook;    
}
+ (XMLParser *)sharedObject;
- (id) initWithURLString:(NSString *)urlString;
- (void)setURL:(NSString *)urlString;
- (void) parse;
- (void) parseOnBackGroundThread;
@end
