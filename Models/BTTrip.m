//
//  BTTrip.m
//  BetterTransit
//
//  Created by Yaogang Lian on 10/18/09.
//  Copyright 2009 HappenApps, Inc. All rights reserved.
//

#import "BTTrip.h"
#import "BTRoute.h"

@implementation BTTrip

@synthesize route, directionId, headsign, stops;

- (id)init
{
	if (self = [super init]) {
		stops = [[NSMutableArray alloc] init];
	}
	return self;
}

@end
