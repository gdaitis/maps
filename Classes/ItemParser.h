//
//  ItemParser.h
//  maps
//
//  Created by Andriukas on 2010-06-18.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
//#import "Station.h"

@protocol ItemParserDelegate <NSObject>

-(void)processItemCompleted;
-(void)processHasErrors;

@end



@interface ItemParser : NSObject {
	NSManagedObject * currentItem;
	NSManagedObject * currentStation;
	NSMutableString * currentItemValue;
	NSMutableArray * items;
	id<ItemParserDelegate> delegate;
	NSOperationQueue *retrieverQueue;
	NSManagedObjectContext * context;
	NSString * xid;
	
}

@property(nonatomic, retain) NSString * xid; 
@property(nonatomic, retain) NSManagedObject * currentItem;
@property(nonatomic, retain) NSManagedObject * currentStation;
@property(nonatomic, retain) NSMutableString * currentItemValue;
@property(nonatomic, retain) NSManagedObjectContext * context;
@property(readonly) NSMutableArray * items;

@property(nonatomic, assign) id<ItemParserDelegate> delegate;
@property(nonatomic, retain) NSOperationQueue *retrieverQueue;

- (void)startProcess;
- (id)initWithContext:(NSManagedObjectContext *) contextas andXid:(NSString *) xidas;

@end

