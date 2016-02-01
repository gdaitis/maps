//
//  ItemParser.m
//  maps
//
//  Created by Andriukas on 2010-06-18.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ItemParser.h"


@implementation ItemParser

@synthesize currentItem;
@synthesize currentStation;
@synthesize currentItemValue;
@synthesize items;
@synthesize delegate;
@synthesize retrieverQueue;
@synthesize context;
@synthesize xid;

- (id)init{
	if(![super init]){
		return nil;
	}
	items = [[NSMutableArray alloc]init];
	return self;
}

- (id)initWithContext:(NSManagedObjectContext *) contextas andXid:(NSString *) xidas {
	if(![super init]){
		return nil;
	}
	items = [[NSMutableArray alloc]init];
	NSLog(@"initwithcontext");
	self.context = contextas;
	self.xid = xidas;
	NSLog(@"asdf");
	return self;
}


- (NSOperationQueue *)retrieverQueue {
	if(nil == retrieverQueue) {
		retrieverQueue = [[NSOperationQueue alloc] init];
		retrieverQueue.maxConcurrentOperationCount = 1;
	}
	return retrieverQueue;
}

- (void)startProcess{
	NSLog(@"Start proccess");
	SEL method = @selector(fetchAndParseRss);
	[[self items] removeAllObjects];
	NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self 
																	 selector:method 
																	   object:nil];
	[self.retrieverQueue addOperation:op];
	[op release];
}

-(BOOL)fetchAndParseRss{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	//To suppress the leak in NSXMLParser
	[[NSURLCache sharedURLCache] setMemoryCapacity:0];
	[[NSURLCache sharedURLCache] setDiskCapacity:0];
	//NSURL *url = [NSURL URLWithString:@"http://maps.321.lt/client.php?op=headsimple&ln=lt"];
	//NSString * xidas = [NSString stringWithFormat:@"http://localhost:8888/client.php?op=station&ln=lt&id=%@",xid];
	NSString * xidas = [NSString stringWithFormat:     @"http://maps.videoonline.lt/client.php?op=station&ln=lt&id=%@",xid];
	NSLog(xidas);
	NSURL *url = [NSURL URLWithString:xidas];
	// @"file:/%@//"
	
	//	NSString *FilePath = [[NSBundle mainBundle] pathForResource:@"stations" ofType:@"xml"];
	//	NSURL *url = [NSURL fileURLWithPath:FilePath];
	
	
	BOOL success = NO;
	NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
	[parser setDelegate:self];
	[parser setShouldProcessNamespaces:YES];
	[parser setShouldReportNamespacePrefixes:YES];
	[parser setShouldResolveExternalEntities:NO];
	//for (int j=0; j<1000; j++) {
		//NSLog(@"ADSF");	
	//}
	success = [parser parse];
	[parser release];
	[pool drain];
	return success;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI 
 qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict{
	if(nil != qualifiedName){
		elementName = qualifiedName;
	}
	//NSLog(elementName);
	if ([elementName isEqualToString:@"w"]) {
		//	NSEntityDescription *description = [NSEntityDescription entityForName:@"Station" 
		//												   inManagedObjectContext:context];
		self.currentItem = [NSEntityDescription insertNewObjectForEntityForName:@"Item"
														 inManagedObjectContext:context];		
		//		self.currentItem = [[[Station alloc]init]autorelease];
		//		self.currentItem = [delegate getManagedObjectContext];
	}else if ([elementName isEqualToString:@"media:thumbnail"]) {
		//		self.currentItem.mediaUrl = [attributeDict valueForKey:@"url"];
	} else if(
			  [elementName isEqualToString:@"t"] || 
			  [elementName isEqualToString:@"kt"] ||
			  [elementName isEqualToString:@"kk"] ||
			  [elementName isEqualToString:@"v"] ||
			  [elementName isEqualToString:@"rt"] ||
			  [elementName isEqualToString:@"at"] ||
			  [elementName isEqualToString:@"wm"] ||
			  [elementName isEqualToString:@"wd"] ||
			  [elementName isEqualToString:@"id"] ||
			  [elementName isEqualToString:@"wa"]
			  ) {
		self.currentItemValue = [NSMutableString string];
	} else {
		self.currentItemValue = nil;
	}	
	//NSLog(@"(");
	//NSLog(elementName);
	//NSLog(@")");
}


- (void)setXid:(NSString *) xidas {
	NSLog(@"naujas xidas");
	xid = xidas;
	NSLog(self.xid);
	
	NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Station"
														 inManagedObjectContext:context];
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSPredicate *predicate = [NSPredicate
							  predicateWithFormat:@"(xid == %@)",
							  xid];
	[request setEntity:entityDescription];
	//NSLog(@"naujas xidas2222");
	[request setPredicate:predicate];
	//	NSLog(@"There was an error!");
	NSError *error;
	NSArray *objects = [context executeFetchRequest:request error:&error];
	//NSLog(@"naujas xidasss");
	
	if (objects == nil)
	{
		NSLog(@"There was an error!");
		// Do whatever error handling is appropriate
	}
	if([objects count] > 0) {
		self.currentStation = [objects objectAtIndex:0];
	}
		
	//[request release];
	//[objects release];
	//[error release];
	//NSLog(@"set xid end");
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	//NSLog(@"END");
	if(nil != qName){
		elementName = qName;
	}
	if([elementName isEqualToString:@"ttttttttt"]){
	//	NSString *dateStr = @"20100223";
//		
//		// Convert string to date object
//		NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
//		[dateFormat setDateFormat:@"yyyyMMdd"];
//		NSDate *date = [dateFormat dateFromString:dateStr];  
//		[release date];
//		[release dateFormat];
//		
		[self.currentItem setValue:self.currentItemValue forKey:@"time"];
	}else if([elementName isEqualToString:@"at"]){
		[self.currentItem setValue:self.currentItemValue forKey:@"airTemp"];
	}else if([elementName isEqualToString:@"rt"]){
		[self.currentItem setValue:self.currentItemValue forKey:@"roadTemp"];
	}else if([elementName isEqualToString:@"wd"]){
		[self.currentItem setValue:self.currentItemValue forKey:@"windD"];
	}else if([elementName isEqualToString:@"wm"]){
		[self.currentItem setValue:self.currentItemValue forKey:@"windM"];
	}else if([elementName isEqualToString:@"wa"]){
		[self.currentItem setValue:self.currentItemValue forKey:@"windA"];
	}else if([elementName isEqualToString:@"kt"]){
		[self.currentItem setValue:self.currentItemValue forKey:@"kt"];
	}else if([elementName isEqualToString:@"kk"]){
		[self.currentItem setValue:self.currentItemValue forKey:@"kk"];
	}else if([elementName isEqualToString:@"v"]){
		[self.currentItem setValue:self.currentItemValue forKey:@"visibility"];
	}else if([elementName isEqualToString:@"link"]){
		//self.currentItem.linkUrl = self.currentItemValue;
	}else if([elementName isEqualToString:@"guid"]){
		//self.currentItem.guidUrl = self.currentItemValue;
	}else if([elementName isEqualToString:@"t"]){
		//NSLog(@"aaaaa");
		//NSLog(self.currentItemValue);
		
		//28-05 15:04
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
		[formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
		//NSDate * data = [NSDate date];
		[self.currentItem setValue:[formatter dateFromString:[@"2010-" stringByAppendingString: self.currentItemValue]] forKey:@"time"];
		
		//NSLog([[formatter dateFromString:@"2010-28-05 15:03"] description]);
		//NSLog(self.currentItemValue);
		
		[formatter release];
	}else if([elementName isEqualToString:@"w"]){
		[[self items] addObject:self.currentItem];
		[[self.currentStation mutableSetValueForKey:@"items"] addObject:self.currentItem];
		//NSLog([self.currentStation description]);
		//NSLog([self.currentItem description]);
		//[self.currentItem setValue:currentStation forKey:@"station"];
		//	NSArray * itemai = [self.currentItem valueForKey:@"items"];
	//	if(itemai == nil) {
	//			
	//	}
	//	[currentStation setValue:self.currentItem];		
	}
	//	NSLog(elementName);
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	if(nil != self.currentItemValue){
		[self.currentItemValue appendString:string];
	}
}

- (void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock{
	//Not needed for now
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
	if(parseError.code != NSXMLParserDelegateAbortedParseError) {
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
		[(id)[self delegate] performSelectorOnMainThread:@selector(processHasErrors)
		 withObject:nil
		 waitUntilDone:NO];
	}
}



- (void)parserDidEndDocument:(NSXMLParser *)parser {
	[(id)[self delegate] performSelectorOnMainThread:@selector(processItemCompleted)
	 withObject:nil
	 waitUntilDone:NO];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}


-(void)dealloc{
	self.currentItem = nil;
	self.currentItemValue = nil;
	self.delegate = nil;
	
	[items release];
	[super dealloc];
}




@end

