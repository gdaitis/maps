//
//  MapsAppDelegate.h
//  Maps
//
//  Created by Andriukas on 2010-06-01.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "FavouritesViewController.h"

@interface MapsAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
   // UITabBarController *tabBarController;
	UINavigationController *navController;
	UIBarButtonItem *button;
	
	// core data variables
	NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;	    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
	
	
	
	
    
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
//@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) IBOutlet UINavigationController *navController;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *button;

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;


- (IBAction) showFavourites:(id)sender;

@end
