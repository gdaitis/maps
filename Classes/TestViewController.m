//
//  TestViewController.m
//  maps
//
//  Created by Andriukas on 2010-06-21.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TestViewController.h"


@implementation TestViewController
@synthesize stationItem,station;
@synthesize label1,label2,image;

@synthesize listData,keys,dict,windDict;
@synthesize parser;
@synthesize alert;
@synthesize alert2;

@synthesize tableView;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

-(void) viewWillAppear {
	

}






- (IBAction) mark:(id)sender {
//	[self.tableView setEditing:YES animated:YES];
	
//	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle: @"Pašalinti iž pažymėtų" style:UIBarButtonItemStylePlain 
//																  target:self action:@selector(done)];

	if([[[[[sender target] stationItem] valueForKey:@"station"] valueForKey:@"favourite"] isEqualToString:@"1"]){
		self.navigationItem.rightBarButtonItem.title =@"Pažymėti";			
		[[[[sender target] stationItem] valueForKey:@"station"] setValue:@"0" forKey:@"favourite"];
		
	} else {
		self.navigationItem.rightBarButtonItem.title =@"Pašalinti";	
		
		[[[[sender target] stationItem] valueForKey:@"station"] setValue:@"1" forKey:@"favourite"];
	}
	
	NSLog([[[[[sender target] stationItem] valueForKey:@"station"] valueForKey:@"favourite"] description]);
//	[stationItem 
}
- (IBAction) unmark:(id) sender{
	NSLog(@"unmark");
	
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	self.navigationItem.rightBarButtonItem =
	[[UIBarButtonItem alloc] initWithTitle:@"Pažymėti"
									 style: UIBarButtonItemStyleBordered
									target:self
									action:@selector(mark:)];
	
	
	alert = [[UIAlertView alloc] initWithTitle:nil message:@"Duomenys atnaujinami.\nPrašome palaukti"
												   delegate:nil cancelButtonTitle:@"Atšaukti" otherButtonTitles: nil];
	
	alert2 = [[UIAlertView alloc] initWithTitle:nil message:@"Nėra ryšio su serveriu.\nPatikrinkite prisijungima prie Interneto"
									  delegate:nil cancelButtonTitle:@"Gerai" otherButtonTitles: nil];

	
	if([[station valueForKey:@"items"] count] > 0){
		
		stationItem = [[[station valueForKey:@"items"] allObjects] objectAtIndex:[[[station valueForKey:@"items"] allObjects] count] -1 ];		
	
		if([[[stationItem valueForKey:@"station"] valueForKey:@"favourite"] isEqualToString:@"0"]){
		//		NSLog(@"parenkam pazymeti");
				self.navigationItem.rightBarButtonItem.title =@"Pažymėti";			
		} else {
		//	NSLog(@"parenkam atzymeti");
				self.navigationItem.rightBarButtonItem.title =@"Pašalinti";			
		}

	}
	
	NSArray *array = [[[stationItem entity] properties] valueForKey:@"name"];
	self.listData = array;

	self.title = [[stationItem valueForKey:@"station"] valueForKey:@"name"] ;	

	NSString *path = [[NSBundle mainBundle] pathForResource:@"StationViewSections" ofType:@"plist"];
	self.dict = [[NSDictionary alloc] initWithContentsOfFile:path];
	path = [[NSBundle mainBundle] pathForResource:@"WindDirections" ofType:@"plist"];
	self.windDict = [[NSDictionary alloc] initWithContentsOfFile:path];
	
	self.keys = [dict allKeys];
	NSLog([self.navigationItem description]);
	
	MapsAppDelegate *appDelegate = (MapsAppDelegate *)[[UIApplication sharedApplication] delegate];	
	
	NSManagedObjectContext *context = [appDelegate managedObjectContext];
	
	parser = [[ItemParser alloc]initWithContext:context andXid:[station valueForKey:@"xid"]];
	self.parser.delegate = self;
	[[self parser]startProcess];
	[alert	show ];
	
	[super viewDidLoad];
	
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
	///self.label1.text = @"PAvadinimas";
	//self.label2.text = @"Kitas pavadinimas";
	self.listData = nil;
	//NSLog(@"unkoad");
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[listData release];
    [super dealloc];
}

#pragma mark - #pragma mark Table View Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{ 
	return [[self.dict valueForKey:[keys objectAtIndex:section]] count]/2;
} 

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [self.keys count];
	
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{ 
	NSUInteger section = [indexPath section];
	
	section = [[[keys objectAtIndex:section] substringToIndex:1] integerValue];
			
	NSUInteger row = [indexPath row];
	
	static NSString *SectionsTableIdentifier = @"SectionsTableIdentifier";
	static NSString *SectionsTableIdentifier2 = @"SectionsTableIdentifier2";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: SectionsTableIdentifier];
	if([[[dict valueForKey:[keys objectAtIndex:section]] objectAtIndex:row*2] isEqualToString: @"kt"]){
		cell = [tableView dequeueReusableCellWithIdentifier: SectionsTableIdentifier2];

	}
	if (cell == nil) { 
		
		cell = [[[ItemInfoCellView alloc]
									initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:SectionsTableIdentifier] autorelease];
		//NSLog(@"section:");
		//NSLog(section);
		//NSLog(@"val");
		//NSLog([[dict valueForKey:[keys objectAtIndex:section]] objectAtIndex:row*2]);
		
		if([[[dict valueForKey:[keys objectAtIndex:section]] objectAtIndex:row*2] isEqualToString: @"kt"])
		{
			cell = [[[UITableViewCell alloc]
					 initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SectionsTableIdentifier2] autorelease];
			//NSLog(@"a");
			
		}
		//NSLog(@"kuriam celle");
	}
	
	if([[[dict valueForKey:[keys objectAtIndex:section]] objectAtIndex:row*2] isEqualToString: @"fav"])
	{	
		cell.textLabel.textAlignment = UITextAlignmentCenter;		
		cell.textLabel.text = @"bla";
		//		cell.textLabel.text = [NSString stringWithFormat:@"%@ (%@ mm/h)", [stationItem valueForKey:@"kt"],[stationItem valueForKey:@"kk"]];
		
	} else {
	
	
	//cell.textLabel.frame = CGRectMake(10, 100, 200, 25);
	cell.textLabel.text = [[[dict valueForKey:[keys objectAtIndex:section]] objectAtIndex:row*2+1] description]; 
	cell.textLabel.font = [cell.textLabel.font fontWithSize:14.0];
	cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
	cell.detailTextLabel.textAlignment = UITextAlignmentLeft;
	cell.detailTextLabel.text = [[stationItem valueForKey:[[[dict valueForKey:[keys objectAtIndex:section]] objectAtIndex:row*2] description]] description];
	//NSLog([[dict valueForKey:[keys objectAtIndex:section]] objectAtIndex:row*2]);
	if([[[dict valueForKey:[keys objectAtIndex:section]] objectAtIndex:row*2] isEqualToString: @"airTemp"] ||
       [[[dict valueForKey:[keys objectAtIndex:section]] objectAtIndex:row*2] isEqualToString: @"roadTemp"])
	{
		cell.detailTextLabel.text = [cell.detailTextLabel.text stringByAppendingString:@" °C"];
	}
	
	if([[[dict valueForKey:[keys objectAtIndex:section]] objectAtIndex:row*2] isEqualToString: @"windA"] ||
       [[[dict valueForKey:[keys objectAtIndex:section]] objectAtIndex:row*2] isEqualToString: @"windM"])
	{
		cell.detailTextLabel.text = [cell.detailTextLabel.text stringByAppendingString:@"m/s"];
	}
	
	
	if([[[dict valueForKey:[keys objectAtIndex:section]] objectAtIndex:row*2] isEqualToString: @"visibility"])
	{	
		cell.detailTextLabel.text = [cell.detailTextLabel.text stringByAppendingString:@"m"];		
		if([[stationItem valueForKey:@"visibility"] isEqualToString:@"-"]){
				cell.detailTextLabel.text = @"N/D";
		}
		
		if([[stationItem valueForKey:@"visibility"] isEqualToString:@"*"]){
			cell.detailTextLabel.text = @"Neribotas";
		}

	}
	
	
	if([[[dict valueForKey:[keys objectAtIndex:section]] objectAtIndex:row*2] isEqualToString: @"windD"])
	{	
		
		cell.detailTextLabel.text = [windDict valueForKey:cell.detailTextLabel.text];
	}
	
	if([[[dict valueForKey:[keys objectAtIndex:section]] objectAtIndex:row*2] isEqualToString: @"kt"])
	{	
		cell.textLabel.textAlignment = UITextAlignmentCenter;		
		if([[[stationItem valueForKey:[[[dict valueForKey:[keys objectAtIndex:section]] objectAtIndex:row*2] description]] description] isEqualToString:@"nėra"]){

			cell.textLabel.text = @"Kritulių nėra";
			cell.detailTextLabel.text = nil;
		} else {
			cell.textLabel.text = [[[stationItem valueForKey:[[[dict valueForKey:[keys objectAtIndex:section]] objectAtIndex:row*2] description]] description]
											stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[[[stationItem valueForKey:[[[dict valueForKey:[keys objectAtIndex:section]] objectAtIndex:row*2] description]] description] substringToIndex:1] uppercaseString]];
			if(stationItem != nil){
				cell.textLabel.text = [NSString stringWithFormat:@"%@ (%@ mm/h)", [stationItem valueForKey:@"kt"],[stationItem valueForKey:@"kk"]];
				cell.detailTextLabel.text = nil;
			} else{
				cell.textLabel.text = @"Nėra duomenų";
			}
		}
	}
	
	
	
	
	
	}	
	
	
	return cell;
	}
	
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if(section == 3){
		
		// grazinam tuscia pavadinima mygtuko sekcijai
			return @"";
	}
	for(NSString * key in keys){
		//NSLog([key substringToIndex:1]);
		if([[key substringToIndex:1] isEqualToString:[NSString stringWithFormat:@"%d", section]]){
			return [key substringFromIndex:1];
		}

			//return [section stringValue];
	}

	NSString *key = [keys objectAtIndex:section]; 
	return key;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
	if(section == [keys count]-1){
		if(stationItem != nil){
		NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
		[outputFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
		
		NSString *newDateString = [outputFormatter stringFromDate:[stationItem valueForKey:@"time"]]; 
		
		return [NSString stringWithFormat:@"Atnaujinta: %@ \nKelias: %@, %@ km",newDateString,
				[[[stationItem valueForKey:@"station"] valueForKey:@"road"]uppercaseString],				
				[[stationItem valueForKey:@"station"] valueForKey:@"distance"]
				];
		}
	}
	return nil;
	
}


-(void)processItemCompleted{
	NSLog(@"done parsing");
	self.stationItem = [self.parser.items objectAtIndex:0];
	[self.tableView reloadData];
	[alert dismissWithClickedButtonIndex:0 animated:NO];
}
	
-(void)processHasErrors{
	NSLog(@"error parsing");
	[alert dismissWithClickedButtonIndex:0 animated:NO];	
	[alert2 show];
	
}
@end
