//
//  BTStopList.m
//  BetterTransit
//
//  Created by Yaogang Lian on 10/18/09.
//  Copyright 2009 Happen Next. All rights reserved.
//

#import "BTStopList.h"


@implementation BTStopList

@synthesize route, listId, name, detail, stops;

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
	[route release];
	[listId release];
	[name release];
	[detail release];
	[stops release];
	[super dealloc];
}

@end
