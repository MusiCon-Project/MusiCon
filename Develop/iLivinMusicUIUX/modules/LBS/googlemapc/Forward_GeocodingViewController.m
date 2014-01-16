//
//  Created by Björn Sållarp on 2010-03-13.
//  NO Copyright 2010 MightyLittle Industries. NO rights reserved.
// 
//  Use this code any way you like. If you do like it, please
//  link to my blog and/or write a friendly comment. Thank you!
//
//  Read my blog @ http://blog.sallarp.com
//

#import "Forward_GeocodingViewController.h"
#import "MyAnnotation.h"
//#import "IBChatsWindowViewController.h"
//#import "UISearchBarAdditions.h"
//  #import "ChatWindowViewController.h"
@interface Forward_GeocodingViewController (internal)
-(void)addLongPressGestureInMapView;
-(void)longPressHandler:(UILongPressGestureRecognizer *)recognizer;
-(void)resignSearchBarFirstResponder;
-(void)_setupLocalizing;
@end


@implementation Forward_GeocodingViewController

@synthesize mapView, searchBar, forwardGeocoder;
@synthesize locate,co2,n1,n2;
@synthesize delegate;
extern IBChatsWindowViewController *CWVC;
-(void)viewWillDisappear:(BOOL)animated
{
	mapView.showsUserLocation=FALSE;
}

-(void)viewWillAppear:(BOOL)animated
{
	//[n1 setImage:[UIImage imageNamed:@"map_320.png"]];	
}

-(IBAction) sendMap
{
	NSLog(@"sendMap");
	//NSLog(@"latitude %f longitude %f",mapView.userLocation.coordinate.latitude,mapView.userLocation.coordinate.longitude);
	
	if(co2.latitude == 0)
	{	
			NSLog(@"언제까지 이러고 살텐가");
		
	co2.latitude=mapView.userLocation.coordinate.latitude;
	co2.longitude=mapView.userLocation.coordinate.longitude;
		
	}
	
	NSLog(@"co2 latitude %f longitude %f",co2.latitude,co2.longitude);

//	if(!(mapView.userLocation.coordinate.latitude== -180 && mapView.userLocation.coordinate.longitude== -180))
    [CWVC sendLocationButton:co2];
	[CWVC dismissModalViewControllerAnimated:YES];
}

- (IBAction)cancle {
    [CWVC dismissModalViewControllerAnimated:YES];
}

- (IBAction) onUserLocation
{
//	mapView.showsUserLocation=TRUE;
//	MKCoordinateRegion currentRegion;
//    currentRegion.center.latitude = 37.37;
//    currentRegion.center.longitude = -96.24;
//	NSLog(@"latitude = %f, longitude = %f",currentRegion.center.latitude,currentRegion.center.longitude);
//    currentRegion.span.latitudeDelta = 0.02;
//    currentRegion.span.longitudeDelta = 0.02;
//	
//	CustomPlacemark *currentPlaceMark = [[CustomPlacemark alloc] initWithRegion:currentRegion];
//	[mapView addAnnotation:currentPlaceMark];
	
	if (self.locate == nil) {
		self.locate = [[[CLLocationManager alloc] init] autorelease];
	}
	
	locate.delegate=self;
	locate.desiredAccuracy =kCLLocationAccuracyBest;
	locate.distanceFilter =kCLDistanceFilterNone;
	
//    [self.mapView setRegion:currentRegion animated:YES];
//	[mapView setShowsUserLocation:YES];
	[locate	startUpdatingLocation];
	
}

- (void)locationManager: (CLLocationManager *)manager didUpdateToLocation: (CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
	[self.locate stopUpdatingLocation];
	NSArray *annotationArrs = mapView.annotations;
    if(annotationArrs!=nil)
    {
        //NSLog(@"Remove all annotations!");
        [mapView removeAnnotations:annotationArrs];
    }
	
	//NSLog(@"title");
	
	
	// 확대 배율
	MKCoordinateRegion region;
	MKCoordinateSpan span;
	span.latitudeDelta = 0.02;
	span.longitudeDelta = 0.02;
	CLLocationCoordinate2D resultCoord = [newLocation coordinate];	
	
	region.span = span;
	region.center = resultCoord;
	
	CustomPlacemark *currentPlaceMark = [[CustomPlacemark alloc] initWithRegion:region];
	[mapView addAnnotation:currentPlaceMark];
	[currentPlaceMark release];
	
	//MyAnnotation *mark = [[MyAnnotation alloc] initWithCoordinate:resultCoord];
	//[mark setTitle:@"현재 위치"];
	//mark.subtitle = SearchPhone;
	//[mapView addAnnotation:mark];
	//[mark release];
	
	co2.latitude=resultCoord.latitude;
	co2.longitude=resultCoord.longitude;
	[mapView setRegion:region animated:TRUE];
	
	//NSLog(@"GG");
	/*
	
	NSMutableString *real=[[NSMutableString alloc] init];
	NSString *urlString = [NSString stringWithFormat:@"http://maps.google.com/maps/geo?q=%lf,%lf&sensor=false",newLocation.coordinate.latitude,newLocation.coordinate.longitude];
	NSURL *urlFromString = [NSURL URLWithString:urlString];
	NSStringEncoding encodingType = NSUTF8StringEncoding;
	NSString *reverseGeoString = [NSString stringWithContentsOfURL:urlFromString encoding:encodingType error:nil];
	
	
	if (reverseGeoString != nil)
	{		
		NSArray *listItems = [reverseGeoString
							  componentsSeparatedByString:@"id"];		
		
		if ([listItems count] >= 1)
		{			
			if([listItems objectAtIndex:1]!=nil)
			{
				//NSLog(@"pppppppppppppppppppp      %@",[listItems objectAtIndex:1]);
				
				NSArray *listItems2 = [[listItems objectAtIndex:1]
									   componentsSeparatedByString:@":"];
				
				if([listItems2 objectAtIndex:2]!=nil)
				{
					NSArray *listItems3 = [[listItems2 objectAtIndex:2]
										   componentsSeparatedByString:@"\""];
					//NSLog(@"pppppppppppppppppppp      %@",[listItems2 objectAtIndex:2]);
					//NSLog(@"pppppppppppppppppppp xxxxx     %@",[listItems3 objectAtIndex:1]);
					
					NSMutableString *mstr=[[NSMutableString alloc] init];
					
					[mstr insertString : @" " atIndex : [mstr length]];
					[mstr insertString : [listItems3 objectAtIndex:1] atIndex: [mstr length]];
					
					[real setString:mstr];	
				}
			}						
		}		
	}
	
	if(real!=nil){
		mapv.address.text =real;
	}
	time.text = @"My Location";
	 */
	
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];	
	self.navigationItem.leftBarButtonItem=nil;
	[self setNavBarButtonItem:UINavBarRightButtonItem title:NSLocalizedString(@"TALK_String_Cancel", @"취소") target:self action:@selector(cancle)];
	
	mapView.delegate=self;
	
	
//	searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 44.0)];
	searchBar.delegate = self;
//	[searchBar release];
	
	[self onUserLocation];
	
	[self addLongPressGestureInMapView];
	[self _setupLocalizing];
}
-(void)_setupLocalizing
{
	[self setTitle:NSLocalizedString(@"TALK_String_MapTitle", @"지도")];
	NSLocale *curLocale = [NSLocale currentLocale];
	if ([[curLocale objectForKey:NSLocaleLanguageCode] isEqualToString:@"ko"])
	{
		[n2 setImage:[UIImage imageNamed:@"btn_map_send_nor.png"] forState:UIControlStateNormal];
	}
    
    else 
    {
		[n2 setImage:[UIImage imageNamed:@"btn_map_send_nor_en.png"] forState:UIControlStateNormal];
    }
}

-(void)forwardGeocoderError:(NSString *)errorMessage
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" 
													message:errorMessage
												   delegate:nil 
										  cancelButtonTitle:@"OK" 
										  otherButtonTitles: nil];
	[alert show];
	[alert release];
	
}

-(void)forwardGeocoderFoundLocation
{
	if(forwardGeocoder.status == G_GEO_SUCCESS)
	{
		int searchResults = [forwardGeocoder.results count];
		
		// Add placemarks for each result
		
#if 0
		for(int i = 0; i < searchResults; i++)
		{
			
			if (i != 0) {
				break;
			}

			BSKmlResult *place = [forwardGeocoder.results objectAtIndex:i];
			
			NSArray *annotationArrs = mapView.annotations;
			
			if(annotationArrs!=nil)
			{
				//NSLog(@"Remove all annotations!");
				[mapView removeAnnotations:annotationArrs];
			}
			
			// Add a placemark on the map	
			CustomPlacemark *placemark = [[[CustomPlacemark alloc] initWithRegion:place.coordinateRegion] autorelease];

			placemark.title = place.address;
			placemark.subtitle = place.countryName;
			[mapView addAnnotation:placemark];	
			
			NSArray *countryName = [place findAddressComponent:@"country"];
			if([countryName count] > 0)
			{
				//NSLog(@"Country: %@", ((BSAddressComponent*)[countryName objectAtIndex:0]).longName );
			}

		}
#else
		//	기존에 검색된 장소의 annotation 정리
		
		NSArray *annotationArrs = mapView.annotations;
		if(annotationArrs!=nil)
		{
			//NSLog(@"Remove all annotations!");
			[mapView removeAnnotations:annotationArrs];
		}
		
		//	복수의 장소일 경우 한화면에 보이게 만들기 
		
		CLLocationCoordinate2D topLeftCoord;
		topLeftCoord.latitude = -90;
		topLeftCoord.longitude = 180;
		
		CLLocationCoordinate2D bottomRightCoord;
		bottomRightCoord.latitude = 90;
		bottomRightCoord.longitude = -180;
		
		for(int i = 0; i < searchResults; i++)
		{
		
			BSKmlResult *place = [forwardGeocoder.results objectAtIndex:i];
			
			// Add a placemark on the map	
			
			CustomPlacemark *placemark = [[[CustomPlacemark alloc] initWithRegion:place.coordinateRegion] autorelease];
			
			placemark.title = place.address;
			placemark.subtitle = place.countryName;
			[mapView addAnnotation:placemark];	
				
			NSArray *countryName = [place findAddressComponent:@"country"];
			if([countryName count] > 0)
			{
				//NSLog(@"Country: %@", ((BSAddressComponent*)[countryName objectAtIndex:0]).longName );
			}	
			
			topLeftCoord.longitude = fmin(topLeftCoord.longitude, place.coordinate.longitude);
			topLeftCoord.latitude = fmax(topLeftCoord.latitude, place.coordinate.latitude);
			
			bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, place.coordinate.longitude);
			bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, place.coordinate.latitude);


		}
#endif

		if([forwardGeocoder.results count] == 1)
		{
			BSKmlResult *place = [forwardGeocoder.results objectAtIndex:0];
			
			// Zoom into the location
			co2.latitude=place.latitude;
			co2.longitude=place.longitude;
		
			[mapView setRegion:place.coordinateRegion animated:TRUE];
			
		} else {
			
			MKCoordinateRegion region;
			region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
			region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
			region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.1; // Add a little extra space on the sides
			region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.1; // Add a little extra space on the sides
			
			region = [mapView regionThatFits:region];
			[mapView setRegion:region animated:YES];

		}
		 
		// Dismiss the keyboard
		searchBar.showsCancelButton=NO;
		[self resignSearchBarFirstResponder];
	}
	else {
		NSString *message = @"";
		
		switch (forwardGeocoder.status) {
			case G_GEO_BAD_KEY:
				message = @"The API key is invalid.";
				break;
				
			case G_GEO_UNKNOWN_ADDRESS:
				message = [NSString stringWithFormat:@"Could not find %@", forwardGeocoder.searchQuery];
				break;
				
			case G_GEO_TOO_MANY_QUERIES:
				message = @"Too many queries has been made for this API key.";
				break;
				
			case G_GEO_SERVER_ERROR:
				message = @"Server error, please try again.";
				break;
				
				
			default:
				break;
		}
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Information" 
														message:message
													   delegate:nil 
											  cancelButtonTitle:@"OK" 
											  otherButtonTitles: nil];
		[alert show];
		[alert release];
	}
}
- (void) searchBarTextDidBeginEditing:(UISearchBar *)aSearchBar {
//    self.searchDisplayController.searchResultsTableView.editing = self.tableView.editing;
	[self.searchDisplayController setActive:YES animated:YES];
	//    [[(UIViewController *)delegate navigationController] setNavigationBarHidden:YES animated:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
	searchBar.showsCancelButton=YES;
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)aSearchBar{
	searchBar.showsCancelButton=NO;
	[self resignSearchBarFirstResponder];
}
- (void) searchBarSearchButtonClicked:(UISearchBar *)theSearchBar {

	//NSLog(@"Searching for: %@", searchBar.text);
	if(forwardGeocoder == nil)
	{
		forwardGeocoder = [[BSForwardGeocoder alloc] initWithDelegate:self];
	}
	
	// Forward geocode!
	[forwardGeocoder findLocation:searchBar.text];
	
	[self resignSearchBarFirstResponder];
}
-(void) resignSearchBarFirstResponder
{
	[self.navigationController setNavigationBarHidden:NO animated:YES];
	searchBar.showsCancelButton=NO;
	[searchBar resignFirstResponder];
}
- (MKAnnotationView *) mapView:(MKMapView *)amapView viewForAnnotation:(id <MKAnnotation>) annotation{
	
	if([annotation isKindOfClass:[CustomPlacemark class]])
	{
		MKPinAnnotationView *aView;
		
		aView=(MKPinAnnotationView *) [amapView dequeueReusableAnnotationViewWithIdentifier:annotation.title];
		if (aView==nil) 
			aView=[[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotation.title] autorelease];
		else
			aView.annotation=annotation;
	
		aView.canShowCallout = YES;
		aView.enabled = YES;
		
		UIImage *flagImage = [UIImage imageNamed:@"icon_location.png"];
		aView.image = flagImage;
		aView.opaque = NO;
		
		return aView;
	}
	
	return nil;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
	NSLog(@"여기루");

	// We only want to zoom to location when the annotation is actaully selected. This will trigger also for when it's deselected
	
	if([((MKAnnotationView*) view).annotation isKindOfClass:[CustomPlacemark class]])
	{
		CustomPlacemark *place = ((MKAnnotationView*) view).annotation;
		
		// Zoom into the location		
		
		co2.latitude=place.coordinateRegion.center.latitude;
		co2.longitude=place.coordinateRegion.center.longitude;
		[self.mapView setRegion:place.coordinateRegion animated:TRUE];
	}
}

/*
 
//	메모리 문제로 폐기
 
- (void)observeValueForKeyPath:(NSString *)keyPath
					  ofObject:(id)object
						change:(NSDictionary *)change
					   context:(void *)context{
	
	NSString *action = (NSString*)context;
	
	// We only want to zoom to location when the annotation is actaully selected. This will trigger also for when it's deselected
	if([[change valueForKey:@"new"] intValue] == 1 && [action isEqualToString:@"GMAP_ANNOTATION_SELECTED"]) 
	{
		if([((MKAnnotationView*) object).annotation isKindOfClass:[CustomPlacemark class]])
		{
			CustomPlacemark *place = ((MKAnnotationView*) object).annotation;
			
			// Zoom into the location		
			//NSLog(@"NEW");
			
			co2.latitude=place.coordinateRegion.center.latitude;
			co2.longitude=place.coordinateRegion.center.longitude;
			[mapView setRegion:place.coordinateRegion animated:TRUE];
			//NSLog(@"annotation selected %f, %f", ((MKAnnotationView*) object).annotation.coordinate.latitude, ((MKAnnotationView*) object).annotation.coordinate.longitude);
		}
	}
}
*/



// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;

	
	
}


- (void)dealloc {
	
//	[self.locate stopUpdatingLocation];
//	NSArray *annotationArrs = mapView.annotations;
//    if(annotationArrs!=nil)
//    {
//        NSLog(@"Remove all annotations!(dealloc)");
//        [mapView removeAnnotations:annotationArrs];
//    }
	
//	[self removeObserver:self forKeyPath:@"selected"];

//	[[NSNotificationCenter defaultCenter] removeObserver:self name:nil object:nil];
//
//
//	for (id <MKAnnotation> annotation in mapView.annotations) {
//		[[mapView viewForAnnotation:annotation] removeObserver:self forKeyPath:@"selected"];
//	}	
	
	
    self.mapView=nil;
	self.searchBar=nil;
	
	self.n1=nil;
	self.n2=nil;
	self.locate=nil;
	
	if(forwardGeocoder != nil)
	{
		[forwardGeocoder release];
	}
	
	
	[super dealloc];
	
}

#pragma mark - mapView LongPress Recognize
-(void)addLongPressGestureInMapView
{
	NSLog(@"%s",__FUNCTION__);
	UILongPressGestureRecognizer *longPressRecognizer;
	
	longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressHandler:)];
	longPressRecognizer.delegate = self;
	longPressRecognizer.minimumPressDuration=1.0f;
	[self.mapView addGestureRecognizer:longPressRecognizer];
	[longPressRecognizer release];
}
- (void)longPressHandler:(UILongPressGestureRecognizer *)recognizer
{
	NSLog(@"%s %d",__FUNCTION__,recognizer.state);
	if(recognizer.state==UIGestureRecognizerStateBegan)
	{
		CGPoint point = [recognizer locationInView:recognizer.view];

		NSArray *annotationArrs = mapView.annotations;
		if(annotationArrs!=nil)
		{
			//NSLog(@"Remove all annotations!");
			[mapView removeAnnotations:annotationArrs];
		}
		
		MKCoordinateRegion region;
		MKCoordinateSpan span;
		span.latitudeDelta = 0.02;
		span.longitudeDelta = 0.02;
		CLLocationCoordinate2D resultCoord = [mapView convertPoint:point toCoordinateFromView:recognizer.view];
		
		region.span = span;
		region.center = resultCoord;
		
		CustomPlacemark *currentPlaceMark = [[CustomPlacemark alloc] initWithRegion:region];
		[mapView addAnnotation:currentPlaceMark];
		[currentPlaceMark release];
		
		co2.latitude=resultCoord.latitude;
		co2.longitude=resultCoord.longitude;
	}
}
@end
