//
//  BTTrip.m
//  BetterTransit
//
//  Created by Yaogang Lian on 10/18/09.
//  Copyright 2009 Happen Next. All rights reserved.
//

#import "BTTrip.h"

@implementation BTTrip

@synthesize route, directionId, headsign, stops;

- (id)init
{
	if (self = [super init]) {
		stops = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void)dealloc
{
	[route release], route = nil;
    [headsign release], headsign = nil;
    [stops release], stops = nil;
	[super dealloc];
}

@end
