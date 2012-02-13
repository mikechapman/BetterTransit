//
//  PaPaTag.m
//
//  Created by Yaogang Lian on 2/11/12.
//  Copyright (c) 2012 Happen Apps, Inc. All rights reserved.
//

#import "PaPaTag.h"
#import "PaPaDoc.h"

@interface PaPaTag () {
@private
    xmlNodePtr _node;
    PaPaDoc * _doc;
}
- (NSArray *)performXPathQuery:(NSString *)query;
@end


@implementation PaPaTag


#pragma mark - Initialization

- (id)initWithNode:(xmlNodePtr)node inDoc:(PaPaDoc *)doc
{
    self = [super init];
    if (self) {
        _node = node;
        _doc = doc;
    }
    return self;
}


#pragma mark - Access properties

- (int)nodeType
{
    return _node->type; // XML_ELEMENT_NODE, XML_ATTRIBUTE_NODE, XML_TEXT_NODE ...
}

- (NSString *)tagName
{
    return [NSString stringWithUTF8String:(const char *)_node->name];
}

- (NSString *)content
{
    xmlChar * ret = xmlNodeListGetString(_node->doc, _node->children, 1);
    NSString * content = [NSString stringWithUTF8String:(const char *)ret];
    xmlFree(ret);
    return content;
}

- (NSDictionary *)attributes
{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    
    for (xmlAttrPtr attr = _node->properties; attr; attr = attr->next) {
        xmlChar * content = xmlNodeListGetString(_node->doc, attr->children, 1);
        [dict setObject:[NSString stringWithUTF8String:(const char *)content]
                 forKey:[NSString stringWithUTF8String:(const char *)attr->name]];
        xmlFree(content);
    }
    
    return [NSDictionary dictionaryWithDictionary:dict];;
}

- (NSString *)objectForKey:(NSString *)key
{
    return [[self attributes] objectForKey:key];
}


#pragma mark - Relationships to other tags

- (PaPaTag *)parent
{
    if (_node->parent) {
        return [[PaPaTag alloc] initWithNode:_node->parent inDoc:_doc];
    } else {
        return nil;
    }
}

- (NSArray *)children
{
    NSMutableArray * children = [NSMutableArray array];
    
    xmlNodePtr child;
    for (child = _node->children; child; child = child->next) {
        PaPaTag * tag = [[PaPaTag alloc] initWithNode:child inDoc:_doc];
        [children addObject:tag];
    }
    
    return children;
}

- (NSArray *)childrenWithTagName:(NSString *)name
{
    NSMutableArray * ret = [NSMutableArray array];
    xmlNodePtr child;
    for (child = _node->children; child; child = child->next) {
        //if (xmlStrcmp(children->name, (const xmlChar *)"Stories") == 0) {
        if (strcmp((char *)child->name, [name cStringUsingEncoding:NSUTF8StringEncoding])==0) {
            [ret addObject:[[PaPaTag alloc] initWithNode:child inDoc:_doc]];
        }
    }
    return [NSArray arrayWithArray:ret];
}

- (PaPaTag *)nextSibling
{
    if (_node->next) {
        return [[PaPaTag alloc] initWithNode:_node->next inDoc:_doc];
    } else {
        return nil;
    }
}

- (PaPaTag *)previousSibling
{
    if (_node->prev) {
        return [[PaPaTag alloc] initWithNode:_node->prev inDoc:_doc];
    } else {
        return nil;
    }
}


#pragma mark - Perform XPath queries

- (NSArray *)findAll:(NSString *)query
{
    return [self performXPathQuery:query];
}

- (PaPaTag *)find:(NSString *)query
{
    NSArray * results = [self performXPathQuery:query];
    if (results != nil || [results count] > 0) {
        return [results objectAtIndex:0];
    } else {
        return nil;
    }
}

- (NSArray *)performXPathQuery:(NSString *)query
{
    xmlXPathContextPtr ctx = [_doc xpathCtx];
    ctx->node = _node;
    
    xmlXPathObjectPtr xpathObj = xmlXPathEvalExpression((xmlChar *)[query cStringUsingEncoding:NSUTF8StringEncoding],  ctx);
    if (xpathObj == NULL) {
        NSLog(@"Unable to evaluate XPath.");
        return nil;
    }
    
    xmlNodeSetPtr nodes = xpathObj->nodesetval;
    if (!nodes) {
        NSLog(@"Nodes was nil.");
        xmlXPathFreeObject(xpathObj);
        return nil;
    }
    
    NSMutableArray * resultNodes = [NSMutableArray array];
    for (NSInteger i = 0; i < nodes->nodeNr; i++) {
        xmlNodePtr currentNode = nodes->nodeTab[i];
        PaPaTag * tag = [[PaPaTag alloc] initWithNode:currentNode inDoc:_doc];
        [resultNodes addObject:tag];
    }
    
    /* Cleanup */
    xmlXPathFreeObject(xpathObj);
    
    return [NSArray arrayWithArray:resultNodes];
}

@end
