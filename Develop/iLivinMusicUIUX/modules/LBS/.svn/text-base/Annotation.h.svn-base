//
//  Annotation.h
//  MnFramework
//
//  Created by  on 11. 6. 15..
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
@interface Annotation : NSObject <MKAnnotation> 
{
	double dLatitude;
	double dLongtitude;
	double dAltitude;
	double dAccuracy;
	NSString * country;
	NSString * area;
	
	NSString * sTitle;
	NSString * sSubTitle;
    NSString * placeName;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSString * area;
@property (readwrite) double dAccuracy;
@property (readwrite) double dAltitude;
@property (readwrite) double dLongtitude;
@property (readwrite) double dLatitude;
@property (nonatomic, retain) NSString * placeName;

- (id)initWithLatitude:(double)latitude
			 longitude:(double)longitude
				 title:(NSString *)title
			  subtitle:(NSString *)subtitle;
- (NSString *)title;
- (NSString *)subtitle;
@end