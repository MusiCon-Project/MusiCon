//
//  Created by Björn Sållarp on 2010-03-13.
//  NO Copyright 2010 MightyLittle Industries. NO rights reserved.
// 
//  Use this code any way you like. If you do like it, please
//  link to my blog and/or write a friendly comment. Thank you!
//
//  Read my blog @ http://blog.sallarp.com
//


#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "BSForwardGeocoder.h"
#import "BSKmlResult.h"
#import "CustomPlacemark.h"
//#import	"IBViewController.h"
@protocol Forward_GeocodingViewControllerDelegate;

@interface Forward_GeocodingViewController : UIViewController <MKMapViewDelegate, UISearchBarDelegate, BSForwardGeocoderDelegate, CLLocationManagerDelegate,UIGestureRecognizerDelegate > {
    id <Forward_GeocodingViewControllerDelegate> delegate;
	IBOutlet MKMapView *mapView;
	IBOutlet UISearchBar *searchBar;
	BSForwardGeocoder *forwardGeocoder;
	CLLocationManager *locate;
	CLLocationCoordinate2D co2;
	IBOutlet UIButton *n1;
	IBOutlet UIButton *n2;
    
}
@property (assign, nonatomic) id <Forward_GeocodingViewControllerDelegate> delegate;
@property (nonatomic, retain) BSForwardGeocoder *forwardGeocoder;
@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;
@property (nonatomic,retain) CLLocationManager *locate;
@property (nonatomic, retain) IBOutlet UIButton *n1;
@property (nonatomic, retain) IBOutlet UIButton *n2;
@property (nonatomic) CLLocationCoordinate2D co2;
- (IBAction)sendMap;
- (IBAction)onUserLocation;
- (IBAction)cancle;
@end


