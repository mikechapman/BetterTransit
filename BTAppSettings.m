//
//  BTAppSettings.m
//  BetterTransit
//
//  Created by Yaogang Lian on 1/21/11.
//  Copyright 2011 Happen Next. All rights reserved.
//

#import "BTAppSettings.h"


@implementation BTAppSettings


+ (NSString *)startupScreen
{
	NSString *s = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_STARTUP_SCREEN];
	if (s == nil) {
		s = @"Nearby";
	}
	return s;
}

+ (NSString *)maxNumNearbyStops
{
	NSString *s = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_MAX_NUM_NEARBY_STOPS];
	if (s == nil) {
		s = @"10";
	}
	return s;
}

@end
