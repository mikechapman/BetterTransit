//
//  PaPaDoc.m
//
//  Created by Yaogang Lian on 2/11/12.
//  Copyright (c) 2012 Happen Apps, Inc. All rights reserved.
//

#import "PaPaDoc.h"
#import "PaPaTag.h"

@interface PaPaDoc () {
@private
    NSData * data;
    BOOL isXML;
    xmlDocPtr _doc;
    xmlNodePtr _rootNode;
    xmlXPathContextPtr _xpathCtx;
}
- (id)initWithData:(NSData *)d isXML:(BOOL)b;
@end


@implementation PaPaDoc

@synthesize rootTag;

+ (PaPaDoc *)docWithXMLData:(NSData *)data
{
    return [[[self class] alloc] initWithData:data isXML:YES];
}

+ (PaPaDoc *)docWithHTMLData:(NSData *)data
{
    return [[[self class] alloc] initWithData:data isXML:NO];
}


#pragma mark - Initialization

- (id)initWithData:(NSData *)d isXML:(BOOL)b
{
    self = [super init];
    if (self) {
        data = d;
        isXML = b;
        
        if (isXML) {
            _doc = xmlReadMemory([data bytes], (int)[data length], "", NULL, XML_PARSE_RECOVER);
        } else {
            _doc = htmlReadMemory([data bytes], (int)[data length], "", NULL, HTML_PARSE_NOWARNING | HTML_PARSE_NOERROR);
        }
        
        if (_doc == NULL) {
            NSLog(@"Unable to parse.");
            return nil;
        }
        
        _rootNode = xmlDocGetRootElement(_doc);
        if (_rootNode == NULL) {
            NSLog(@"empty document");
            xmlFreeDoc(_doc);
            return nil;
        }
        
        rootTag = [[PaPaTag alloc] initWithNode:_rootNode inDoc:self];
        
        /* Create xpath evaluation context */
        _xpathCtx = xmlXPathNewContext(_doc);
        if (_xpathCtx == NULL)
        {
            NSLog(@"Unable to create XPath context.");
            xmlFreeDoc(_doc);
            return nil;
        }
    }
    return self;
}

- (xmlXPathContextPtr)xpathCtx
{
    return _xpathCtx;
}

- (void)dealloc
{
    xmlXPathFreeContext(_xpathCtx);
    xmlFreeDoc(_doc);
}


// Search with XPath queries
- (NSArray *)findAll:(NSString *)query
{
    return [rootTag findAll:query];
}

- (PaPaTag *)find:(NSString *)query
{
    return [rootTag find:query];
}

@end
