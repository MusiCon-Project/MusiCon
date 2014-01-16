//
//  LBSManager.h
//  Modules
//
//  Created by JHLee on 11. 6. 11..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
//
//
//  This Class is used for Controllering LBS Cocoa APIs
//  author JHLee

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "CustomPlacemark.h"
#import "Annotation.h"
#import "FBManager.h"

@protocol LBSManagerDelegate <NSObject>
- (void)locationFounded:(CustomPlacemark *)placeMark region:(MKCoordinateRegion)region;
- (void)setRegion:(MKCoordinateRegion)region;
- (void)addAnnotation:(Annotation *)annotation;
- (void)removeAnnotationsInMapView;
- (void)receivedSearchPlace:(NSArray *)places;
@end

@interface LBSManager : NSObject <CLLocationManagerDelegate, MKReverseGeocoderDelegate, FBRequestDelegate, FBSessionDelegate, FBManagerDelegate>
{
	CLLocationManager * locationManager;
	CLLocation * startPoint;
	
	MKReverseGeocoder * reverseGeocoder;
    CLGeocoder * clGeocoder;
	id<LBSManagerDelegate> _delegate;
	
	NSMutableString * jsonString;
    Facebook * facebook;
}
@property(nonatomic, retain) CLLocationManager * locationManager;
@property(nonatomic, retain) id<LBSManagerDelegate> delegate;
+ (LBSManager *)sharedObject;
- (void)destroySharedObject;
- (void)setCurrentLocationWithDesiredAccuracy:(CLLocationAccuracy)desiredAccuracy distanceFilter:(CLLocationDistance)distanceFilter;
- (void)searchCoordinatesForAddress:(NSString *)inAddress;
- (void)searchAddressFromCoordinate:(CLLocationCoordinate2D)resultCoord;
- (void)searchAddressFromCoordinateWithCLGeocoder:(CLLocationCoordinate2D)resultCoord;
- (NSArray *)analyzeGoogleMapAPIJSONInfo:(NSArray *)placeMarkArray;
- (void)zoomMapAndCenterOnAnnotArray:(NSArray *)annotArray;
- (void)apiGraphSearchPlace:(CLLocationCoordinate2D)location;
@end
