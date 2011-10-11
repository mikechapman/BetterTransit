//
//  BTStopList.m
//  BetterTransit
//
//  Created by Yaogang Lian on 10/18/09.
//  Copyright 2009 Happen Next. All rights reserved.
//

#import "BTStopList.h"


@implementation BTStopList

@synthesize route, stops;
@synthesize listId, name, detail;

- (id)init
{
	if (self = [super init]) {
		listId = @"";
		name = @"";
		detail = @"";
		stops = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void)dealloc
{
	[route release], route = nil;
    [stops release], stops = nil;
	[listId release], listId = nil;
	[name release], name = nil;
	[detail release], detail = nil;
	[super dealloc];
}

@end
