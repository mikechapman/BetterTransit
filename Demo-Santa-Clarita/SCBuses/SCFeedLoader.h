//
//  SCFeedLoader.h
//  HoosBus
//
//  Created by Yaogang Lian on 10/1/09.
//  Copyright 2009 Yaogang Lian. All rights reserved.
//

#import "BTFeedLoader.h"
#import "BTPredictionEntry.h"

@interface SCFeedLoader : BTFeedLoader <NSXMLParserDelegate>
{
	NSMutableString *contentOfCurrentElement;
	NSUInteger tdCount;
}

@property (nonatomic, retain) NSMutableString *contentOfCurrentElement;
@property (nonatomic, retain) NSString * currentRouteShortName;
@property (nonatomic, retain) NSString * currentDestination;
@property (nonatomic, retain) NSString * currentETA;

- (void)parseXMLData:(NSData *)xmlData parseError:(NSError **)error;

// XML parser delegate methods
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName 
	attributes:(NSDictionary *)attributeDict;
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName;
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string;

@end