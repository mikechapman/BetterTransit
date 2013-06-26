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
@synthesize hasSchedule;

- (id)init
{
	if (self = [super init]) {
        hasSchedule = NO;
	}
	return self;
}

- (NSComparisonResult)sortByShortName:(BTRoute *)other
{
    return [self.shortName compare:other.shortName options:NSCaseInsensitiveSearch];
}

@end
