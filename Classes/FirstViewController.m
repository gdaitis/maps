//
//  FirstViewController.m
//  Maps
//
//  Created by Andriukas on 2010-06-01.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "FirstViewController.h"


@implementation FirstViewController

@synthesize parser;
@synthesize itemparser;
@synthesize mapView;
@synthesize mapsAppDelegate;
@synthesize testView;


- (MKAnnotationView *)mapView:(MKMapView *)_mapView viewForAnnotation:(id <MKAnnotation>)annotation {
	MKPinAnnotationView *pinView = (MKPinAnnotationView*)[_mapView dequeueReusableAnnotationViewWithIdentifier:@"Pin"];
	if(pinView == nil) {
		pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Pin"];
		pinView.pinColor = MKPinAnnotationColorRed;
		pinView.animatesDrop = YES;
		pinView.canShowCallout = YES;
		UIImageView *leftIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[[[(StationAnnotation *)annotation station] valueForKey:@"road"] stringByAppendingString:@".png"]]];
		
		pinView.leftCalloutAccessoryView = leftIconView;
		UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
		[rightButton addTarget:self action:@selector(annotationClick:) forControlEvents:UIControlEventTouchUpInside];
		pinView.rightCalloutAccessoryView = rightButton;
	} else {
		pinView.annotation = annotation;
	}
	//NSLog(@"viewForAnn");
	return pinView;
}

- (IBAction) annotationViewClick:(id) sender {
//	NSLog([[[[[sender superview] superview] annotation] valueForKey:@"station"] valueForKey:@"name"]);
//	NSLog([[[[[sender superview] superview] annotation] valueForKey:@"station"] valueForKey:@"xid"]);
//    NSLog(@"clicked");
	[self getItem:[[[[[sender superview] superview] annotation] valueForKey:@"station"] valueForKey:@"xid"]];
}


- (IBAction) annotationClick:(id) sender {
	
	testView = [[TestViewController alloc] initWithNibName:@"TestViewController"
													bundle:nil];
	
	testView.station = [[[[sender superview] superview] annotation] valueForKey:@"station"];

	self.navigationItem.backBarButtonItem =
	[[UIBarButtonItem alloc] initWithTitle:@"Atgal"
									 style: UIBarButtonItemStyleBordered
									target:nil
									action:nil];
	
	
	[[self navigationController] pushViewController:testView animated:YES];
	
	
}


- (NSArray *) getItem : (NSString *) xid {
	
	NSLog(@"get station weather");
	
	MapsAppDelegate *appDelegate = (MapsAppDelegate *)[[UIApplication sharedApplication] delegate];	
	
	NSManagedObjectContext *context = [appDelegate managedObjectContext];
	NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Station"
														 inManagedObjectContext:context];
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSPredicate *predicate = [NSPredicate
							  predicateWithFormat:@"(xid == %@)",
							  xid];
	[request setEntity:entityDescription];
	
//	NSLog(@"asdfadsf");
	
	
	[request setPredicate:predicate];
	//	NSLog(@"There was an error!");
	NSError *error;
	NSArray *objects = [context executeFetchRequest:request error:&error];
	if (objects == nil)
	{
		NSLog(@"There was an error!");
		// Do whatever error handling is appropriate
	}
	if([objects count] > 0) {
//		NSLog(@"radom");
	//	NSLog(@"Starting stations parser");
		itemparser = [[ItemParser alloc]initWithContext:context andXid:xid];
		self.itemparser.delegate = self;
		[[self itemparser]startProcess];		
	//} else {
	//	[self initMap:objects];
	}
	
	//return nil;
	//[[self navigationController] pushViewController:testView animated:YES];
	return nil;
	
}


- (NSArray *) initStations {
	
	    NSLog(@"Init stations");
		
		MapsAppDelegate *appDelegate = (MapsAppDelegate *)[[UIApplication sharedApplication] delegate];	
		
		NSManagedObjectContext *context = [appDelegate managedObjectContext];
		NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Station"
															 inManagedObjectContext:context];
		NSFetchRequest *request = [[NSFetchRequest alloc] init];
		[request setEntity:entityDescription];
	//	NSLog(@"There was an error!");
		NSError *error;
		NSArray *objects = [context executeFetchRequest:request error:&error];
	if (objects == nil)
	{
		NSLog(@"There was an error!");
		// Do whatever error handling is appropriate
	}
	if([objects count] == 0) {
		NSLog(@"Starting stations parser");
		parser = [[StationParser alloc]initWithContext:context];
		self.parser.delegate = self;
		[[self parser]startProcess];		
	} else {
		[self initMap:objects];
	}
	
	return nil;
		
	
}


-(void) initMap:(NSArray *) objects {
	
	
	NSLog(@"Creating map");
	MKCoordinateRegion region;
	MKCoordinateSpan span;
	span.latitudeDelta=.0001f;
	span.longitudeDelta=.0001f;
//	
	CLLocationCoordinate2D location;
	location.latitude = 55.289478062f;
	location.longitude = 23.974742889f; 

	mapView.region = MKCoordinateRegionMakeWithDistance(location, 210000,210000);
	[mapView regionThatFits:region];
	
	for(NSManagedObject *station in objects) {
		CLLocationCoordinate2D newCoord = {55,23};
		//NSLog([[station valueForKey:@"latitude"] stringValue]);
		//NSLog([station valueForKey:@"road"]);
		StationAnnotation* annotation = [[StationAnnotation alloc] initWithCoordinate:newCoord andStation:station];
		[mapView addAnnotation:annotation];
		[annotation release];
	} 
	
//	
	
}

-(IBAction) myAction1:(id)sender {
	
	NSLog(@"Refresh stations");
	NSLog(@"Starting stations parser");
	MapsAppDelegate *appDelegate = (MapsAppDelegate *)[[UIApplication sharedApplication] delegate];	
	
	NSManagedObjectContext *context = [appDelegate managedObjectContext];
	
	parser = [[StationParser alloc]initWithContext:context];
	self.parser.delegate = self;
	[[self parser]startProcess];		
	
	
}


/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	[super loadView];
		[self.mapsAppDelegate.button setTitle:@"Adf"];
		[self.mapsAppDelegate.button setAction:@selector(favClick:)];
		[self.mapsAppDelegate.button setTarget:self];
	NSLog(@"loadView");
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"Oro sąlygos keliuose";
	[self.mapsAppDelegate.button setTitle:@"Adf"];
	[self.parentViewController.navigationItem.rightBarButtonItem setTitle:@"Adf"];
	[self.navigationController.navigationItem.rightBarButtonItem setTitle:@"AA"];
	[self.mapsAppDelegate.navController.navigationItem.rightBarButtonItem setAction:@selector(favClick:)];
	[self.navigationController.navigationItem.rightBarButtonItem setTarget:self];
		//self.navigationController
	[self initStations];
	
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

//Delegate method for blog parser will get fired when the process is completed
- (void)processCompleted{
	
	MapsAppDelegate *appDelegate = (MapsAppDelegate *)[[UIApplication sharedApplication] delegate];	
	
	NSManagedObjectContext *context = [appDelegate managedObjectContext];
	NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Station"
														 inManagedObjectContext:context];
	//NSManagedObject * newStation = [NSManagedObjectContext initW
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    if (objects == nil)
    {
        NSLog(@"There was an error!");
        // Do whatever error handling is appropriate
    }
            
    [request release];
    NSLog(@"saving stations to storage...");
	[context save:&error];
	
		//NSLog(@"ASDF");
	NSLog(@"initMaps after proccess complete");
	[self initMap:objects];
		//NSLog(@"ASDFADF");
	//}
	
	NSLog(@"completed");
}


//Delegate method for blog parser will get fired when the process is completed
- (void)processItemCompleted{

	MapsAppDelegate *appDelegate = (MapsAppDelegate *)[[UIApplication sharedApplication] delegate];	
	
	NSManagedObjectContext *context = [appDelegate managedObjectContext];
	NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Station"
														 inManagedObjectContext:context];
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];    
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    if (objects == nil)
    {
        NSLog(@"There was an error!");
        // Do whatever error handling is appropriate
    }
    [request release];
    NSLog(@"saving stations to storage...");
	[context save:&error];
	
	//NSLog(@"item completed");
	testView = [[TestViewController alloc] initWithNibName:@"TestViewController"
													bundle:nil];
	//NSLog([[self.itemparser.items objectAtIndex:0] description]);
	testView.stationItem = [self.itemparser.items objectAtIndex:0];
	//NSLog([testView.stationItem description]);
	//NSLog([[testView.stationItem valueForKey:@"station"] description]);
	self.navigationItem.backBarButtonItem =
	[[UIBarButtonItem alloc] initWithTitle:@"Atgal"
									 style: UIBarButtonItemStyleBordered
									target:nil
									action:nil];
	
	
	[[self navigationController] pushViewController:testView animated:YES];
	
}


-(void)processHasErrors{
		NSLog(@"internet error (server not responding or no internet connection)");
	//Might be due to Internet
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Klaida" message:@"Negalima parsiųsti duomenų. Patikrinkite interneto ryšį ir bandykite dar kartą."
												   delegate:nil cancelButtonTitle:@"Gerai" otherButtonTitles: nil];
	[alert show];	
	[alert release];
//	exit(0);
//	[self toggleToolBarButtons:YES];
}

- (IBAction) favClick:(id)sender{
	NSLog(@"as");
	
}

- (void)dealloc {
    [super dealloc];
}

@end
