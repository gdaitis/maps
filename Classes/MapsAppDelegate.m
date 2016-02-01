//
//  MapsAppDelegate.m
//  Maps
//
//  Created by Andriukas on 2010-06-01.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "MapsAppDelegate.h"


@implementation MapsAppDelegate

@synthesize window;
//@synthesize tabBarController;
@synthesize navController,button;

- (void)applicationDidFinishLaunching:(UIApplication *)application {
    
	//navController = (UINavigationController *)[UINavigationController initWithn
	
	
	
    // Add the tab bar controller's current view as a subview of the window
   // [window addSubview:navController.view];
	
	[window addSubview:[navController view]];
    [window makeKeyAndVisible];
}


- (void)applicationWillTerminate:(UIApplication *)application {	

	NSError * error;
  [[self managedObjectContext] save:&error];

	
}

/*
// Optional UITabBarControllerDelegate method
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
}
*/

/*
// Optional UITabBarControllerDelegate method
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed {
}
*/


#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *) managedObjectContext {
	
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
	
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return managedObjectContext;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel {
	
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
    return managedObjectModel;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	if (persistentStoreCoordinator != nil) {
		return persistentStoreCoordinator;
	}
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;

	
	NSString *storePath = [basePath stringByAppendingPathComponent: @"MapApp.sqlite"];
	/*
	 Set up the store.
	 For the sake of illustration, provide a pre-populated default store.
	 */
	NSFileManager *fileManager = [NSFileManager defaultManager];
	// If the expected store doesn’t exist, copy the default store.
	if (![fileManager fileExistsAtPath:storePath]) {
		//NSString *defaultStorePath = [[NSBundle mainBundle] pathForResource:@"MapApp" ofType:@"sqlite"];
		//if (defaultStorePath) {
		//	[fileManager copyItemAtPath:defaultStorePath toPath:storePath error:NULL];
		//}
		//NSLog(@"init stations at startup");
		//parser = [[StationParser alloc]init];
		//self.parser.delegate = self;
		//[[self parser]startProcess];
		
		NSLog(@"First Run...");
	}
	
	NSURL *storeUrl = [NSURL fileURLWithPath:storePath];
	NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
	persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
	
	NSError *error;
	if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:options error:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
	return persistentStoreCoordinator;
}


//- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
//	
//    if (persistentStoreCoordinator != nil) {
//        return persistentStoreCoordinator;
//    }
//	
//	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
//	
//    NSURL *storeUrl = [NSURL fileURLWithPath: [basePath stringByAppendingPathComponent: @"MapsApp.sqlite"]];
//	
//	NSError *error;
//    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
//    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
//        NSLog(@"error adding persistent store");
//        // Handle error
//    }    
//	
//    return persistentStoreCoordinator;
//}


- (IBAction) showFavourites:(id)sender {
	
	NSLog(@"shot faws:");
	
	NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Station"
														 inManagedObjectContext:self.managedObjectContext];
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];    
	
	NSPredicate *predicate = [NSPredicate
							  predicateWithFormat:@"(favourite == '1')"];
	[request setPredicate:predicate];
	
	
    NSError *error;
    NSArray *objects = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (objects == nil)
    {
        NSLog(@"There was an error!");
        // Do whatever error handling is appropriate
    }
    [request release];
//	[predicate release];
	
	
	
	//NSLog(@"item completed");
	FavouritesViewController * testView = [[FavouritesViewController alloc] initWithNibName:@"Favourites"
													bundle:nil];
	
	testView.listData = objects;
	//NSLog([[self.itemparser.items objectAtIndex:0] description]);
	//testView.stationItem = [self.itemparser.items objectAtIndex:0];
	//NSLog([testView.stationItem description]);
	//NSLog([[testView.stationItem valueForKey:@"station"] description]);
	
	[[self navController] pushViewController:testView animated:YES];
	
	
	NSLog(@"clicked");
	
}



- (void)dealloc {
  //  [tabBarController release];
    [window release];
    [super dealloc];
}

@end

