//
//  StationParser.h
//  maps
//
//  Created by Andriukas on 2010-06-07.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
//#import "Station.h"

@protocol StationParserDelegate <NSObject>

-(void)processCompleted;
-(void)processHasErrors;

@end



@interface StationParser : NSObject {
	NSManagedObject * currentItem;
	NSMutableString * currentItemValue;
	NSMutableArray * items;
	id<StationParserDelegate> delegate;
	NSOperationQueue *retrieverQueue;
	NSManagedObjectContext * context;

}

@property(nonatomic, retain) NSManagedObject * currentItem;
@property(nonatomic, retain) NSMutableString * currentItemValue;
@property(nonatomic, retain) NSManagedObjectContext * context;
@property(readonly) NSMutableArray * items;

@property(nonatomic, assign) id<StationParserDelegate> delegate;
@property(nonatomic, retain) NSOperationQueue *retrieverQueue;

- (void)startProcess;
- (id)initWithContext:(NSManagedObjectContext *) contextas;

@end

