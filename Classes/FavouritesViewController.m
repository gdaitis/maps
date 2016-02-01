//
//  FavouritesViewController.m
//  maps
//
//  Created by Andriukas on 2010-06-28.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FavouritesViewController.h"


@implementation FavouritesViewController

@synthesize listData;
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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/
- (void)viewWillAppear:(BOOL)animated {
	MapsAppDelegate *appDelegate = (MapsAppDelegate *)[[UIApplication sharedApplication] delegate];	

	NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Station"
														 inManagedObjectContext:appDelegate.managedObjectContext];
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];    
//	
	NSPredicate *predicate = [NSPredicate
							  predicateWithFormat:@"(favourite == '1')"];
	[request setPredicate:predicate];
//	
//	
    NSError *error;
    NSArray *objects = [appDelegate.managedObjectContext executeFetchRequest:request error:&error];
    if (objects == nil)
    {
        NSLog(@"There was an error!");
//        // Do whatever error handling is appropriate
    }
    [request release];
	NSLog(@"countas");
	NSLog([NSString stringWithFormat:@"%d",[self.listData count]]);
	NSLog([NSString stringWithFormat:@"%d",[objects count]]);
	self.listData = objects;
	[tableView reloadData];
	
	
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	//self.listData= [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:1], [NSNumber numberWithInt:2], [NSNumber numberWithInt:3], nil];
	
//	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle: @"Redaguoti" style:UIBarButtonItemStylePlain 
//																  target:self action:@selector(edit)];
//	
//	self.navigationItem.rightBarButtonItem = backButton;
	
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
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSUInteger row = [indexPath row];
	
	
	TestViewController * testView = [[TestViewController alloc] initWithNibName:@"TestViewController"
													bundle:nil];
//	//NSLog([[self.itemparser.items objectAtIndex:0] description]);
//	NSLog(@"loaps");
//	NSLog([[listData objectAtIndex:row] description]);
//		NSLog(@"loaps");
//	NSLog([listData description]);
//		NSLog(@"zdxfasdfasdfasdfadsfadsf");
	NSSet * arr = [[listData objectAtIndex:row] valueForKey:@"items"];
//	NSLog([[[arr allObjects] objectAtIndex:0] valueForKey:@"airTemp"]);
	
	//NSLog(@"loasdfadsfasdfaps");
	//NSLog([[listData objectAtIndex:row] description]);
	//NSLog(@"loaps");

	testView.station = [listData objectAtIndex:row];
//	testView.stationItem = [[arr allObjects] objectAtIndex:[[arr allObjects] count]-1];
	//NSLog([testView.stationItem description]);
	//NSLog([[testView.stationItem valueForKey:@"station"] description]);
	self.navigationItem.backBarButtonItem =
	[[UIBarButtonItem alloc] initWithTitle:@"Atgal"
									 style: UIBarButtonItemStyleBordered
									target:nil
									action:nil];
	
	
	[[self navigationController] pushViewController:testView animated:YES];
	
	
	
//  NSLog([[listData objectAtIndex:row] valueForKey:@"xid"]);
//	NSLog(@"clicked");	
	
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	
	static NSString *CellIdentifier = @"Cell";
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	
	cell.textLabel.text = [[self.listData objectAtIndex:[indexPath row]] valueForKey:@"name" ];
	
	return cell;
	
	
}


-(IBAction) edit {
	NSLog(@"edit clicked");
	[self.tableView setEditing:YES animated:YES];
	
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle: @"Atlikta" style:UIBarButtonItemStylePlain 
																  target:self action:@selector(done)];
	
	self.navigationItem.rightBarButtonItem = backButton;
	
	
//	[self.navigationController edit];
	
}

-(IBAction) done {
	NSLog(@"done clicked");
	[self.tableView setEditing:NO animated:YES];
	
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle: @"Redaguoti" style:UIBarButtonItemStylePlain 
																  target:self action:@selector(edit)];
	
	self.navigationItem.rightBarButtonItem = backButton;
	
	//	[self.navigationController edit];
	
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	[self.listData count];
}

@end
