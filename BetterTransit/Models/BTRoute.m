//
//  BTRoute.m
//  BetterTransit
//
//  Created by Yaogang Lian on 10/16/09.
//  Copyright 2009 Happen Next. All rights reserved.
//

#import "BTRoute.h"


@implementation BTRoute

@synthesize routeId, agencyId, shortName, longName;
@synthesize subroutes, stopLists, schedule;

- (id)init
{
	if (self = [super init]) {
		stopLists = nil;
	}
	return self;
}

- (void)dealloc
{
	[routeId release], routeId = nil;
    [agencyId release], agencyId = nil;
    [shortName release], shortName = nil;
    [longName release], longName = nil;
    
    [subroutes release], subroutes = nil;
    [stopLists release], stopLists = nil;
    [schedule release], schedule = nil;
	[super dealloc];
}

@end
