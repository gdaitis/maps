//
//  WeatherController.m
//  maps
//
//  Created by Andriukas on 2010-06-07.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "WeatherController.h"


@implementation WeatherController


-(NSArray *) initStations {
	
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
	
	
	
	return nil;
}



@end
