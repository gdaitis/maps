//
//  StationParser.m
//  maps
//
//  Created by Andriukas on 2010-06-07.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "StationParser.h"


@implementation StationParser

@synthesize currentItem;
@synthesize currentItemValue;
@synthesize items;
@synthesize delegate;
@synthesize retrieverQueue;
@synthesize context;


- (id)init{
	if(![super init]){
		return nil;
	}
	items = [[NSMutableArray alloc]init];
	return self;
}

- (id)initWithContext:(NSManagedObjectContext *) contextas {
	if(![super init]){
		return nil;
	}
	items = [[NSMutableArray alloc]init];
	NSLog(@"initwithcontext");
	self.context = contextas;
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
	
//	NSURL *url = [NSURL URLWithString:@"http://localhost:8888/client.php?op=headsimple&ln=lt"];
	NSURL *url = [NSURL URLWithString:@"http://maps.videoonline.lt/client.php?op=headsimple&ln=lt"];
	// @"file:/%@//"
	
//	NSString *FilePath = [[NSBundle mainBundle] pathForResource:@"stations" ofType:@"xml"];
//	NSURL *url = [NSURL fileURLWithPath:FilePath];
	
	
	BOOL success = NO;
	NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
	[parser setDelegate:self];
	[parser setShouldProcessNamespaces:YES];
	[parser setShouldReportNamespacePrefixes:YES];
	[parser setShouldResolveExternalEntities:NO];
	for (int j=0; j<1000; j++) {
		//NSLog(@"ADSF");	
	}
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
	if ([elementName isEqualToString:@"w"]) {
	//	NSEntityDescription *description = [NSEntityDescription entityForName:@"Station" 
	//												   inManagedObjectContext:context];
		self.currentItem = [NSEntityDescription insertNewObjectForEntityForName:@"Station"
														 inManagedObjectContext:context];		
//		self.currentItem = [[[Station alloc]init]autorelease];
//		self.currentItem = [delegate getManagedObjectContext];
	}else if ([elementName isEqualToString:@"media:thumbnail"]) {
//		self.currentItem.mediaUrl = [attributeDict valueForKey:@"url"];
	} else if(
			  [elementName isEqualToString:@"n"] || 
			  [elementName isEqualToString:@"d"] ||
			  [elementName isEqualToString:@"r"] ||
			  [elementName isEqualToString:@"ltt"] ||
			  [elementName isEqualToString:@"lng"] ||
			  [elementName isEqualToString:@"id"] 
			  ) {
		self.currentItemValue = [NSMutableString string];
	} else {
		self.currentItemValue = nil;
	}	
	//NSLog(@"(");
	//NSLog(elementName);
	//NSLog(@")");
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	//NSLog(@"END");
	if(nil != qName){
		elementName = qName;
	}
	if([elementName isEqualToString:@"n"]){
		[self.currentItem setValue:self.currentItemValue forKey:@"name"];
	}else if([elementName isEqualToString:@"r"]){
		[self.currentItem setValue:self.currentItemValue forKey:@"road"];
	}else if([elementName isEqualToString:@"d"]){
		[self.currentItem setValue:self.currentItemValue forKey:@"distance"];
	
	}else if([elementName isEqualToString:@"id"]){
		[self.currentItem setValue:self.currentItemValue forKey:@"xid"];
	}
	else if([elementName isEqualToString:@"ltt"]){
	//	NSLog(self.currentItemValue);
		NSNumber* volNum = [NSNumber numberWithFloat:[self.currentItemValue floatValue]];
		//NSLog(@"radom");
		[self.currentItem setValue:volNum forKey:@"latitude"];
	}
	else if([elementName isEqualToString:@"lng"]){
	//	NSLog(@"radom");
		NSNumber* volNum = [NSNumber numberWithFloat:[self.currentItemValue floatValue]];
		//NSLog(@"radom");
		[self.currentItem setValue:volNum forKey:@"longtitude"];
		
	//	[self.currentItem setValue:self.currentItemValue forKey:@"longtitude"];
	}
else if([elementName isEqualToString:@"link"]){
		//self.currentItem.linkUrl = self.currentItemValue;
	}else if([elementName isEqualToString:@"guid"]){
		//self.currentItem.guidUrl = self.currentItemValue;
	}else if([elementName isEqualToString:@"pubDate"]){
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
		[formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
		//self.currentItem.pubDate = [formatter dateFromString:self.currentItemValue];
		[formatter release];
	}else if([elementName isEqualToString:@"w"]){
	//	[self.currentItem mutableSetValueForKey:[NSArray array] forKey:@"items"];
		[self.currentItem setValue:@"0" forKey:@"favourite"];
		[[self items] addObject:self.currentItem];
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
	[(id)[self delegate] performSelectorOnMainThread:@selector(processCompleted)
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
