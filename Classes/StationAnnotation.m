//
//  StationAnnotation.m
//  maps
//
//  Created by Andriukas on 2010-06-14.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "StationAnnotation.h"


@implementation StationAnnotation

@synthesize coordinate=_coordinate;
//@synthesize name = _name;
@synthesize station;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate andStation:(NSManagedObject*)_station{
	self = [super init];
	if (self != nil) {
		CLLocationCoordinate2D location;
		if([(NSNumber *) [_station valueForKey:@"latitude"] floatValue] >0.1f){
			//NSLog([(NSNumber *)[_station valueForKey:@"latitude"] stringValue]);
			location.latitude = [(NSNumber *) [_station valueForKey:@"latitude"] floatValue];
		}		
		if([(NSNumber *) [_station valueForKey:@"longtitude"] floatValue] >0.1f){
			//NSLog(@"turi coord");
			location.longitude = [(NSNumber *) [_station valueForKey:@"longtitude"] floatValue];
		}
		_coordinate = location;
		self.station = _station;
		//NSLog([_station valueForKey:@"name"]);
	}
	return self;
}

- (NSString *) title {
	return [station valueForKey:@"name"];
}

- (NSString *)subtitle {
//	return [NSString stringWithFormat:@"%.4f, %.4f", _coordinate.latitude, _coordinate.longitude];
//	return [[station valueForKey:@"distance"] stringByAppendingString:@"km"];
	return @"";
}


@end