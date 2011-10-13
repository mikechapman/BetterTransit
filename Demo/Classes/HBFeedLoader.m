//
//  HBFeedLoader.m
//  HoosBus
//
//  Created by Yaogang Lian on 10/1/09.
//  Copyright 2009 Yaogang Lian. All rights reserved.
//

#import "HBFeedLoader.h"
#import "NSString+Trim.h"

@implementation HBFeedLoader

@synthesize contentOfCurrentElement;
@synthesize currentRouteShortName, currentDestination, currentETA;


- (id)init
{
	if (self = [super init]) {
	}
	return self;
}

- (NSString *)dataSourceForStop:(BTStop *)stop
{
	return [NSString stringWithFormat:@"http://avlweb.charlottesville.org/RTT/Public/RoutePositionET.aspx?PlatformNo=%@&Referrer=uvamobile", stop.stopCode];
}


#pragma mark -
#pragma mark ASIHTTPRequest delegate methods

- (void)requestDidFinish:(ASIHTTPRequest *)request
{
	int requestType = [[[request userInfo] objectForKey:@"request_type"] intValue];
	if (requestType == REQUEST_TYPE_GET_FEED) {
		NSString *stringReply = [request responseString];
		//NSLog(@"%@", stringReply);
		NSRange range = [stringReply rangeOfString:@"Platform Estimated Time"];
		
		// Return nil if the feed can not be downloaded
		if (range.location == NSNotFound) {
			[self.delegate updatePrediction:nil];
			return;
		}
		
		// The feed has been acquired; start XML processing.
		// Reset self.prediction
		[self.prediction removeAllObjects];
		
		// Parse XML
		NSError *parseError = nil;
		[self parseXMLData:[request responseData] parseError:&parseError];
		
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
		[self.delegate updatePrediction:self.prediction];
	}
}


#pragma mark -
#pragma mark Parse XML

// HBFeedLoader uses NSXMLParser to map the contents of an XHTML document to an array of NSDictionaries
- (void)parseXMLData:(NSData *)xmlData parseError:(NSError **)error
{	
	NSXMLParser *parser = [[NSXMLParser alloc] initWithData:xmlData];
	[parser setDelegate:self];
	
	// Depending on the XML document you're parsing, you may want to enable these features of NSXMLParser.
    [parser setShouldProcessNamespaces:NO];
    [parser setShouldReportNamespacePrefixes:NO];
    [parser setShouldResolveExternalEntities:NO];
	
	tdCount = 0;
	[parser parse];
	
	NSError *parseError = [parser parserError];
    if (parseError && error) {
        *error = parseError;
    }
	
	[parser release];
}


#pragma mark -
#pragma mark XML parser delegate methods

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
	attributes:(NSDictionary *)attributeDict
{
	if ([elementName isEqualToString:@"td"]) {
		NSString *classAtt = [attributeDict valueForKey:@"id"];
		if (classAtt == nil)
			self.contentOfCurrentElement = [NSMutableString string];
		
	} else {
		// The element isn't one that we care about, so set the property that holds the 
        // character content of the current element to nil. That way, in the parser:foundCharacters:
        // callback, the string that the parser reports will be ignored.
		self.contentOfCurrentElement = nil;
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	if (self.contentOfCurrentElement) {
		// If the current element is one whose content we care about, append 'string'
        // to the property that holds the content of the current element.
		[self.contentOfCurrentElement appendString:string];
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	if ([elementName isEqualToString:@"td"]) {
		switch ((tdCount-1)%3) {
			case 0:
				self.currentRouteShortName = [contentOfCurrentElement trim];
				break;
			case 1:
				self.currentDestination = [contentOfCurrentElement trim];
				break;
			case 2:
				self.currentETA = [contentOfCurrentElement trim];
				break;
			default:
				break;
		}
		
		if (tdCount > 1 && (tdCount-1)%3 == 2) {
			// Check if the route id is valid
			if ([currentRouteShortName isEqualToString:@""]) return;
			
			// Check if this route already exists in time table
			BOOL routeAlreadyExists = NO;
            
			for (BTPredictionEntry *pe in self.prediction) {
				if ([currentRouteShortName isEqualToString:pe.route.shortName] && 
					[currentDestination isEqualToString:pe.destination]) {
					routeAlreadyExists = YES;
					NSString *newETA = [NSString stringWithFormat:@"%@, %@", pe.eta, currentETA];
					pe.eta = newETA;
					break;
				}
			}
			
			if (!routeAlreadyExists) {
                BTPredictionEntry * entry = [[BTPredictionEntry alloc] init];
                entry.route = [self.transit routeWithShortName:currentRouteShortName];
                entry.destination = currentDestination;
                entry.eta = currentETA;
                [self.prediction addObject:entry];
                [entry release];
			}
		}
		tdCount++;
	}
}

- (void)dealloc
{
	[contentOfCurrentElement release], contentOfCurrentElement = nil;
    [currentRouteShortName release], currentRouteShortName = nil;
    [currentDestination release], currentDestination = nil;
    [currentETA release], currentETA = nil;
	[super dealloc];
}

@end
