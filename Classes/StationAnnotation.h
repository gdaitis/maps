//
//  StationAnnotation.h
//  maps
//
//  Created by Andriukas on 2010-06-14.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreData/CoreData.h>
@interface StationAnnotation : NSObject<MKAnnotation> {
	CLLocationCoordinate2D _coordinate; 
	NSString * _name;
	NSString * _road;
   
	NSManagedObject *station;
}

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate andStation:(NSManagedObject *)_station;
@property(nonatomic,retain) NSManagedObject * station;

@end