//
//  PaPaTag.h
//
//  Created by Yaogang Lian on 2/11/12.
//  Copyright (c) 2012 Happen Apps, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <libxml/tree.h>
#import <libxml/parser.h>
#import <libxml/HTMLparser.h>
#import <libxml/xpath.h>
#import <libxml/xpathInternals.h>

@class PaPaDoc;

@interface PaPaTag : NSObject

// Initialization
- (id)initWithNode:(xmlNodePtr)node inDoc:(PaPaDoc *)doc;

// Access properties
- (NSString *)content;
- (NSString *)tagName;
- (NSDictionary *)attributes;
- (NSString *)objectForKey:(NSString *)key;

// Relationships to other tags
- (PaPaTag *)parent;
- (NSArray *)children;
- (PaPaTag *)nextSibling;
- (PaPaTag *)previousSibling;
- (NSArray *)childrenWithTagName:(NSString *)name;

// Search with XPath queries
- (NSArray *)findAll:(NSString *)query;
- (PaPaTag *)find:(NSString *)query;

@end
