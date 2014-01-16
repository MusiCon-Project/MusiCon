//
//  FBXMLParser.m
//  Modules
//
//  Created by JHLee on 11. 6. 12..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FBXMLParser.h"

static FBXMLParser * xmlParser;
#define PARSEURL @"http://www.facebook.com/search/opensearch_typeahead.php?format=xml&q="
@implementation FBXMLParser
@synthesize delegate;

+ (FBXMLParser *)sharedObject
{
    if (xmlParser == nil) {
        xmlParser = [[FBXMLParser alloc] initWithURLString:PARSEURL];
    }
    return xmlParser;
}

- (void)destroySharedObject
{
    if(xmlParser)
        [xmlParser release];
}

- (void)setSearchKeyword:(NSString *)keywordInst
{
	NSString * keyword = [NSString stringWithFormat:@"{%@}", keywordInst];
	NSString * encoded = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)keyword, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);
	
	NSString * searchURL = [NSString stringWithFormat:@"%@%@", PARSEURL, encoded];
	[self setURL:searchURL];
}

- (void) parseOnBackGroundThread:(NSString *)keywordInst
{
	[NSThread detachNewThreadSelector:@selector(parseInBackGround:) toTarget:self withObject:keywordInst];
//	NSInvocationOperation * op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(parseInBackGround:) object:keywordInst];
//	
//	NSOperationQueue * queue = [[NSOperationQueue alloc] init];
//	[queue setMaxConcurrentOperationCount:1];
//	[queue addOperation:op];
//	[op release];
}

- (void) parseInBackGround:(NSString*)keywordInst
{
	NSAutoreleasePool * autoreleasepool = [[NSAutoreleasePool alloc] init];
	[self setSearchKeyword:keywordInst];
	[nsxmlParser parse];
	[autoreleasepool release];
	[NSThread exit];
}

//Sent by a parser object to its delegate when it encounters a start tag for a given element. <title>
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
//	NSLog(@"%@", elementName);
    if([elementName isEqualToString:@"Section"])
    {
        mainArray = [[[NSMutableArray alloc] init] autorelease];
    }else if([elementName isEqualToString:@"Item"])
    {
        item = [[SearchSuggestion alloc] init];
    }else if([elementName isEqualToString:@"Image"])
	{
		item.ImageSource = [attributeDict objectForKey:@"source"]; 
		NSLog(@"%@",item.ImageSource);
	}
}

//Sent by a parser object to provide its delegate with a string representing all or part of the characters of the current element.
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
//	NSLog(@"CURRENTSTRING:%@", currentString);
	currentString = [NSString stringWithString:string];
}

//Sent by a parser object to its delegate when it encounters an end tag for a specific element. </title>
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if([elementName isEqualToString:@"Section"])
    {
//        NSLog(@"%@", mainArray);
		[delegate giveSuggestList:[mainArray copy]];
        return;   
    }
    
    if ([elementName isEqualToString:@"Item"]) {
        [mainArray addObject:item];
        [item release];
	}
	else if([elementName isEqualToString:@"Image"] || [elementName isEqualToString:@"SearchSuggestion"] || [elementName isEqualToString:@"Query"]){
		
	}
	else{
		
        [item setValue:currentString forKey:elementName];
//		NSLog(@"%@", elementName);
    }
	
}

@end
