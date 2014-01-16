//
//  MyAnnotation.h
//  WhereAreYou
//
//  Created by cha joong ki on 10. 7. 2..
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MyAnnotation : NSObject <MKAnnotation> {
	CLLocationCoordinate2D coordinate;
	NSString *subtitle;
	NSString *title;
}

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, retain) NSString *subtitle;
@property (nonatomic, retain) NSString *title;

- (id)initWithCoordinate:(CLLocationCoordinate2D) cor;

@end
