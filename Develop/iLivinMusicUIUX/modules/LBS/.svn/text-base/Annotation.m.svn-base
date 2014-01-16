//
//  Annotation.m
//  MnFramework
//
//  Created by  on 11. 6. 15..
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Annotation.h"

@implementation Annotation
@synthesize country;
@synthesize area;
@synthesize dAccuracy;
@synthesize dAltitude;
@synthesize dLongtitude;
@synthesize dLatitude;
@synthesize placeName;

- (CLLocationCoordinate2D) coordinate {
	CLLocationCoordinate2D captureCoord;
	captureCoord.latitude = dLatitude;
	captureCoord.longitude = dLongtitude;
	
	return captureCoord;
}

- (id)initWithLatitude:(double)latitude
			 longitude:(double)longitude
				 title:(NSString *)title
			  subtitle:(NSString *)subtitle
{
	dLatitude = latitude;
	dLongtitude = longitude;
	sTitle = title;
	sSubTitle = subtitle;
	
	return self;
}

- (NSString *)title{
	return sTitle;
}

- (NSString *)subtitle{
	return sSubTitle;
}

@end
