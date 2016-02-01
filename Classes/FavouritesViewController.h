//
//  FavouritesViewController.h
//  maps
//
//  Created by Andriukas on 2010-06-28.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "TestViewController.h"
#import "MapsAppDelegate.h"


@interface FavouritesViewController : UIViewController<UITableViewDelegate, UITableViewDataSource> {
	UITableView * tableView;
	NSArray *listData;
}

@property (nonatomic, retain) NSArray *listData;
@property (nonatomic,retain) IBOutlet UITableView *tableView;
-(IBAction) edit;
-(IBAction) done;
@end
