//
//  BTStop.m
//  BetterTransit
//
//  Created by Yaogang Lian on 10/16/09.
//  Copyright 2009 HappenApps, Inc. All rights reserved.
//

#import "BTStop.h"
#import "BTRoute.h"

@implementation BTStop

@synthesize stopId, stopCode, stopName, latitude, longitude;
@synthesize stopSource, stopColor, tileNumber, distance, favorite;
@synthesize selectedRoute;

- (id)init
{
	if (self = [super init]) {
		favorite = NO;
		tileNumber = 0;
		distance = -2.0;
		selectedRoute = nil;
        stopColor = 0;
	}
	return self;
}

@end
