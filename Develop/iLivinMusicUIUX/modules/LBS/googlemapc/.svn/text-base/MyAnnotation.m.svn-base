//
//  MyAnnotation.m
//  WhereAreYou
//
//  Created by cha joong ki on 10. 7. 2..
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MyAnnotation.h"


@implementation MyAnnotation

@synthesize coordinate;
@synthesize subtitle;
@synthesize title;
- (id) initWithCoordinate: (CLLocationCoordinate2D) c
{
	coordinate = c;
	return self;
}

- (void)dealloc {
	[subtitle release];
	[title release];
    [super dealloc];
}

@end
