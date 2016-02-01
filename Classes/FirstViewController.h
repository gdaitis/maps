//
//  FirstViewController.h
//  Maps
//
//  Created by Andriukas on 2010-06-01.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <MapKit/MapKit.h>
#import "MapsAppDelegate.h"
#import "StationParser.h"
#import "ItemParser.h"
#import "StationAnnotation.h"
#import "TestViewController.h"

@interface FirstViewController : UIViewController<StationParserDelegate, ItemParserDelegate, MKMapViewDelegate> {
	StationParser * parser;
	ItemParser * itemparser;
	MapsAppDelegate * mapsAppDelegate;
	MKMapView * mapView;
	IBOutlet TestViewController * testView;
	}


@property(nonatomic,retain) StationParser * parser;
@property(nonatomic,retain) ItemParser * itemparser;
@property(nonatomic,retain) IBOutlet MKMapView * mapView;
@property(nonatomic,retain) IBOutlet MapsAppDelegate * mapsAppDelegate;
@property(nonatomic,retain) IBOutlet TestViewController *testView;


- (IBAction) myAction1:sender;
- (IBAction) annotationViewClick:(id)sender;
- (IBAction) annotationClick:(id) sender;
- (IBAction) favClick:(id)sender;

-(void)initMap:(NSArray *) stations;
-(NSArray *) initStations;
- (NSArray *) getItem : (NSString *) xid;

@end
