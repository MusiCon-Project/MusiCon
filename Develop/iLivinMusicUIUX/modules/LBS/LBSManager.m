//
//  LBSManager.m
//  Modules
//
//  Created by JHLee on 11. 6. 11..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LBSManager.h"
#import "SBJSON.h"
#import "NSString+SBJSON.h"


static LBSManager * lbsManager;
@implementation LBSManager
@synthesize locationManager;
@synthesize delegate = _delegate;

#pragma mark - LBSManager init & release
+ (LBSManager *)sharedObject
{
    @synchronized(self)
    {
        if (lbsManager == nil) {
            lbsManager = [[LBSManager alloc] init];
        }
    }
    
    return lbsManager;
}

- (id)init
{
    if((self = [super init]))
    {
		if (locationManager == nil) {
			locationManager = [[CLLocationManager alloc] init];
		}
    }
    return self;
}

- (void) dealloc
{
    [super dealloc];
}

- (void) destroySharedObject
{	
	[locationManager release];
	[lbsManager release];
	lbsManager = nil;
	locationManager = nil;
}

#pragma mark - set Information & google Maps API 
/**
 * find My Current Location
 * @param desiredAccuracy, distanceFilter
 * @author JHLee
 */
- (void)setCurrentLocationWithDesiredAccuracy:(CLLocationAccuracy)desiredAccuracy distanceFilter:(CLLocationDistance)distanceFilter
{
	locationManager.delegate = self;
	locationManager.desiredAccuracy = desiredAccuracy;
	locationManager.distanceFilter	 = distanceFilter;
	[locationManager startUpdatingLocation];		
}

/**
 * find coordinate Infomation from address String 
 * @param inAddress
 * @author JHLee
 */
- (void)searchCoordinatesForAddress:(NSString *)inAddress
{
	NSMutableString * urlString = [NSMutableString stringWithFormat:@"http://maps.google.co.kr/maps/geo?q=%@&output=json", inAddress];
	NSString *escapedUrl = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSURL * url = [NSURL URLWithString:escapedUrl];	
	
	NSURLRequest * request = [[NSURLRequest alloc] initWithURL:url];
	NSURLConnection * connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	
	[connection release];
	[request release];
}

/**
 * find address String from coordinate Information
 * @param inAddress
 * @author JHLee
 */
- (void)searchAddressFromCoordinate:(CLLocationCoordinate2D)resultCoord
{
	CLLocation *newLocation = [[CLLocation alloc] initWithLatitude:resultCoord.latitude longitude:resultCoord.longitude];

	if(reverseGeocoder != nil)
	[reverseGeocoder release];

	reverseGeocoder = [[MKReverseGeocoder alloc] initWithCoordinate:newLocation.coordinate];
	reverseGeocoder.delegate = self;
	[reverseGeocoder start];
	
	[newLocation release];
}

- (void)searchAddressFromCoordinateWithCLGeocoder:(CLLocationCoordinate2D)resultCoord 
{
    clGeocoder = [[CLGeocoder alloc] init];
    CLLocation * cl = [[CLLocation alloc]initWithLatitude:resultCoord.latitude longitude:resultCoord.longitude];
    [clGeocoder reverseGeocodeLocation:cl completionHandler:^(NSArray *placemarks, NSError *error)
     {
         CLPlacemark *placemark = [placemarks objectAtIndex:0];
         //we recieved the results
         NSLog(@"placemarkCount:%d", [placemarks count]);
         NSLog(@"Country = %@",placemark.country);
         NSLog(@"Postal Code = %@",placemark.postalCode);
         NSLog(@"Locality = %@",placemark.locality);
         NSLog(@"administrativeArea : %@",placemark.administrativeArea);
         NSLog(@"subAdministrativeArea : %@",placemark.subAdministrativeArea);
         NSLog(@"ISOcountryCode : %@",placemark.ISOcountryCode);
         NSLog(@"ocean : %@",placemark.ocean);
         NSLog(@"subLocality : %@",placemark.subLocality);
         NSLog(@"subThoroughfare : %@",placemark.subThoroughfare);
         NSLog(@"thoroughfare : %@",placemark.thoroughfare);
         NSLog(@"inlandWater : %@",placemark.inlandWater);
         
//         NSMutableDictionary *addrDic = [[NSMutableDictionary alloc] initWithDictionary:placemark.addressDictionary];
//         [addrDic removeObjectForKey:@"Country"];
//         [addrDic removeObjectForKey:@"CountryCode"];
//         [addrDic removeObjectForKey:@"ZIP"];
//         nowAddrStr = ABCreateStringWithAddressDictionary(addrDic, NO);
//         
//         Annotation *annot = [[Annotation alloc] initWithLatitude:coordinate.latitude//[[dic valueForKey:@"lat"]doubleValue]
//                                                        longitude:coordinate.longitude//[[dic valueForKey:@"lon"]doubleValue]
//                                                            title:[dic valueForKey:@"name"] 
//                                                         subtitle:nowAddrStr];//[dic valueForKey:@"nick_name"]];
//         
//         annot.sUserName = [dic valueForKey:@"name"]; //이름으로 누군지 구분해야쥥~~ 
//         [annotationArr addObject:annot];
//         [self.mapView addAnnotation:annot];
//         [annot release];
         
     }];
}

/**
 * get Location Information From GoogleMAPJSON Dictionary
 * @param GoogleMapDic
 * @return AnnotationArray
 * @author JHLee
 */
- (NSArray *)analyzeGoogleMapAPIJSONInfo:(NSArray *)placeMarkArray
{
	NSMutableArray * annotArray = [[NSMutableArray alloc] init];
	for (NSDictionary * placemarkElement in placeMarkArray)
	{
		NSArray * coordinates = [placemarkElement valueForKeyPath:@"Point.coordinates"];
		NSString * CurCountry = [placemarkElement valueForKeyPath:@"AddressDetails.Country.CountryName"];
		NSString * CurArea = [placemarkElement valueForKeyPath:@"AddressDetails.Country.Locality.DependentLocality.DependentLocalityName"];
        NSString * placeName = CurArea;
		if(CurArea == nil)
        {
			CurArea = [placemarkElement valueForKeyPath:@"AddressDetails.Country.Locality.DependentLocality.Thoroughfare.ThoroughfareName"];
            placeName = [[placemarkElement valueForKeyPath:@"AddressDetails.Country.Locality.DependentLocality.AddressLine"] objectAtIndex:0];   
        }
		if(CurArea == nil)
			CurArea = [placemarkElement valueForKeyPath:@"AddressDetails.Country.AdministrativeArea.Locality.Thoroughfare.DependentLocality.DependentLocalityName"];
        
        if(placeName == nil)
            placeName = [placemarkElement valueForKeyPath:@"AddressDetails.Country.AdministrativeArea.Locality.DependentLocality.DependentLocalityName"];

		
		NSString * CurCity = [placemarkElement valueForKeyPath:@"AddressDetails.Country.Locality.LocalityName"];
		NSString * address = [placemarkElement valueForKeyPath:@"address"];
		double longitudeInst = [[coordinates objectAtIndex:0] doubleValue];
		double latitudeInst = [[coordinates objectAtIndex:1] doubleValue];
		double altitudeInst = [[coordinates objectAtIndex:2] doubleValue];
		
		NSString *trimAddress;
		if (CurCountry && [address hasPrefix:CurCountry]) {
			trimAddress = [address substringFromIndex:[CurCountry length]];
		}
		else {
			trimAddress = address;
		}
		//get Infomation
		NSLog(@"CurCountry:%@ CurArea:%@ %@ Address:%@ longitudeInst:%f latitudeInst:%f placeName:%@", CurCountry, CurCity, CurArea, trimAddress, longitudeInst, latitudeInst, placeName);
		
		//set Annotation
		Annotation * currentAnno = [[Annotation alloc] initWithLatitude:latitudeInst longitude:longitudeInst title:[address copy] subtitle:[address copy]];
		
        currentAnno.placeName = placeName;
		currentAnno.dLatitude = latitudeInst;
		currentAnno.dLongtitude = longitudeInst;
		currentAnno.dAltitude = altitudeInst;
		currentAnno.dAccuracy = 0;
		currentAnno.country = CurCountry;
		currentAnno.area = [[NSString alloc] initWithFormat:@"%@ %@",CurCity,CurArea];
		
		[annotArray addObject:currentAnno];
	}
	
	return (NSArray *)[annotArray autorelease];
}

#pragma mark Map Associate Function
/**
 * zoom map proper size & put position on Center using annotation Array
 * @param annotArray
 * @author JHLee
 */
- (void)zoomMapAndCenterOnAnnotArray:(NSArray *)annotArray
{
	CLLocationCoordinate2D topLeftCoord;
	topLeftCoord.latitude = -90;
	topLeftCoord.longitude = 180;
	
	CLLocationCoordinate2D bottomRightCoord;
	bottomRightCoord.latitude = 90;
	bottomRightCoord.longitude = -180;

	BOOL annotExist = NO;
	for (Annotation * annot in annotArray) 
	{
		topLeftCoord.longitude = fmin(topLeftCoord.longitude, annot.dLongtitude);
		topLeftCoord.latitude = fmax(topLeftCoord.latitude, annot.dLatitude);
		
		bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annot.dLongtitude);
		bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annot.dLatitude);
		
		if([_delegate respondsToSelector:@selector(addAnnotation:)])
			[_delegate addAnnotation:annot];
		annotExist = YES;
	} 
	
	if(annotExist)
	{
		MKCoordinateRegion region;	
		
		region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
		region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
		region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.1; // Add a little extra space on the sides
		region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.1; // Add a little extra space on the sides
		
		if([_delegate respondsToSelector:@selector(setRegion:)])
			[_delegate setRegion:region];
	}
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
	MKCoordinateRegion region;
	MKCoordinateSpan span;
	span.latitudeDelta = 0.02;
	span.longitudeDelta = 0.02;
	CLLocationCoordinate2D resultCoord = [newLocation coordinate];	
	
	region.span = span;
	region.center = resultCoord;
	
	CustomPlacemark *currentPlaceMark = [[CustomPlacemark alloc] initWithRegion:region];
		
	if([_delegate respondsToSelector:@selector(locationFounded:region:)])
		[_delegate locationFounded:currentPlaceMark region:region];
	
	[locationManager stopUpdatingLocation];
	locationManager.delegate = nil;

//================================================//
//	//set Region
//	if(startPoint == nil)
//	{
////		self.startPoint = newLocation;
//	}
//	
//	MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 300, 300);
////	[myMapView setRegion:viewRegion animated:YES];
//	
//	
//	//======= To Get Country And Area Information =========
//	if(reverseGeocoder != nil)
//		[reverseGeocoder release];
//	reverseGeocoder = [[MKReverseGeocoder alloc] initWithCoordinate:newLocation.coordinate];
//	reverseGeocoder.delegate = self;
//	[reverseGeocoder start];
//	
////	longitude = newLocation.coordinate.longitude;
////	latitude = newLocation.coordinate.latitude;
////	altitude = newLocation.altitude;
////	accuracy = newLocation.horizontalAccuracy;
//
}

#pragma mark - reverseGeocoder
- (void) reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark
{
	NSLog(@"country:%@ thoroughfare:%@", placemark.country, placemark.thoroughfare);
//	country = [NSString stringWithString:placemark.country];
//	area = [NSString stringWithString:placemark.thoroughfare];
	[reverseGeocoder cancel];
}

- (void) reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error
{
//	country = @"";
//	area = @"";
	[reverseGeocoder cancel];
}

#pragma mark - NSURLConnectionDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	jsonString = [[NSMutableString alloc] init];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	[jsonString appendString:string];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	NSLog(@"jsonString:%@", jsonString);
	NSDictionary * results = [jsonString JSONValue];
	NSArray * placemark = [results objectForKey:@"Placemark"];
	if([placemark count]>0)
	{
		if([_delegate respondsToSelector:@selector(removeAnnotationsInMapView)])
			[_delegate removeAnnotationsInMapView];
	}
	
	NSArray * annotArray = [self analyzeGoogleMapAPIJSONInfo:placemark];
    NSMutableArray * placeArray = [[NSMutableArray alloc] init];
	for (Annotation * annot in annotArray) 
    {
        NSMutableDictionary * place = [NSMutableDictionary dictionary];
        NSMutableDictionary * location = [NSMutableDictionary dictionary];
        
        [place setObject:annot.placeName forKey:@"name"];
        [location setObject:[NSNumber numberWithDouble:annot.dLatitude] forKey:@"latitude"];
        [location setObject:[NSNumber numberWithDouble:annot.dLongtitude] forKey:@"longitude"];
        [place setObject:location forKey:@"location"];
        [placeArray addObject:place];
    }
    if([_delegate respondsToSelector:@selector(receivedSearchPlace:)]) [_delegate receivedSearchPlace:placeArray];    
//		if([_delegate respondsToSelector:@selector(addAnnotation:)]) [_delegate addAnnotation:annot];
//	[self zoomMapAndCenterOnAnnotArray:annotArray];

	[jsonString release];
    [placeArray release];
}

#pragma mark - Facebook Method
- (void)apiGraphSearchPlace:(CLLocationCoordinate2D)location 
{
//    [self showActivityIndicator];
//    currentAPICall = kAPIGraphSearchPlace;
//    if ([fbManager Logined]==NO) {
//        fbManager = [FBManager sharedObject];
//        [fbManager setDelegate:self];
//        //        NSLog(@"ACCESS:%@ EXPRIATIONDATE:%@",fbManager.facebook.accessToken, fbManager.facebook.expirationDate);
//        [fbManager login];
//    }else{
//        //        [fbManager logout];        
//    }
    FBManager * fbManager = [FBManager sharedObject];
    [fbManager setDelegate:self];
    [fbManager getGraphSearchPlaceNearBy:location];
}

#pragma mark - FBRequestDelegate Methods
- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response {
    //NSLog(@"received response");
}

- (void)request:(FBRequest *)request didLoad:(id)result {
        NSLog(@"Receveing ==");
        NSMutableArray *places = [[NSMutableArray alloc] initWithCapacity:1];
        NSArray *resultData = [result objectForKey:@"data"];
        for (NSUInteger i=0; i<[resultData count] && i < 5; i++) {
            [places addObject:[resultData objectAtIndex:i]];
            NSLog(@"Geo Infomation : %@", [resultData objectAtIndex:i]);
        }
        // Show the places nearby in a new view controller
//        APIResultsViewController *controller = [[APIResultsViewController alloc]
//                                                initWithTitle:@"Nearby"
//                                                data:places
//                                                action:@"places"];
//        [self.navigationController pushViewController:controller animated:YES];
//        [controller release];
//        [places release];
//        break;
}

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"Error message: %@", [[error userInfo] objectForKey:@"error_msg"]);
}

#pragma mark - FBManager Delegate
- (void)receivedSearchPlace:(NSArray *)place
{
    //category, id, location, name
    [_delegate receivedSearchPlace:place];
}
- (void)receivedFailed
{
    
}
@end
