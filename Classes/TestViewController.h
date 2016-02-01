//
//  TestViewController.h
//  maps
//
//  Created by Andriukas on 2010-06-21.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "ItemInfoCellView.h"
#import	"ItemParser.h"
#import "MapsAppDelegate.h"

@interface TestViewController : UIViewController<UITableViewDelegate, UITableViewDataSource,ItemParserDelegate> {
	IBOutlet UILabel * label1;
	IBOutlet UILabel * label2;
	IBOutlet UIImageView *image;
	IBOutlet UITableView *tableView;
	ItemParser *parser;
	
	
	UIAlertView *alert;
	UIAlertView *alert2;
	NSManagedObject * stationItem;
	NSManagedObject * station;
	NSArray *listData;
	NSArray *keys;
	NSDictionary *dict;
	NSDictionary *windDict;
}

@property (nonatomic,retain) ItemParser *parser;
@property (nonatomic,retain) UIAlertView *alert;
@property (nonatomic,retain) UIAlertView *alert2;
@property (nonatomic, retain) NSArray *listData;
@property (nonatomic, retain) NSArray *keys;
@property (nonatomic, retain) NSDictionary *dict;
@property (nonatomic, retain) NSDictionary *windDict;

@property (nonatomic,retain) NSManagedObject * stationItem;
@property (nonatomic,retain) NSManagedObject * station;
@property (nonatomic,retain) IBOutlet UILabel * label1;
@property (nonatomic,retain) IBOutlet UILabel * label2;
@property (nonatomic,retain) IBOutlet UIImageView * image;
@property (nonatomic,retain) IBOutlet UITableView * tableView;

- (IBAction) mark:(id)sender;
- (IBAction) unmark:(id) sender;


@end
