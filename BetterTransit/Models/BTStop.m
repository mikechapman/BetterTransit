//
//  BTStop.m
//  BetterTransit
//
//  Created by Yaogang Lian on 10/16/09.
//  Copyright 2009 Happen Next. All rights reserved.
//

#import "BTStop.h"


@implementation BTStop

@synthesize stopId, stopCode, stopName, latitude, longitude;
@synthesize agencyId, tileNumber, distance, favorite;
@synthesize selectedRoute;

- (id)init
{
	if (self = [super init]) {
		favorite = NO;
		tileNumber = 0;
		distance = -2.0;
		selectedRoute = nil;
	}
	return self;
}

- (void)dealloc
{
	[stopId release], stopId = nil;
    [stopCode release], stopCode = nil;
    [stopName release], stopName = nil;
    [agencyId release], agencyId = nil;
	[selectedRoute release], selectedRoute = nil;
	[super dealloc];
}

@end
