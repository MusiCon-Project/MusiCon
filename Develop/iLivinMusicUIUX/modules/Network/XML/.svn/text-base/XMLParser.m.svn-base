//
//  XMLParser.m
//  VariousModule
//
//  Created by JHLee on 11. 6. 15..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "XMLParser.h"

#define PARSEURL @"http://sites.google.com/site/iphonesdktutorials/xml/Books.xml"
static XMLParser * xmlParser;

@implementation XMLParser
+ (XMLParser *)sharedObject
{
    if (xmlParser == nil) {
        xmlParser = [[XMLParser alloc] initWithURLString:PARSEURL];
    }
    return xmlParser;
}

- (id) initWithURLString:(NSString *)urlString
{
    if((self = [super init]))
    {
        url = [[NSURL alloc] initWithString:urlString];
        nsxmlParser = [[NSXMLParser alloc] initWithContentsOfURL:url];
        [nsxmlParser setDelegate:self];
    }
    
    return self;
}

- (void)setURL:(NSString *)urlString
{
	if(url)
	{
		[url release];
	}
	url = [[NSURL alloc] initWithString:urlString];
	
//	if(nsxmlParser)
//	{
//		[nsxmlParser release];
//	}
	
//	nsxmlParser = [[NSXMLParser alloc] initWithContentsOfURL:url];
	[nsxmlParser initWithContentsOfURL:url];
	
	[nsxmlParser setDelegate:self];
}

- (void)destroySharedObject
{
    if(xmlParser)
        [xmlParser release];
}

- (void)dealloc
{
    [url release];
    [nsxmlParser release];
	if(mainArray)
		[mainArray release];
    [super dealloc];  
}

//Parsing on MainThread
- (void) parse
{	
    [nsxmlParser parse];
}

- (void) parseOnBackGroundThread
{
//	[nsxmlParser parse];
	[NSThread detachNewThreadSelector:@selector(parseInBackGround:) toTarget:self withObject:nil];
//	NSThread * parseThread = [[NSThread alloc] initWithTarget:self selector:@selector(parseInBackGround:) object:nil];
		
//	[self performSelectorInBackground:@selector(parseInBackGround:) withObject:nil];
	
//	NSInvocationOperation * op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(parseInBackGround:) object:nil];
//	
//	NSOperationQueue * queue = [[NSOperationQueue alloc] init];
//	[queue setMaxConcurrentOperationCount:1];
//	[queue addOperation:op];
//	[op release];
}

- (void) parseInBackGround:(id)anObject
{
	NSAutoreleasePool * autoreleasepool = [[NSAutoreleasePool alloc] init];
	[nsxmlParser parse];
	[autoreleasepool release];
	[NSThread exit];
}

#pragma mark -
#pragma mark xmlParserDelegateMethod

//Sent by a parser object to its delegate when it encounters a start tag for a given element. <title>
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
	
	NSLog(@"%@", elementName);
	
    if([elementName isEqualToString:@"Books"])
    {
        if(mainArray)
            [mainArray release];
        
        mainArray = [[NSMutableArray alloc] init];
    }else if([elementName isEqualToString:@"Book"])
    {
        abook = [[Book alloc] init];
        abook.ID = [[attributeDict objectForKey:@"id"] floatValue];
    }
}

//Sent by a parser object to provide its delegate with a string representing all or part of the characters of the current element.
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    currentString = [NSString stringWithString:string];
}

//Sent by a parser object to its delegate when it encounters an end tag for a specific element. </title>
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if([elementName isEqualToString:@"Books"])
    {
        NSLog(@"%@", mainArray);
        return;   
    }
    
    if ([elementName isEqualToString:@"Book"]) {
        [mainArray addObject:abook];
        [abook release];
    }else{
        [abook setValue:currentString forKey:elementName];
    }
       
}

@end
